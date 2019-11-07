--[[
multiple-bibliographies – create multiple bibliographies

Copyright © 2018-2019 Albert Krewinkel

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
]]
local List = require 'pandoc.List'
local utils = require 'pandoc.utils'
local stringify = utils.stringify
local run_json_filter = utils.run_json_filter

--- Collection of all cites in the document
local all_cites = {}
--- Document meta value
local doc_meta = pandoc.Meta{}

--- Div used by pandoc-citeproc to insert the bibliography.
local refs_div = pandoc.Div({}, pandoc.Attr('refs'))

local supports_quiet_flag = (function ()
  local version = pandoc.pipe('pandoc-citeproc', {'--version'}, '')
  local major, minor, patch = version:match 'pandoc%-citeproc (%d+)%.(%d+)%.?(%d*)'
  major, minor, patch = tonumber(major), tonumber(minor), tonumber(patch)
  return major > 0
    or minor > 14
    or (minor == 14 and patch >= 5)
end)()

--- Resolve citations in the document by combining all bibliographies
-- before running pandoc-citeproc on the full document.
local function resolve_doc_citations (doc)
  -- combine all bibliographies
  local meta = doc.meta
  local orig_bib = meta.bibliography
  meta.bibliography = pandoc.MetaList{orig_bib}
  for name, value in pairs(meta) do
    if name:match('^bibliography_') then
      table.insert(meta.bibliography, value)
    end
  end
  -- add dummy div to catch the created bibliography
  table.insert(doc.blocks, refs_div)
  -- resolve all citations
  doc = run_json_filter(doc, 'pandoc-citeproc')
  -- remove catch-all bibliography
  table.remove(doc.blocks)
  -- restore bibliography to original value
  doc.meta.bibliography = orig_bib
  return doc
end

--- Explicitly create a new meta object with all fields relevant for
--- pandoc-citeproc.
local function meta_for_pandoc_citeproc (bibliography)
  -- We could just indiscriminately copy all meta fields, but let's be
  -- explicit about what's important.
  local fields = {
    'bibliography', 'references', 'csl', 'citation-style',
    'link-citations', 'citation-abbreviations', 'lang',
    'suppress-bibliography', 'reference-section-title',
    'notes-after-punctuation', 'nocite'
  }
  local new_meta = pandoc.Meta{}
  for _, field in ipairs(fields) do
    new_meta[field] = doc_meta[field]
  end
  new_meta.bibliography = bibliography
  return new_meta
end

--- Create a bibliography for a given topic. This acts on all divs whose
-- ID starts with "refs", followed by nothing but underscores and
-- alphanumeric characters.
local function create_topic_bibliography (div)
  local name = div.identifier:match('^refs([_%w]*)$')
  local bibfile = name and doc_meta['bibliography' .. name]
  if not bibfile then
    return nil
  end
  local tmp_blocks = {pandoc.Para(all_cites), refs_div}
  local tmp_meta = meta_for_pandoc_citeproc(bibfile)
  local tmp_doc = pandoc.Pandoc(tmp_blocks, tmp_meta)
  local filter_args = {FORMAT, supports_quiet_flag and '-q' or nil}
  local res = run_json_filter(tmp_doc, 'pandoc-citeproc', filter_args)
  -- First block of the result contains the dummy paragraph, second is
  -- the refs Div filled by pandoc-citeproc.
  div.content = res.blocks[2].content
  return div
end

return {
  {
    -- Collect all citations and the doc's Meta value for other filters.
    Cite = function (c) all_cites[#all_cites + 1] = c end,
    Meta = function (m) doc_meta = m end,
  },
  { Pandoc = resolve_doc_citations },
  { Div = create_topic_bibliography },
}
