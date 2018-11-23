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
   bookdown::pdf_document2(..., template = template, citation_package="biblatex")
}

#' @rdname hyndman
#' @export
twentyseconds <- function(...) {
  template <- system.file("rmarkdown", "templates", "twentyseconds",
  	"resources", "twentysecondstemplate.tex", package="vitae")

  # Copy class and style files
  for (f in c("mariecurie.jpg","twentysecondcv.cls")) {
		  if (!file.exists(f)) {
    		file.copy(system.file("rmarkdown", "templates", "twentyseconds", "skeleton",
       		f, package="vitae"), ".", recursive=TRUE)
		  }
  }
   bookdown::pdf_document2(..., template = template, citation_package="biblatex")
}



#' @rdname hyndman
#' @export
awesomecv <- function(...) {
  template <- system.file("rmarkdown", "templates", "awesomecv",
                          "resources", "awesome-cv.tex", package="vitae")

  # Copy class and style files
  for (f in c("awesome-cv.cls", "fonts")) {
    if (!file.exists(f)) {
      file.copy(system.file("rmarkdown", "templates", "awesomecv", "skeleton",
                            f, package="vitae"), ".", recursive=TRUE)
    }
  }
  bookdown::pdf_document2(..., template = template, citation_package="biblatex", latex_engine="xelatex")
}
