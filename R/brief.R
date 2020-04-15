#' @rdname cv_entries
#' @importFrom rlang enexpr expr_text !!
#' @export
brief_entries <- function(data, what, when, with, .protect = TRUE) {
  edu_exprs <- list(
    what = enquo(what) %missing% NA_character_,
    when = enquo(when) %missing% NA_character_,
    with = enquo(with) %missing% NA_character_
  )

  out <- dplyr::as_tibble(map(edu_exprs, rlang::eval_tidy, data = data))
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
