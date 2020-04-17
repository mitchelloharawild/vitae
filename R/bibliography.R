# Main function for printing bibliography section
# category is a character vector of bib types
# title is the section heading

#' Print bibliography section
#'
#' Given a bib file, this function will generate bibliographic entries for one or more types of bib entry.
#'
#' @param file A path to a .bib file.
#' @param startlabel Defunct.
#' @param endlabel Defunct.
#'
#' @return Prints bibliographic entries
#'
#' @author Rob J Hyndman & Mitchell O'Hara-Wild
#'
#' @export
bibliography_entries <- function(file, startlabel = NULL, endlabel = NULL) {
  if(!is.null(startlabel)){
    warning("The `startlabel` argument is defunct. Please use a different approach to including labels.")
  }
  if(!is.null(endlabel)){
    warning("The `endlabel` argument is defunct. Please use a different approach to including labels.")
  }
  bib <- RefManageR::ReadBib(file, check = FALSE)
  family <- map_chr(bib, function(x){
    map_chr(x$author, function(names){
      paste(names$family, collapse = " ")
    }) %>% paste(collapse = ", ")
  })
  out <- dplyr::as_tibble(bib) %>%
    mutate(surnames = family)
  structure(mutate(out, key = unlist(bib$key)),
    file = normalizePath(file, winslash = .Platform$file.sep),
    preserve = "key",
    class = c("vitae_bibliography", "vitae_preserve", class(out))
  )
}


#' @importFrom knitr knit_print
#' @export
knit_print.vitae_bibliography <- function(x, options) {
  items <- x$key
  startlabel <- x %@% "startlabel"
  endlabel <- x %@% "endlabel"
  out <- glue(
    '
    ::: {#bibliography}
    << x %@% "file" >>
    :::
    ',
    items = glue_collapse(items, sep = ",\n"),
    .open = "<<", .close = ">>"
  )
  knitr::asis_output(out, meta = list(structure(x$key, class = "vitae_nocite")))
}
