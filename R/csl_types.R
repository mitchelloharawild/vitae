#' A list of names conforming to the CSL schema
#'
#' This class provides helper utilities to display, sort, and select attributes
#' from a name in the CSL format.
#'
#' @param x A list of names conforming to the structure outlined in the CSL schema
#'
#' @seealso
#' <https://citeproc-js.readthedocs.io/en/latest/csl-json/markup.html#name-fields>
#'
#' @export
csl_name <- function(x) {
  vctrs::new_vctr(x, class = "csl_name")
}

csl_name_fields <- c("dropping-particle", "non-dropping-particle", "given", "family", "literal", "suffix")

display_name <- function(name) {
  do.call(paste, Filter(Negate(is.null), name[csl_name_fields]))
}

#' @export
names.csl_name <- function(x) csl_name_fields

#' @export
`$.csl_name` <- function(x, name) {
  vapply(x, function(authors) {
    authors <- vapply(authors, function(author, field) {
      if(field %in% names(author)) author[[field]] else NA_character_
    }, character(1L), field = name)
    paste(authors[!is.na(authors)], collapse = ", ")
  }, character(1L))
}

#' @export
format.csl_name <- function(x, ...) {
  vapply(x, function(authors) {
    paste(vapply(authors, display_name, character(1L)), collapse = ", ")
  }, character(1L))
}

#' @importFrom vctrs vec_ptype_abbr
#' @method vec_ptype_abbr csl_name
#' @export
vec_ptype_abbr.csl_name <- function(x) "csl name"

#' @export
xtfrm.csl_name <- function(x) {
  xtfrm(format(x))
}

#' @importFrom vctrs vec_proxy_order
#' @method vec_proxy_order csl_name
#' @export
vec_proxy_order.csl_name <- xtfrm.csl_name


#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.csl_name <- function(x, ...) {
  pillar::new_pillar_shaft_simple(format(x), align = "left", min_width = 10)
}

#' A list of dates conforming to the CSL schema
#'
#' This class provides helper utilities to display, sort, and select attributes
#' from a date in the CSL format.
#'
#' @param x A list of dates conforming to the structure outlined in the CSL schema
#'
#' @seealso
#' <https://citeproc-js.readthedocs.io/en/latest/csl-json/markup.html#date-fields>
#'
#' @export
csl_date <- function(x) {
  vctrs::new_vctr(x, class = "csl_date")
}

#' @export
format.csl_date <- function(x, ...) {
  vapply(x, function(date) {
    paste(vctrs::vec_c(!!!date), collapse = "-")
  }, character(1L))
}

#' @importFrom vctrs vec_ptype_abbr
#' @method vec_ptype_abbr csl_date
#' @export
vec_ptype_abbr.csl_date <- function(x) "csl_date"

#' @export
xtfrm.csl_date <- function(x) {
  vapply(x, function(x) if(is.null(x)) NA_real_ else x[[1]][[1]], numeric(1L))
}

#' @importFrom vctrs vec_proxy_order
#' @method vec_proxy_order csl_date
#' @export
vec_proxy_order.csl_date <- xtfrm.csl_date
