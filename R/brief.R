#' @rdname cv_entries
#' @importFrom rlang enexpr expr_text !!
#' @export
brief_entries <- function(data, what, when, with, .protect = TRUE) {
  edu_exprs <- list(
    what = enquo(what) %missing% NA_character_,
    when = enquo(when) %missing% NA_character_,
    with = enquo(with) %missing% NA_character_
  )

  out <- dplyr::as_tibble(map(edu_exprs, eval_tidy, data = data))
  structure(out,
    preserve = names(edu_exprs),
    protect = .protect,
    class = c("vitae_brief", "vitae_preserve", class(data))
  )
}

#' @importFrom tibble tbl_sum
#' @export
tbl_sum.vitae_brief <- function(x) {
  x <- NextMethod()
  c(x, "vitae type" = "brief entries")
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_brief <- function(x, options) {
  x[is.na(x)] <- ""

  if(!(x%@%"protect")){
    protect_tex_input <- identity
  }

  knitr::asis_output(
    entry_format_functions$format$brief(
      protect_tex_input(x$what), protect_tex_input(x$when), protect_tex_input(x$with)
    )
  )

}
