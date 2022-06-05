#' AcademiCL template
#'
#' AcademiCL is a LaTeX template for a cover letter based on pedrohbraga/AcademicCoverLetter-RMarkdown
#'
#' @param \dots Arguments passed to \code{\link[vitae]{cv_document}}.
#' @inheritParams rmarkdown::pdf_document
#' @param page_total If TRUE, the total number of pages is shown in the footer.
#' @param show_footer If TRUE, a footer showing your name, document name, and page number.
#'
#' @section Preview:
#' `r insert_preview('academicl')`
#'
#' @return An R Markdown output format object.
#'
#' @author Mitchell O'Hara-Wild, theme by Byungjin Park
#' ([@posquit0](https://github.com/posquit0))
#'
#' @export
academicl <- function(...) {
  template <- system.file("rmarkdown", "templates", "academicl", "resources", "academicl.tex",
    package = "vitae")
  set_entry_formats(academicl_cv_entries)
  copy_supporting_files("academicl")
  cv_document(..., template = template)
}
