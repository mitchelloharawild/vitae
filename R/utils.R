# these functions are available in all R files
add_class <- function(x, subclass) {
  `class<-`(x, union(subclass, class(x)))
}

compact_list <- function(x) {
  if(is.list(x)) return(x)
  list(x[!is.na(x)])
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
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

# From rmarkdown:::partition_yaml_front_matter
partition_yaml_front_matter <- function (input_lines)
{
  validate_front_matter <- function(delimiters) {
    if (length(delimiters) >= 2 && (delimiters[2] - delimiters[1] >
                                    1) && grepl("^---\\s*$", input_lines[delimiters[1]])) {
      if (delimiters[1] == 1) {
        TRUE
      }
      else all(grepl("^\\s*(<!-- rnb-\\w*-(begin|end) -->)?\\s*$",
                     input_lines[1:delimiters[1] - 1]))
    }
    else {
      FALSE
    }
  }
  delimiters <- grep("^(---|\\.\\.\\.)\\s*$", input_lines)
  if (validate_front_matter(delimiters)) {
    front_matter <- input_lines[(delimiters[1]):(delimiters[2])]
    input_body <- c()
    if (delimiters[1] > 1)
      input_body <- c(input_body, input_lines[1:delimiters[1] -
                                                1])
    if (delimiters[2] < length(input_lines))
      input_body <- c(input_body, input_lines[-(1:delimiters[2])])
    list(front_matter = front_matter, body = input_body)
  }
  else {
    list(front_matter = NULL, body = input_lines)
  }
}

glue_alt <- function(...) {
  glue::glue(..., .open = "<<", .close = ">>", .envir = parent.frame())
}

require_package <- function(pkg){
  if(!requireNamespace(pkg, quietly = TRUE)){
    stop(
      sprintf('The `%s` package must be installed to use this functionality. It can be installed with install.packages("%s")', pkg, pkg),
      call. = FALSE
    )
  }
}

with_ext <- function(x, ext) {
  paste(sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x), ext, sep = ".")
}
