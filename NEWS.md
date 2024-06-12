# vitae 0.6.0

## New features

* Added the ccbaumler template for `markdowncv` (@ccbaumler, #250).

## Improvements

* Updated `markdowncv` academicons version (@ccbaumler, #250).
* Added more yaml front matter configuration options for `markdowncv` (@ccbaumler, #250).

## Bug fixes

* Fixed issue with multiple `brief_entries()` producing overlapping text in 
  `awesomecv` (#258).
* Fixed the body of the document being duplicated since knitr v1.46 (#254).

# vitae 0.5.4

* Fixed `bibliography_entries()` failing to render PDF outputs with recent 
  versions of pandoc (#246).

# vitae 0.5.3

Small release to resolve CRAN checks and removed dependency on the unmaintained 
rorcid package.

## Improvements

* Added support for pronouns in the all templates (@isabelle-greco, #204, #228).
* Added ORCID, ResearchGate, and Google Scholar icons for all CVs (@Rekyt, #209).

## Bug fixes

* Fixed footer not showing for awesomecv.

# vitae 0.5.2

## Improvements

* Added option to remove footer from `awesomecv` template (#182, #200).
* Match font style of text for bibliography entries in `awesomecv` template.

# vitae 0.5.1

## Improvements

* Fixed issue with bibliographies containing 'other-ids' (#174).
* Fixed encoding issues with `bibliography_entries()` on Windows (#158).
* Add fallback entry formatter as tibble.
* Fixed incorrect ORCID icon in `vitae::hyndman` template (#160).
* Added document and geometry options for `vitae::awesomecv` (#186).

# vitae 0.4.2

Small patch to resolve CRAN checks.

# vitae 0.4.1

This patch release reduces the suggested package dependencies and adds further
checks for an appropriate pandoc version.

# vitae 0.4.0

This release adds the first HTML template to the package, using the improved
templating system. The `bibliography_entires()` intermediate tibble output is
rewritten, which now fully represents the CSL-JSON schema.

## New templates

* Added the `vitae::markdowncv` template, which is the markdown-cv template in
  various themes by Eliseo Papa (@elipapa). This is the first HTML template 
  available in the package.

## Improvements

* Screenshot previews of the output formats can now be found in the README and 
  in the documentation for each output format (#72).
* Added tibble header to describe the output type in the document.
* Rewrote `bibliography_entries()` intermediate data format to better follow
  the CSL-JSON schema. This includes `csl_name()` and `csl_date()` helpers for
  parsing and manipulating bibliography data.

## Bug fixes

* Fixed "na.character" entries resulting in `bibliography_entries()` that differ
  in the fields used (#147).
* Fixed issue with underscores in moderncv template's Twitter social and updated
  template to use https. You will need to delete your moderncv.sty file to get
  these updates (#117).
* Fixed extra spacing in AwesomeCV when `why` input of `detailed_entries()` is 
  not used (#144).
* Specified minimum package versions for some more recent version dependencies.

# vitae 0.3.0

This release makes substantial changes to how bibliographies included in a
document. The package now uses pandoc-citeproc for handling bibliographies, 
rather than biblatex and the RefManageR package (partly due to CRAN archival).
This is more consistent with how bibliographies are generated in other rmarkdown
documents, and importantly it now allows custom CSL formats to be used (the most
common request). Another advantage of this change is that non-bib citation 
formats can now be used (including YAML and CSL-JSON), and that changes to the 
table are directly applied to the resulting bibliography output.

The same `bibliography_entires("/path/to/file.bib")` interface 
applies, however the result may now differ slightly:
1. The column names and structure of the intermediate tibble has been changed to
   better align with the CSL-JSON format used by pandoc. This allows the 
   modified contents of the tibble to be correctly reflected in the resulting 
   output.
2. The default style of the bibliographies is now the APA CV format, which is 
   similar but not identical to the previous default. This should be easier
   to customise now by providing a custom CSL (much like any other rmarkdown
   document).

Another advantage to moving to use pandoc-citeproc for bibliographies is that
templates for other output formats (like HTML and Word) can now be added.

More details can be found here: https://pkg.mitchelloharawild.com/vitae/reference/bibliography_entries.html

## Breaking changes

* The `startlabel` and `endlabel` arguments of `bibliography_entries()` are now
  defunct.
* The column names and structure of the `bibliography_entires()` tibble have
  changed for consistency with the CSL-JSON format. The mapping of commonly used
  column names are:
  - bibtype -> type (note that the values are converted to CSL-JSON format)
  - key -> id
  - year -> issued
* The default style of bibliography entries is now the APA CV format, which has
  been modified to match the order of the tibble, rather than the default of
  reverse chronological order. This bibliography style can be customised using 
  the csl argument in the yaml front matter.
  
## Improvements

* `bibliography_entries()` are now handled using a pandoc's cite-proc. This
  means that typical approaches for specifying CSL and other citeproc parameters
  will work as expected.
* The `citation_package` and `latex_engine` options are now changeable by users 
  for all output formats.
* The `why` argument of `detailed_entries()` can now optionally be provided as a
  list of characters.

# vitae 0.2.2

## Bug fixes

* This patch resolves knit issues introduced by tibble v3.0.0.

# vitae 0.2.1

## Bug fixes

* Fixed issue with `bibliography_entries()` not working on Windows.
* Fixed issue with using `brief_entires()` / `detailed_entries()` mismatching 
  argument order in variable names

# vitae 0.2.0

## Breaking changes

* Simplified `bibliography_entries` entries by removing `title` and `sorting`
  arguments. The title can be included using markdown, and sorting now respects
  the order of the tibble created by the function.

## Improvements

* Added theme support for `moderncv`: classic, banking, oldstyle, fancy.
* Added `latexcv` template using the classic theme.
* Added `docname` to change the document name (@chrisumphlett, #42).
* Added support for template specific formatting of surnames with `surname`.
* Added *Data sources for vitae* vignette for using CV data from extermal sources.
* Added surnames to bibliography_entries dataset.
* Improved usage of dplyr verbs for manipulating and re-ordering outputs.
* Extended skeleton template to include examples of using CV functions.
* Bugfixes and documentation improvements.

# vitae 0.1.0

First release of the package, containing:
* Four CV templates: `hyndman`, `twentyseconds`, `awesomecv`, `moderncv`.
* Three CV entries functions: `detailed_entries()`, `brief_entries()` and
  `bibliography_entries()`.
* Two vignettes: *Creating vitae templates* and *Introduction to vitae*.
