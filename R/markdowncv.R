#' Eliseo Papa's markdown-cv template
#'
#' Produces a CV in the HTML format using various styles of the markdown-cv
#' template: https://github.com/elipapa/markdown-cv
#'
#' @param \dots Arguments passed to \code{\link[vitae]{cv_document}}.
#' @param theme The style used in the CV (matches the prefix of CSS files). The
#'   "kjhealy" theme is inspired by [@kjhealy's vita template](https://github.com/kjhealy/kjh-vita),
#'   "blmoore" is from [@blmoore's md-cv template](https://github.com/blmoore/md-cv), and
#'   "davewhipp" is [@davewhipp's theme](https://github.com/davewhipp/markdown-cv) which
#'   notably has dates right aligned.
#'
#' @section Preview:
#' `r insert_preview("markdowncv")`
#'
#' @return An R Markdown output format object.
#'
#' @author Mitchell O'Hara-Wild, theme by Eliseo Papa
#' ([@elipapa](https://github.com/elipapa))
#'
#' @export
markdowncv <- function(..., theme = c("kjhealy", "blmoore", "davewhipp", "ccbaumler")) {
  theme <- match.arg(theme)
  template <- system.file("rmarkdown", "templates", "markdowncv",
                          "resources", "markdowncv.html",
                          package = "vitae")
  set_entry_formats(markdowncv_entries)
  copy_supporting_files("markdowncv")
  cv_document(..., pandoc_vars = list(theme = theme), mathjax = NULL,
              template = template,
              base_format = rmarkdown::html_document)
}


markdowncv_entries <- new_entry_formats(
  brief = function(what, when, with){
    glue_alt(
      "<p>`<<when>>`
<<what>> (<<with>>)</p>", collapse = "\n")
  },
  detailed = function(what, when, with, where, why){
    why <- lapply(why, function(x) {
      if(is_empty(x)) return("")
      x <- paste("<li>", x, "</li>", collapse = "\n")
      paste0("<ul>\n", x, "</ul>")
    })

    glue_alt(
"<p>`<<when>>`
__<<where>>__ <<what>> (<<with>>)
<<why>></p>", collapse = "\n")
  }
)
