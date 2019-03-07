#' CV entries
#'
#' This function accepts a data object (such as a tibble) and formats the output
#' into a suitable format for the template used. The inputs can also involve
#' further calculations, which will be done using the provided data.
#'
#' All non-data inputs are optional, and will result in an empty space if omitted.
#'
#' @param data A `data.frame` or `tibble`.
#' @param what The primary value of the entry (such as workplace title or degree).
#' @param when The time of the entry (such as the period spent in the role).
#' @param with The company or organisation.
#' @param where The location of the entry.
#' @param why Any additional information, to be included as dot points. Each
#' entry for why is provided in long form (where the what, when, with, and where
#' is duplicated)
#' @param .protect When TRUE, inputs to the previous arguments will be protected
#' from being parsed as LaTeX code.
#'
#' @name cv_entries
#' @rdname cv_entries
#'
#' @importFrom rlang enexpr expr_text !! := sym syms
#' @export
detailed_entries <- function(data, what, when, with, where, why, .protect = TRUE) {
  edu_exprs <- list(
    what = enexpr(what) %missing% NA,
    when = enexpr(when) %missing% NA,
    with = enexpr(with) %missing% NA,
    where = enexpr(where) %missing% NA,
    why = enexpr(why) %missing% NA
  )

  data <- dplyr::group_by(data, !!!edu_exprs[-5])
  out <- dplyr::distinct(data, !!!syms(names(edu_exprs)[-5]))
  data <- dplyr::summarise(data, "why" := compact_list(!!edu_exprs[["why"]]))
  out <- dplyr::left_join(out, data, by = names(edu_exprs[-5]))

  structure(out,
    preserve = names(edu_exprs),
    protect = .protect,
    class = c("vitae_detailed", "vitae_preserve", class(data))
  )
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_detailed <- function(x, options) {
  x[is.na(x)] <- ""

  if(!(x%@%"protect")){
    protect_tex_input <- identity
  }

  x <- dplyr::mutate(
    x,
    "why" := map_chr(!!sym("why"), function(x) {
      glue_collapse(
        glue("\\item{<<protect_tex_input(x)>>}", .open = "<<", .close = ">>")
      ) %empty% "\\empty"
    })
  )

  out <- glue_data(x,
    "\\detaileditem{<<protect_tex_input(what)>>}{<<protect_tex_input(when)>>}{<<protect_tex_input(with)>>}{<<protect_tex_input(where)>>}{<<why>>}",
    .open = "<<", .close = ">>"
  )

  knitr::asis_output(glue("\\detailedsection{<<glue_collapse(out)>>}",
    .open = "<<", .close = ">>"
  ))
}
