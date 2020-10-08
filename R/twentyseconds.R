#' @rdname cv_formats
#' @export
twentyseconds <- function(...) {
  template <- system.file("rmarkdown", "templates", "twentyseconds",
                          "resources", "twentysecondstemplate.tex",
                          package = "vitae"
  )
  set_entry_formats(twentyseconds_cv_entries)
  copy_supporting_files("twentyseconds")
  cv_document(..., template = template)
}


twentyseconds_cv_entries <- new_entry_formats(
  brief = function(what, when, with){
    paste(
      c(
        "\\nopagebreak\\begin{twentyshort}",
        glue_alt("\t\\twentyitemshort{<<when>>}{<<what>>. <<with>>}"),
        "\\end{twentyshort}"
      ),
      collapse = "\n"
    )
  },
  detailed = function(what, when, with, where, why){
    why <- lapply(why, function(x) {
      if(length(x) == 0) return("\\empty")
      paste(c(
        "\\begin{minipage}{0.7\\textwidth}%",
        "\\begin{itemize}%",
        paste0("\\item ", x, "%"),
        "\\end{itemize}%",
        "\\end{minipage}"
      ), collapse = "\n")
    })
    where <- ifelse(where == "", "\\empty", paste0(where, "\\par"))

    paste(c(
      "\\nopagebreak\\begin{twenty}",
      glue_alt("\t\\twentyitem{<<when>>}{<<what>>}{<<with>>}{<<where>><<why>>}"),
      "\\end{twenty}"
    ), collapse = "\n")
  }
)
