#' @rdname cv_formats
#' @export
hyndman <- function(...) {
  template <- system.file("rmarkdown", "templates", "hyndman",
                          "resources", "hyndmantemplate.tex",
                          package = "vitae"
  )
  set_entry_formats(hyndman_entries)
  cv_document(..., template = template)
}


hyndman_entries <- new_entry_formats(
  brief = function(what, when, with){
    paste(
      c(
        "\\begin{longtable}{@{\\extracolsep{\\fill}}ll}",
        glue_alt(
" <<when>> & \\parbox[t]{0.85\\textwidth}{%
  \\textbf{<<what>>}\\\\[-0.1cm]{\\footnotesize <<with>>}}\\\\[0.4cm]"),
        "\\end{longtable}"
      ),
      collapse = "\n"
    )
  },
  detailed = function(what, when, with, where, why){
    why <- lapply(why, function(x) {
      if(length(x) == 0) return("\\empty%")
      paste(c(
        "\\vspace{0.1cm}\\begin{minipage}{0.7\\textwidth}%",
        "\\begin{itemize}%",
        paste0("\\item ", x, "%"),
        "\\end{itemize}%",
        "\\end{minipage}%"
      ), collapse = "\n")
    })
    where <- ifelse(where == "", "\\empty%", paste0(where, "\\par%"))

    paste(c(
      "\\begin{longtable}{@{\\extracolsep{\\fill}}ll}",
      glue_alt(
"<<when>> & \\parbox[t]{0.85\\textwidth}{%
\\textbf{<<what>>}\\hfill{\\footnotesize <<with>>}\\newline
  <<where>>
  <<why>>
\\vspace{\\parsep}}\\\\"),
      "\\end{longtable}"
    ), collapse = "\n")
  }
)
