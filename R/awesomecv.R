#' @rdname cv_formats
#' @export
awesomecv <- function(..., latex_engine = "xelatex") {
  template <- system.file("rmarkdown", "templates", "awesomecv",
                          "resources", "awesome-cv.tex",
                          package = "vitae"
  )
  set_entry_formats(awesome_cv_entries)
  copy_supporting_files("awesomecv")
  cv_document(..., template = template, latex_engine = latex_engine)
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
        "\\vspace{-4mm}"
      } else {
        paste(c("\\begin{cvitems}", paste("\\item", x), "\\end{cvitems}"),
              collapse = "\n")
      }
    })

    paste(c(
      "\\begin{cventries}",
      glue_alt("\t\\cventry{<<what>>}{<<with>>}{<<where>>}{<<when>>}{<<why>>}"),
      "\\end{cventries}"
    ), collapse = "\n")
  }
)
