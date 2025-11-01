#' Create honor entries
#'
#' @param data A `data.frame` or `tibble` containing the honor entries
#' @param what Honor title/achievement
#' @param when Date or time period of honor
#' @param with Organization/institution providing the honor
#' @param where Optional location of the honor
#' @param .protect Logical, if TRUE (default) protects special LaTeX characters in input
#'
#' @return Object of class \code{vitae_honor}
#' @importFrom rlang enexpr expr_text !!
#' @export
honor_entries <- function(data, what, when = NA, with = NA, where = NA, .protect = TRUE) {
  honor_exprs <- list(
    what = enquo(what) %missing% NA_character_,
    when = enquo(when) %missing% NA_character_,
    with = enquo(with) %missing% NA_character_,
    where = enquo(where) %missing% NA_character_
  )

  out <- dplyr::as_tibble(map(honor_exprs, eval_tidy, data = data))
  structure(out,
    preserve = names(honor_exprs),
    protect = .protect,
    class = c("vitae_honor", "vitae_preserve", class(data))
  )
}

#' @importFrom tibble tbl_sum
#' @export
tbl_sum.vitae_honor <- function(x) {
  x <- NextMethod()
  c(x, "vitae type" = "honor entries")
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_honor <- function(x, options, ...) {
  if(is.null(entry_format_functions$format)) {
    warn("Honor entry formatter is not defined for this output format.")
    return(knit_print(tibble::as_tibble(x)))
  }

  format <- entry_format_functions$format$honor
  if (is.null(format)) {
    warning("Honor format not supported for this template, using brief format instead")
    format <- entry_format_functions$format$brief
  }
  
  x[is.na(x)] <- ""

  if(!(x%@%"protect")){ # check protect attribute, %@% imported from rlang
    # original protect_tex_input is defined in utils.R
    protect_tex_input <- identity
  }

  knitr::asis_output(
    format(
      protect_tex_input(x$what), 
      protect_tex_input(x$when), 
      protect_tex_input(x$with),
      protect_tex_input(x$where)
    )
  )
}