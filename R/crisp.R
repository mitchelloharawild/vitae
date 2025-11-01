#' Crisp template (clean, modern resume)
#'
#' A clean, modern resume template with customizable typography and layout options.
#'
#' @param ... Arguments passed to \code{\link[vitae]{cv_document}}.
#' @inheritParams rmarkdown::pdf_document
#' @param page_total If TRUE, show total pages in footer.
#' @param show_footer If TRUE, include footer with name and page numbers.
#'
#' @section Preview:
#' `r insert_preview("crisp")`
#' 
#' @return An R Markdown output format object.
#'
#' @author Zhenguo Zhang
#'
#' @export
crisp <- function(..., latex_engine = "xelatex", page_total = FALSE,
                  show_footer = TRUE) {

  template <- system.file("rmarkdown", "templates", "crisp",
                          "resources", "crisp.tex",
                          package = "vitae"
  )

  set_entry_formats(crisp_entries)
  # Reuse supporting files (class, fonts) from the crisp skeleton
  # (the class file was renamed to crisp.cls)
  copy_supporting_files("crisp")
  pandoc_vars <- list()
  if(page_total) pandoc_vars$page_total <- TRUE
  if(show_footer) pandoc_vars$show_footer <- TRUE
  cv_document(..., pandoc_vars = pandoc_vars,
              template = template, latex_engine = latex_engine)
}

# these are the functions that generate the LaTeX code for different entry formats.
# if I want to define a new entry format, I need to create a new function here and
# then use set_entry_formats() to register it for use with the current template.
# For that to work, I also need to define a function to construct corresponding R
# objects so that the new entry format can be used in the Rmd document. But how?
# I found the clue: the key words "brief" and "detailed" in the new_entry_formats()
# are called in the knit_print.vitae_brief() and knit_print.vitae_detailed()
# functions in brief.R and detailed.R, respectively. So I can create new R functions
# similar to brief_entries() and detailed_entries() to create new entry types by assigning
# the class names accordingly, e.g., "vitae_compact" and "vitae_fancy", and then
# define knit_print.vitae_compact() and knit_print.vitae_fancy() functions to call the corresponding
# entry format functions defined here.
crisp_entries <- new_entry_formats(
  brief = function(what, when, with){
    paste(
      c(
        "\\begin{cvhonors}",
        # cvhonor takes 4 arguments: \cvhonor{<position>}{<title>}{<location>}{<date>}
        # so here we leave position empty
        glue_alt("\t\\cvhonor{}{<<what>>}{<<with>>}{<<when>>}"), 
        "\\end{cvhonors}"
      ),
      collapse = "\n"
    )
  },
  honor = function(what, when, with, where){
    paste(
      c(
        "\\begin{cvhonors}",
        # cvhonor takes 4 arguments: \cvhonor{<position>}{<title>}{<location>}{<date>}
        glue_alt("\t\\cvhonor{<<with>>}{<<what>>}{<<where>>}{<<when>>}"),
        "\\end{cvhonors}"
      ),
      collapse = "\n"
    )
  },
  skill = function(what, with){
    paste(
      c(
        "\\begin{cvskills}",
        # cvskill takes 2 arguments: \cvskill{<type>}{<skillset>}
        glue_alt("\t\\cvskill{<<what>>}{<<with>>}"),
        "\\end{cvskills}"
      ),
      collapse = "\n"
    )
  },
  detailed = function(what, when, with, where, why){
    # combine the 'why' items into a LaTeX cvitems environment for each entry.
    # when empty, output nothing
    why <- lapply(why, function(x) {
      if(length(x) == 0) {
        #"{}\\vspace{-4.0mm}"
        "{}"
      } else {
        paste(c("{\\begin{cvitems}", paste("\\item", x), "\\end{cvitems}}"),
              collapse = "\n")
      }
    })

    # usage: \cventry{<position>}{<title>}{<location>}{<date>}{<description>}
    paste(c(
      "\\begin{cventries}",
      glue_alt("\t\\cventry{<<what>>}{<<with>>}{<<where>>}{<<when>>}<<why>>"),
      "\\end{cventries}"
    ), collapse = "\n")
  }
)
