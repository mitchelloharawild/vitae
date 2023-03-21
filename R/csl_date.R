#' A date conforming to the CSL schema
#'
#' This class provides helper utilities to display, sort, and select attributes
#' from a date in the CSL format.
#'
#' @param x A list of `csl_date()` values.
#' @param date_parts A list containing one or two dates in a list. Each date is
#'   also represented using lists in the format of `list(year, month, day)`.
#'   Different precision can be achieved by providing an incomplete list:
#'   `list(year, month)`. A range of dates can be specified by providing two
#'   dates, where the first date is the start and second date is the end of the
#'   interval.
#' @param season,circa,literal,raw,edtf Additional date variable properties as
#'   described in the schema.
#'
#' @seealso
#' <https://citeproc-js.readthedocs.io/en/latest/csl-json/markup.html#date-fields>
#'
#' @examples
#' # Single date
#' csl_date(date_parts = list(list(2020,03,05)))
#' # Date interval
#' csl_date(date_parts = list(list(2020,03,05), list(2020,08,25)))
#'
#' @keywords internal
#' @export
csl_date <- function(date_parts = list(), season = NULL, circa = NULL, literal = NULL, raw = NULL, edtf = NULL) {
  x <- list(`date-parts` = date_parts, season = season, circa = circa,
            literal = literal, raw = raw, edtf = edtf)
  new_csl_date(Filter(Negate(is.null), x), validate = FALSE)
}

csl_date_fields <- c("date-parts", "season", "circa", "literal", "raw", "edtf")

new_csl_date <- function(x, validate = TRUE) {
  if(!validate || all(names(x) %in% csl_date_fields)) {
    structure(x, class = "csl_date")
  } else {
    abort(sprintf("Unknown CSL date properties: %s.",
                  paste(setdiff(names(x), csl_date_fields), collapse = ", ")))
  }
}

#' @export
format.csl_date <- function(x, ...) {
  dates <- vapply(x[["date-parts"]], function(x) paste(vec_c(!!!x), collapse = "-"),
                  character(1))
  dates <- paste(dates, collapse = "/")
  dates
}

#' @export
print.csl_date <- function(x, ...) {
  cat(format(x, ...))
}

#' @export
vec_ptype_abbr.csl_dates <- function(x, ..., prefix_named = FALSE, suffix_shape = TRUE) "csl_date"

#' @export
as.Date.csl_date <- function(x, to, ...) {
  out <- c(1970, 1, 1)
  x <- vec_c(!!!x[["date-parts"]][[1]])
  out[seq_along(x)] <- x
  as.Date(paste(out, collapse = "-"))
}

#' @rdname csl_date
#' @export
csl_dates <- function(x = list()) {
  vctrs::new_vctr(lapply(x, new_csl_date), class = "csl_dates")
}

#' @export
vec_cast.csl_dates.list <- function(x, to, ...) {
  if("date-parts" %in% names(x)) x <- list(x)
  csl_dates(x)
}

#' @export
format.csl_dates <- function(x, ...) {
  vapply(x, format, character(1L), ...)
}
#' @export
vec_cast.Date.csl_dates <- function(x, to, ...) {
  vec_c(!!!lapply(x, as.Date))
}

#' @export
xtfrm.csl_dates <- function(x, ...) {
  xtfrm(as.Date(x))
}

#' @export
vec_proxy_order.csl_dates <- xtfrm.csl_dates
