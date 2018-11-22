#' Output formats for CVs
#'
#' Each function is a wrapper for \code{\link[bookdown]{pdf_document2}} to
#' produce curriculum vitae
#'
#' @param template Name of template to be used.
#' @param \dots Arguments passed to \code{\link[bookdown]{pdf_document2}}.
#'
#' @return An R Markdown output format object.
#'
#' @author Rob J Hyndman
#'
#' @export
cv <- function(template="hyndman",...) {
  template <- system.file("rmarkdown", "templates", template, "resources",
    paste0(template, "template.tex"), package="vitae")
   bookdown::pdf_document2(...,
     template = template
   )
}


