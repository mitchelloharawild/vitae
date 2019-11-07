#' CV entries
#' 
#' This function accepts a data object (such as a tibble) and formats the
#' output into a suitable format for the template used. The inputs can also
#' involve further calculations, which will be done using the provided data.
#' 
#' All non-data inputs are optional, and will result in an empty space if
#' omitted.
#' 
#' @aliases brief_entries cv_entries detailed_entries
#' @param data A \code{data.frame} or \code{tibble}.
#' @param what The primary value of the entry (such as workplace title or
#' degree).
#' @param when The time of the entry (such as the period spent in the role).
#' @param with The company or organisation.
#' @param .protect When TRUE, inputs to the previous arguments will be
#' protected from being parsed as LaTeX code.
#' @param where The location of the entry.
#' @param why Any additional information, to be included as dot points. Each
#' entry for why is provided in long form (where the what, when, with, and
#' where is duplicated)
#' @export brief_entries
brief_entries <- function(data, what, when, with, .protect = TRUE) {
  edu_exprs <- list(
    what = enexpr(what) %missing% NA,
    when = enexpr(when) %missing% NA,
    with = enexpr(with) %missing% NA
  )

  out <- dplyr::transmute(data, !!!edu_exprs)
  structure(out,
    preserve = names(edu_exprs),
    protect = .protect,
    class = c("vitae_brief", "vitae_preserve", class(data))
  )
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_brief <- function(x, options) {
  x[is.na(x)] <- ""

  if(!(x%@%"protect")){
    protect_tex_input <- identity
  }

  out <- glue_data(x, "\\briefitem{<<protect_tex_input(what)>>}{<<protect_tex_input(when)>>}{<<protect_tex_input(with)>>}",
    .open = "<<", .close = ">>"
  )

  knitr::asis_output(glue("\\briefsection{<<glue_collapse(out)>>}",
    .open = "<<", .close = ">>"
  ))
}
