#' latexcv cv and resume templates
#'
#' A collection of simple and easy to use, yet powerful LaTeX templates for CVs
#' and resumes: https://github.com/jankapunkt/latexcv
#'
#' @param theme The theme used for the template (previews in link above).
#' @param \dots Arguments passed to \code{\link[vitae]{cv_document}}.
#'
#' @section Preview:
#' `r insert_preview("latexcv")`
#'
#' @return An R Markdown output format object.
#'
#' @author Mitchell O'Hara-Wild, themes by Jan Küster
#' ([@jankapunkt](https://github.com/jankapunkt))
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
  set_entry_formats(latexcv_cv_entries)
  copy_supporting_files("latexcv")
  cv_document(..., template = template)
}

latexcv_cv_entries <- new_entry_formats(
  brief = function(what, when, with){
    paste(
      glue_alt("\\cvevent{<<when>>}{<<what>>}{<<with>>}{\\empty}{\\empty}"),
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
    where <- ifelse(where == "", "\\empty", paste("-", where))

    paste(
      glue_alt("\\cvevent{<<when>>}{<<what>>}{<<with>><<where>>}{<<why>>}"),
      collapse = "\n"
    )
  }
)
