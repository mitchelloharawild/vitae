add_class <- function(x, subclass) {
  `class<-`(x, union(subclass, class(x)))
}

compact_list <- function(x) {
  list(x[!is.na(x)])
}

`%empty%` <- function(x, y) {
  if (length(x) == 0) y else x
}

`%missing%` <- function(x, y) {
  if (rlang::quo_is_missing(x)) y else x
}

protect_tex_input <- function(x, ...) {
  if (is.character(x) || is.factor(x)) {
    x <- gsub("'([^ ']*)'", "`\\1'", x, useBytes = TRUE)
    x <- gsub("\"([^\"]*)\"", "``\\1''", x, useBytes = TRUE)
    x <- gsub("\\", "\\textbackslash ", x,
      fixed = TRUE,
      useBytes = TRUE
    )
    x <- gsub("([{}&$#_^%])", "\\\\\\1", x, useBytes = TRUE)
    x
  }
  else {
    x
  }
}
