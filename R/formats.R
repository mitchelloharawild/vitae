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
#' @rdname cv_formats
#'
#' @export
hyndman <- function(...) {
  template <- system.file("rmarkdown", "templates", "hyndman",
    "resources", "hyndmantemplate.tex",
    package = "vitae"
  )
  cv_document(..., template = template)
}

#' @rdname cv_formats
#' @export
twentyseconds <- function(...) {
  template <- system.file("rmarkdown", "templates", "twentyseconds",
    "resources", "twentysecondstemplate.tex",
    package = "vitae"
  )
  copy_supporting_files("twentyseconds")
  cv_document(..., template = template)
}

#' @rdname cv_formats
#' @export
awesomecv <- function(..., latex_engine = "xelatex") {
  template <- system.file("rmarkdown", "templates", "awesomecv",
    "resources", "awesome-cv.tex",
    package = "vitae"
  )
  copy_supporting_files("awesomecv")
  cv_document(..., template = template, latex_engine = latex_engine)
}

#' @rdname cv_formats
#'
#' @param theme The theme used for the template.
#'
#' @export
moderncv <- function(..., theme = c("casual", "classic", "oldstyle", "banking", "fancy"),
                     latex_engine = "pdflatex") {
  theme <- match.arg(theme)
  template <- system.file("rmarkdown", "templates", "moderncv",
    "resources", "moderncv.tex",
    package = "vitae"
  )
  copy_supporting_files("moderncv")
  cv_document(..., pandoc_vars = list(theme = theme),
              template = template, latex_engine = latex_engine)
}

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
