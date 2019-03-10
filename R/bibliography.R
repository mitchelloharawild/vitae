# Main function for printing bibliography section
# category is a character vector of bib types
# title is the section heading

#' Print bibliography section
#'
#' Given a bib file, this function will generate bibliographic entries for one or more types of bib entry.
#'
#' @param file A path to a .bib file.
#' @param startlabel Optional label for first reference in the section.
#' @param endlabel Optional label for last reference in the section.
#'
#' @return Prints bibliographic entries
#'
#' @author Rob J Hyndman & Mitchell O'Hara-Wild
#'
#' @export
bibliography_entries <- function(file,
                                 startlabel = NULL,
                                 endlabel = NULL) {
  bib <- RefManageR::ReadBib(file, check = FALSE)
  family <- map_chr(bib, function(x){
    map_chr(x$author, function(names){
      paste(names$family, collapse = " ")
    }) %>% paste(collapse = ", ")
  })
  out <- dplyr::as_tibble(bib) %>%
    mutate(surnames = family)
  structure(mutate(out, key = names(bib$key)),
    file = file,
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
