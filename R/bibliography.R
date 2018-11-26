# Main function for printing bibliography section
# category is a character vector of bib types
# title is the section heading

#' Print bibliography section
#'
#' Given a bib file, this function will generate bibliographic entries for one or more types of bib entry.
#'
#' @param bib An object of class "bibentry", created using \code{\link[bibtex]{read.bib}} or \code{\link[RefManageR]{ReadBib}}
#' @param category A character vector specifying the types of bib entries to include
#' @param title Character string giving section title
#' @param sorting Character stringing specifying how entries should be sorted. Default is "ynt" meaning
#' sort by year first, then name, then title.
#' @param startlabel Optional label for first reference in the section
#' @param endlabel Optional label for last reference in the section
#'
#' @return Prints bibliographic entries
#'
#' @author Rob J Hyndman
#'
#' @export
print_bibliography <- function(bib,
                              category = c("Article"),
                              title = "Refereed journal papers",
                              sorting = "ynt",
                              startlabel = NULL,
                              endlabel = NULL) {
  # Global variable to count number of times printbibliography has been called
  if(!exists("...calls"))
    ...calls <<- 1L
  else
    ...calls <<- ...calls + 1L
  if (...calls > 15) {
    stop("Sorry, I'm out of memory")
  }
  types <- dplyr::as_tibble(bib)[["bibtype"]]
  bibsubset <- bib[types %in% category]
  items <- paste(unlist(bibsubset$key), sep = "")
  bibname <- paste("bib", ...calls, sep = "")
  out <- glue(
    "
    \\defbibheading{<<bibname>>}{\\subsection{<<title>>}}<<startlabel>>
    \\addtocategory{<<bibname>>}{<<items>>}
    \\newrefcontext[sorting=<<sorting>>]\\setcounter{papers}{0}\\pagebreak[3]
    \\printbibliography[category=<<bibname>>,heading=<<bibname>>]\\setcounter{papers}{0}

    \\nocite{<<items>>}
    ",
    startlabel = ifelse(!is.null(startlabel), glue("\\label{{startlabel}}"), ""),
    endlabel = ifelse(!is.null(endlabel), glue("\\label{{endlabel}}"), ""),
    items = glue_collapse(items, sep = ",\n"),
    .open = "<<", .close = ">>"
  )
  knitr::asis_output(out)
}
