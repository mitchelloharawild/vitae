#' @importFrom rlang enexpr expr_text !!
#' @export
brief_entries <- function(data, what, when, with){
  edu_exprs <- list(
    what = enexpr(what) %missing% NA,
    when = enexpr(when) %missing% NA,
    with = enexpr(with) %missing% NA
  )

  data <- dplyr::transmute(data,  !!!edu_exprs)

  add_class(data, "vitae_brief")
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_brief <- function(x, options){
  x[is.na(x)] <- ""

  out <- glue_data(x, "\\briefitem{<<protect_tex_input(what)>>}{<<protect_tex_input(when)>>}{<<protect_tex_input(with)>>}",
                   .open = "<<", .close = ">>")

  knitr::asis_output(glue("\\briefsection{<<glue_collapse(out)>>}",
                          .open = "<<", .close = ">>"))
}
