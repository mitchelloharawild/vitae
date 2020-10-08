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

  bib <- yaml::yaml.load(rmarkdown::pandoc_citeproc_convert(file, "yaml"))$references

  # Deconstruct yaml into tibble
  bib <- dplyr::bind_rows(lapply(
    bib,
    function(x){
      el_is_list <- vapply(x, is.list, logical(1L))
      x[el_is_list] <- lapply(x[el_is_list], list)
      tibble::as_tibble(x)
    }
  ))
  tibble::new_tibble(bib, preserve = "id",
                     class = c("vitae_bibliography", "vitae_preserve"))
}


#' @importFrom knitr knit_print
#' @export
knit_print.vitae_bibliography <- function(x, options) {
  # Reconstruct yaml from tibble
  yml <- lapply(
    dplyr::group_split(dplyr::rowwise(x)),
    function(x) {
      x <- as.list(x)
      el_is_list <- vapply(x, is.list, logical(1L))
      x[el_is_list] <- lapply(x[el_is_list], `[[`, i=1)
      Filter(function(x) !is.na(x) && lengths(x) > 0, x)
    })
  file <- tempfile(fileext = ".yaml")
  yaml::write_yaml(list(references = yml), file = file)

  startlabel <- x %@% "startlabel"
  endlabel <- x %@% "endlabel"
  out <- glue(
    '

    ::: {#bibliography}
    << file >>
    :::

    ',
    .open = "<<", .close = ">>"
  )
  knitr::asis_output(out, meta = list(structure(x$id, class = "vitae_nocite")))
}
