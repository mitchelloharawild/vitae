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
#' @author Mitchell O'Hara-Wild & Rob J Hyndman
#'
#' @examplesIf rmarkdown::pandoc_available("2.7")
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
#' @export
bibliography_entries <- function(file, startlabel = NULL, endlabel = NULL) {
  if(!is.null(startlabel)){
    warning("The `startlabel` argument is defunct and will be removed in the next release.\nPlease use a different approach to including labels.")
  }
  if(!is.null(endlabel)){
    warning("The `endlabel` argument is defunct and will be removed in the next release.\n. Please use a different approach to including labels.")
  }

  # Parse bib file
  # Set system() output encoding as UTF-8 to fix Windows issue (rmarkdown#2195)
  bib <- rmarkdown::pandoc_citeproc_convert(file, type = "json")
  Encoding(bib) <- "UTF-8"
  bib <- jsonlite::fromJSON(bib, simplifyVector = FALSE)

  # Produce prototype
  bib_schema <- unique(vec_c(!!!lapply(bib, names)))

  ## Add missing fields to schema
  csl_idx <- match(bib_schema, names(csl_fields))
  csl_fields[bib_schema[which(is.na(csl_idx))]] <- character()

  ## Use schema as prototype
  bib_ptype <- csl_fields[bib_schema]
  bib_ptype <- vctrs::vec_init(bib_ptype, 1)

  # Add missing values to complete rectangular structure
  bib <- lapply(bib, function(x) {
    # missing_cols <- setdiff(names(bib_ptype), names(x))
    # x[missing_cols] <- as.list(bib_ptype[missing_cols])
    array_pos <- lengths(x) > 1
    x[array_pos] <- lapply(x[array_pos], list)
    bib_ptype[names(x)] <- x
    bib_ptype
  })

  bib <- vctrs::vec_rbind(!!!bib, .ptype = bib_ptype)

  tibble::new_tibble(bib, preserve = "id",
                     class = c("vitae_bibliography", "vitae_preserve"),
                     nrow = nrow(bib))
}

#' @importFrom tibble tbl_sum
#' @export
tbl_sum.vitae_bibliography <- function(x) {
  x <- NextMethod()
  c(x, "vitae type" = "bibliography entries")
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
      Filter(function(x) !is.na(x[1]) && length(x) > 0, x)
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
