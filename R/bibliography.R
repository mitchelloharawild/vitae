# Main function for printing bibliography section
# category is a character vector of bib types
# title is the section heading

#' Print bibliography section
#'
#' Given a bib file, this function will generate bibliographic entries for one or more types of bib entry.
#'
#' @param file A path to a .bib file.
#' @param category A character vector specifying the types of bib entries to include.
#' @param title Character string giving section title.
#' @param sorting Character stringing specifying how entries should be sorted. Default is "ynt" meaning
#' sort by year first, then name, then title.
#' @param startlabel Optional label for first reference in the section.
#' @param endlabel Optional label for last reference in the section.
#'
#' @return Prints bibliographic entries
#'
#' @author Rob J Hyndman & Mitchell O'Hara-Wild
#'
#' @export
bibliography_entries <- function(file,
                                 category = c("Article"),
                                 title = "Refereed journal papers",
                                 sorting = "ynt",
                                 startlabel = NULL,
                                 endlabel = NULL) {
  bib <- RefManageR::ReadBib(file, check = FALSE)
  types <- dplyr::as_tibble(bib)[["bibtype"]]
  bibsubset <- bib[types %in% category]
  items <- paste(unlist(bibsubset$key), sep = "")
  bibname <- paste("bib", title, sep = "")
  out <- glue(
    "
    \\defbibheading{<<bibname>>}{\\subsection{<<title>>}}<<startlabel>>
    \\addtocategory{<<bibname>>}{<<items>>}
    \\newrefcontext[sorting=<<sorting>>]\\setcounter{papers}{0}\\pagebreak[3]
    \\printbibliography[category=<<bibname>>,heading=<<bibname>>]<<endlabel>>\\setcounter{papers}{0}

    \\nocite{<<items>>}
    ",
    startlabel = ifelse(!is.null(startlabel),
                        glue("\\label{<startlabel>}", .open = "<", .close = ">"),
                        ""),
    endlabel = ifelse(!is.null(endlabel),
                      glue("\\label{<endlabel>}", .open = "<", .close = ">"),
                      ""),
    items = glue_collapse(items, sep = ",\n"),
    .open = "<<", .close = ">>"
  )
  knitr::asis_output(out,
                     meta = list(structure(
                       list(title = title, file = file),
                       class = "biliography_entry"))
                     )
}
