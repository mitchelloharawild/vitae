#' Awesome CV template
#'
#' Awesome CV is LaTeX template for a CV or Résumé inspired by
#' [Fancy CV](https://www.overleaf.com/latex/templates/friggeri-cv-template/hmnchbfmjgqh):
#' https://github.com/posquit0/Awesome-CV
#'
#' @param \dots Arguments passed to \code{\link[vitae]{cv_document}}.
#' @inheritParams rmarkdown::pdf_document
#' @param page_total If TRUE, the total number of pages is shown in the footer.
#' @param show_footer If TRUE, a footer showing your name, document name, and page number.
#'
#' @section Preview:
#' `r insert_preview("awesomecv")`
#'
#' @return An R Markdown output format object.
#'
#' @author Mitchell O'Hara-Wild, theme by Byungjin Park
#' ([@posquit0](https://github.com/posquit0))
#'
#' @export
awesomecv <- function(..., latex_engine = "xelatex", page_total = FALSE,
                      show_footer = TRUE) {
  template <- system.file("rmarkdown", "templates", "awesomecv",
                          "resources", "awesome-cv.tex",
                          package = "vitae"
  )
  set_entry_formats(awesome_cv_entries)
  copy_supporting_files("awesomecv")
  pandoc_vars <- list()
  if(page_total) pandoc_vars$page_total <- TRUE
  if(show_footer) pandoc_vars$show_footer <- TRUE
  cv_document(..., pandoc_vars = pandoc_vars,
              template = template, latex_engine = latex_engine)
}

awesome_cv_entries <- new_entry_formats(
  brief = function(what, when, with){
    paste(
      c(
        "\\begin{cvhonors}",
        glue_alt("\t\\cvhonor{}{<<what>>}{<<with>>}{<<when>>}"),
        "\\end{cvhonors}"
      ),
      collapse = "\n"
    )
  },
  detailed = function(what, when, with, where, why){
    why <- lapply(why, function(x) {
      if(length(x) == 0) {
        "{}\\vspace{-4.0mm}"
      } else {
        paste(c("{\\begin{cvitems}", paste("\\item", x), "\\end{cvitems}}"),
              collapse = "\n")
      }
    })

    paste(c(
      "\\begin{cventries}",
      glue_alt("\t\\cventry{<<what>>}{<<with>>}{<<where>>}{<<when>>}<<why>>"),
      "\\end{cventries}"
    ), collapse = "\n")
  }
)
