# nocov start

# This file serves as a reference for compatibility functions for
# purrr. They are not drop-in replacements but allow a similar style
# of programming. This is useful in cases where purrr is too heavy a
# package to depend on.

map <- function(.x, .f, ...) {
  lapply(.x, .f, ...)
}

map_mold <- function(...) {
  out <- vapply(..., USE.NAMES = FALSE)
  names(out) <- names(..1)
  out
}

map_chr <- function(.x, .f, ...) {
  map_mold(.x, .f, character(1), ...)
}

# nocov end
