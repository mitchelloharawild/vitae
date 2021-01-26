#' A name variable conforming to the CSL schema
#'
#' This class provides helper utilities to display, sort, and select attributes
#' from a name in the CSL format.
#'
#' @param x For `csl_name()`, `x` should be a list of `csl_name()`. For
#'   `list_of_csl_names()`, `x` should be a list of `csl_names()`.
#' @param family The family name
#' @param given The given name
#' @param dropping_particle,non_dropping_particle,suffix,comma_suffix,static_ordering,literal,parse_names Additional
#'   name variable properties as described in the schema.
#'
#' @seealso
#' <https://citeproc-js.readthedocs.io/en/latest/csl-json/markup.html#name-fields>
#'
#' @export
csl_name <- function(family = NULL, given = NULL, dropping_particle = NULL,
                     non_dropping_particle = NULL, suffix = NULL,
                     comma_suffix = NULL, static_ordering = NULL,
                     literal = NULL, parse_names = NULL) {
  x <- list(
    family = family, given = given, `dropping-particle` = dropping_particle,
    `non-dropping-particle` = non_dropping_particle, suffix = suffix,
    `comma-suffix` = comma_suffix, `static-ordering` = static_ordering,
    literal = literal, `parse-names` = parse_names
  )
  new_csl_name(Filter(Negate(is.null), x), validate = FALSE)
}

csl_name_fields <- c("family", "given", "dropping-particle", "non-dropping-particle",
                     "suffix", "comma-suffix", "static-ordering", "literal", "parse-names")

new_csl_name <- function(x, validate = TRUE) {
  if(!validate || all(names(x) %in% csl_name_fields)) {
    structure(x, class = "csl_name")
  } else {
    abort(sprintf("Unknown CSL name properties: %s.",
                  paste(setdiff(names(x), csl_name_fields), collapse = ", ")))
  }
}

#' @export
format.csl_name <- function(x, ...) {
  fmt <- x[c("non-dropping-particle", "dropping-particle", "given", "family", "suffix", "literal")]
  format(paste(Filter(Negate(is.null), fmt), collapse = " "), ...)
}

#' @export
print.csl_name <- function(x, ...) {
  cat(format(x, ...))
}

#' @rdname csl_name
#' @export
csl_names <- function(x = list()) {
  vctrs::new_vctr(lapply(x, new_csl_name), class = "csl_names")
}

#' @export
format.csl_names <- function(x, ...) {
  vapply(x, format, character(1L), ...)
}

#' @rdname csl_name
#' @export
list_of_csl_names <- function(x = list()) {
  new_list_of(x, csl_names(), class = "list_of_csl_names")
}

#' @export
format.list_of_csl_names <- function(x, ...) {
  vapply(x, function(z) paste(format(z, ...), collapse = ", "), character(1L))
}

#' @export
obj_print_data.list_of_csl_names <- function(x, ...) {
  print(format(x), quote = FALSE)
}

#' @export
vec_cast.list_of_csl_names.list <- function(x, to, ...) {
  if(length(x) == 1 && !is.null(names(x[[1]]))) x <- list(x)
  list_of_csl_names(lapply(x, csl_names))
}

#' @method vec_cast.character list_of_csl_names
#' @export
vec_cast.character.list_of_csl_names <- function(x, to, ...) {
  format(x)
}

#' @export
xtfrm.list_of_csl_names <- function(x) {
  xtfrm(format(x))
}

#' @export
vec_proxy_order.list_of_csl_names <- xtfrm.list_of_csl_names

#' @export
names.list_of_csl_names <- function(x) {
  csl_name_fields
}

#' @export
`$.list_of_csl_names` <- function(x, name) {
  vapply(x, function(authors) {
    out <- vapply(authors, function(author) author[[name]], character(1L))
    paste(out, collapse = ", ")
  }, character(1L))
}

#' @importFrom pillar pillar_shaft
#' @export
pillar_shaft.list_of_csl_names <- function(x, ...) {
  pillar::new_pillar_shaft_simple(format(x), align = "left", min_width = 10)
}
