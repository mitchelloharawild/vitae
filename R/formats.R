#' Output formats for CVs
#'
#' Each function is a wrapper for \code{\link[vitae]{cv_document}} to
#' produce curriculum vitae
#'
#' @param \dots Arguments passed to \code{\link[vitae]{cv_document}}.
#' @inheritParams rmarkdown::pdf_document
#'
#' @return An R Markdown output format object.
#'
#' @author Mitchell O'Hara-Wild and Rob J Hyndman
#'
#' @name cv_formats
#'
NULL

#' @rdname cv_formats
#'
#' @export
latexcv <- function(..., theme = c("classic", "modern", "rows", "sidebar", "two_column")) {
  theme <- match.arg(theme)
  if(theme != "classic"){
    stop("Only the classic theme is currently supported.")
  }
  template <- system.file("rmarkdown", "templates", "latexcv",
                          "resources", theme, "main.tex",
                          package = "vitae"
  )
  copy_supporting_files("latexcv")
  cv_document(..., template = template)
}
