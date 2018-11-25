add_class <- function(x, subclass){
  `class<-`(x, union(subclass, class(x)))
}

compact_list <- function(x){
  list(x[!is.na(x)])
}

`%empty%` <- function(x, y){
  if(length(x) == 0) y else x
}

`%missing%` <- function(x, y){
  if(rlang::is_missing(x)) y else x
}

map_mold <-  function (.x, .f, .mold, ...)
{
  out <- vapply(.x, .f, .mold, ..., USE.NAMES = FALSE)
  names(out) <- names(.x)
  out
}

map_chr <- function (.x, .f, ...)
{
  map_mold(.x, .f, character(1), ...)
}
