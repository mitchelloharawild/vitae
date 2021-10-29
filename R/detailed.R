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
#' @param why Any additional information, to be included as dot points. Multiple
#' dot points can be provided via a list column.
#' Alternatively, if the same `what`, `when`, `with`, and `where` combinations
#' are found in multiple rows, the `why` entries of these rows will be combined
#' into a list.
#' @param .protect When TRUE, inputs to the previous arguments will be protected
#' from being parsed as LaTeX code.
#'
#' @name cv_entries
#' @rdname cv_entries
#'
#' @examples
#' packages_used <- tibble::tribble(
#'   ~ package, ~ date, ~ language, ~ timezone, ~ details,
#'   "vitae", Sys.Date(), "R", Sys.timezone(), c("Making my CV with vitae.", "Multiple why entries."),
#'   "rmarkdown", Sys.Date()-10, "R", Sys.timezone(), "Writing reproducible, dynamic reports using R."
#' )
#' packages_used %>%
#'   detailed_entries(what = package, when = date, with = language, where = timezone, why = details)
#'
#' @importFrom rlang enquo expr_text !! := sym syms
#' @export
detailed_entries <- function(data, what, when, with, where, why, .protect = TRUE) {
  edu_exprs <- list(
    what = enquo(what) %missing% NA_character_,
    when = enquo(when) %missing% NA_character_,
    with = enquo(with) %missing% NA_character_,
    where = enquo(where) %missing% NA_character_,
    why = enquo(why) %missing% NA_character_
  )

  edu_vars <- dplyr::as_tibble(map(edu_exprs[-5], eval_tidy, data = data))
  data[names(edu_vars)] <- edu_vars
  data <- dplyr::group_by(data, !!!syms(names(edu_vars)))
  out <- dplyr::distinct(data, !!!syms(names(edu_exprs)[-5]))
  data <- dplyr::summarise(data, "why" := compact_list(!!edu_exprs[["why"]]))
  out <- dplyr::left_join(out, data, by = names(edu_exprs[-5]))

  structure(out,
    preserve = names(edu_exprs),
    protect = .protect,
    class = c("vitae_detailed", "vitae_preserve", class(data))
  )
}

#' @importFrom tibble tbl_sum
#' @export
tbl_sum.vitae_detailed <- function(x) {
  x <- NextMethod()
  c(x, "vitae type" = "detailed entries")
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_detailed <- function(x, options) {
  if(is.null(entry_format_functions$format)) {
    warn("Detailed entry formatter is not defined for this output format.")
    return(knit_print(tibble::as_tibble(x)))
  }

  x[is.na(x)] <- ""

  if(!(x%@%"protect")){
    protect_tex_input <- identity
  }

  knitr::asis_output(
    entry_format_functions$format$detailed(
      protect_tex_input(x$what), protect_tex_input(x$when), protect_tex_input(x$with),
      protect_tex_input(x$where), lapply(x$why,protect_tex_input)
    )
  )
}
