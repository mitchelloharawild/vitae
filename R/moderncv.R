#' Moderncv template
#'
#' Moderncv provides a documentclass for typesetting curricula vitae in various
#' styles. Moderncv aims to be both straightforward to use and customizable,
#' providing five ready-made styles (classic, casual, banking, oldstyle and
#' fancy): https://github.com/xdanaux/moderncv
#'
#' @param theme The theme used for the template.
#' @param \dots Arguments passed to \code{\link[vitae]{cv_document}}.
#' @inheritParams rmarkdown::pdf_document
#'
#' @section Preview:
#' `r insert_preview("moderncv")`
#'
#' @return An R Markdown output format object.
#'
#' @author Mitchell O'Hara-Wild, theme by Xavier Danaux
#' ([@xdanaux](https://github.com/xdanaux))
#'
#' @export
moderncv <- function(..., theme = c("casual", "classic", "oldstyle", "banking", "fancy"),
                     latex_engine = "xelatex") {
  theme <- match.arg(theme)
  template <- system.file("rmarkdown", "templates", "moderncv",
                          "resources", "moderncv.tex",
                          package = "vitae"
  )
  set_entry_formats(moderncv_cv_entries)
  copy_supporting_files("moderncv")
  cv_document(..., pandoc_vars = list(theme = theme),
              template = template, latex_engine = latex_engine)
}

moderncv_cv_entries <- new_entry_formats(
  brief = function(what, when, with){
    paste(
      c(
        "\\nopagebreak",
        glue_alt("\t\\cvitem{<<when>>}{<<what>>. <<with>>}")
      ),
      collapse = "\n"
    )
  },
  detailed = function(what, when, with, where, why){
    why <- lapply(why, function(x) {
      if(length(x) == 0) return("\\empty")
      paste(c(
        "\\begin{itemize}%",
        paste0("\\item ", x, "%"),
        "\\end{itemize}"
      ), collapse = "\n")
    })

    paste(c(
      "\\nopagebreak",
      glue_alt("\t\\cventry{<<when>>}{<<what>>}{<<with>>}{<<where>>}{}{<<why>>}")
    ), collapse = "\n")
  }
)
