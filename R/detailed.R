#' @importFrom rlang enexpr expr_text !!
#' @export
detailed_entries <- function(data, what, when, with, where, why){
  edu_exprs <- list(
    what = enexpr(what) %missing% NA,
    when = enexpr(when) %missing% NA,
    with = enexpr(with) %missing% NA,
    where = enexpr(where) %missing% NA,
    why = enexpr(why) %missing% NA
  )

  data <- dplyr::group_by(data, !!!edu_exprs[-5])
  data <- dplyr::summarise(data, "why" := compact_list(!!edu_exprs[["why"]]))
  data <- ungroup(data)

  add_class(data, "vitae_detailed")
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_detailed <- function(x, options){
  x <- dplyr::mutate(x,
                     "why" := map_chr(why, ~ glue_collapse(
                       glue("\\item{<<.x>>}", .open = "<<", .close = ">>")
                     ) %empty% "\\empty")
  )

  x[is.na(x)] <- ""

  out <- glue_data(x,
            "\\detaileditem
            {<<what>>}
            {<<when>>}
            {<<with>>}
            {<<where>>}
            {<<why>>}",
            .open = "<<", .close = ">>")

  knitr::asis_output(glue("\\detailedsection{<<glue_collapse(out)>>}",
                          .open = "<<", .close = ">>"))
}
