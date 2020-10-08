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
