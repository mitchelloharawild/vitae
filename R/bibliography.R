#' Print bibliography section
#'
#' Given a bibliography file, this function will generate bibliographic entries
#' for one or more types of bib entry.
#'
#' @param file A path to a bibliography file understood by [`rmarkdown::pandoc_citeproc_convert()`].
#' @param startlabel Defunct.
#' @param endlabel Defunct.
#'
#' @return A dataset representing the bibliographic entries, suitable for
#' generating a reference section in a document.
#'
#' @author Rob J Hyndman & Mitchell O'Hara-Wild
#'
#' @examples
#'
#' # Create a bibliography from a set of packages
#' bib <- tempfile(fileext = ".bib")
#' knitr::write_bib(c("vitae", "tibble"), bib)
#'
#' # Import the bibliography entries into a CV
#' bibliography_entries(bib)
#'
#' # The order of these entries can be customised using `dplyr::arrange()`
#' bibliography_entries(bib) %>%
#'   arrange(desc(title))
#'
#' # For more complex fields like author, you can also sort by component fields.
#' # For example, use `author$family` to sort by family names.
#' bibliography_entries(bib) %>%
#'   arrange(desc(author$family))
#'
#' @export
bibliography_entries <- function(file, startlabel = NULL, endlabel = NULL) {
  if(!is.null(startlabel)){
    warning("The `startlabel` argument is defunct and will be removed in the next release.\nPlease use a different approach to including labels.")
  }
  if(!is.null(endlabel)){
    warning("The `endlabel` argument is defunct and will be removed in the next release.\n. Please use a different approach to including labels.")
  }

  bib <- yaml::yaml.load(rmarkdown::pandoc_citeproc_convert(file, "yaml"))$references

  # Deconstruct yaml into tibble
  bib <- dplyr::bind_rows(lapply(
    bib,
    function(x){
      el_is_list <- vapply(x, is.list, logical(1L))
      x[el_is_list] <- lapply(x[el_is_list], list)
      chr_fields <- intersect(names(x), c("number", "issue", "page", "volume", "version"))
      x[chr_fields] <- lapply(x[chr_fields], as.character)
      tibble::as_tibble(x)
    }
  ))
  bib$author <- csl_name(bib$author)
  if(is.list(bib$issued)) bib$issued <- csl_date(bib$issued)
  tibble::new_tibble(bib, preserve = "id",
                     class = c("vitae_bibliography", "vitae_preserve"),
                     nrow = nrow(bib))
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_bibliography <- function(x, options = knitr::opts_current$get()) {
  # Reconstruct yaml from tibble
  yml <- lapply(
    dplyr::group_split(dplyr::rowwise(x)),
    function(x) {
      x <- as.list(x)
      el_is_list <- vapply(x, is.list, logical(1L))
      x[el_is_list] <- lapply(x[el_is_list], `[[`, i=1)
      Filter(function(x) !is.na(x) && length(x) > 0, x)
    })
  if((options$cache %||% 0) == 0) {
    file <- tempfile(fileext = ".yaml")
  } else {
    file <- paste0(options$cache.path, options$label, ".yaml")
  }
  yaml::write_yaml(list(references = yml), file = file)

  startlabel <- x %@% "startlabel"
  endlabel <- x %@% "endlabel"

  # Convert file separator to format expected by citeproc
  file <- gsub("\\", "/", file, fixed = TRUE)

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
