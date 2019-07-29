# Main function for printing bibliography section
# category is a character vector of bib types
# title is the section heading

#' Print bibliography section
#'
#' Given a bib file, this function will generate bibliographic entries for one or more types of bib entry.
#'
#' @param file A path to a .bib file.
#' @param title Deprecated, use markdown sub-headers.
#' @param sorting Deprecated, use [dplyr::arrange()] to re-order the bibliography.
#' @param startlabel Optional label for first reference in the section.
#' @param endlabel Optional label for last reference in the section.
#'
#' @return Prints bibliographic entries
#'
#' @author Rob J Hyndman & Mitchell O'Hara-Wild
#'
#' @export
bibliography_entries <- function(file, title = NULL, sorting = NULL,
                                 startlabel = NULL,
                                 endlabel = NULL) {
  if(!missing(title)){
    warning("The `title` argument is deprecated. Please add bibliography titles using markdown sub-headers. This argument will be removed in the next release of vitae.")
  }
  if(!missing(sorting)){
    warning("The `sorting` argument is deprecated. Please sort bibliography entries using `dplyr::arrange()`. This argument will be removed in the next release of vitae.")
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
    file = normalizePath(file),
    startlabel = startlabel,
    endlabel = endlabel,
    preserve = "key",
    class = c("vitae_bibliography", "vitae_preserve", class(out))
  )
}


#' @importFrom knitr knit_print
#' @export
knit_print.vitae_bibliography <- function(x, options) {
  bibname <- paste("bib", x %@% "file", format((as.numeric(Sys.time())%%60)*1e5, nsmall = 0), sep = "-")
  items <- x$key
  startlabel <- x %@% "startlabel"
  endlabel <- x %@% "endlabel"
  out <- glue(
    '
    \\defbibheading{<<bibname>>}{}<<startlabel>>
    \\addtocategory{<<bibname>>}{<<items>>}
    \\newrefcontext[sorting=none]\\setcounter{papers}{0}\\pagebreak[3]
    \\printbibliography[category=<<bibname>>,heading=none]<<endlabel>>\\setcounter{papers}{0}

    \\nocite{<<items>>}
    ',
    startlabel = ifelse(!is.null(startlabel),
      glue("\\label{<startlabel>}", .open = "<", .close = ">"),
      ""
    ),
    endlabel = ifelse(!is.null(endlabel),
      glue("\\label{<endlabel>}", .open = "<", .close = ">"),
      ""
    ),
    items = glue_collapse(items, sep = ",\n"),
    .open = "<<", .close = ">>"
  )
  knitr::asis_output(out,
    meta = list(structure(
      list(title = bibname, file = x %@% "file"),
      class = "biliography_entry"
    ))
  )
}
