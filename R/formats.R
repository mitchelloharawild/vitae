#' Output formats for CVs
#'
#' Each function is a wrapper for \code{\link[bookdown]{pdf_document2}} to
#' produce curriculum vitae
#'
#' @param \dots Arguments passed to \code{\link[bookdown]{pdf_document2}}.
#'
#' @return An R Markdown output format object.
#'
#' @author Rob J Hyndman
#'
#' @export
hyndman <- function(...) {
  template <- system.file("rmarkdown", "templates", "hyndman",
  	"resources", "hyndmantemplate.tex", package="vitae")
   bookdown::pdf_document2(..., template = template)
}
