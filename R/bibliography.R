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
  types <- as_tibble(bib) %>% pull(bibtype)
  bibsubset <- bib[types %in% category]
  items <- paste(unlist(bibsubset$key), sep = "")
  bibname <- paste("bib", ...calls, sep = "")
  cat("\n\\defbibheading{", bibname, "}{\\subsection{", title, "}}",
    ifelse(!is.null(startlabel), paste("\\label{", startlabel, "}", sep = ""), ""),
    sep = ""
  )
  cat("\n\\addtocategory{", bibname, "}{",
    paste(items, ",", sep = "", collapse = "\n"),
    "}",
    sep = ""
  )
  cat("\n\\newrefcontext[sorting=", sorting, "]\\setcounter{papers}{0}\\pagebreak[3]", sep = "")
  cat("\n\\printbibliography[category=", bibname, ",heading=", bibname, "]\\setcounter{papers}{0}\n", sep = "")
  if (!is.null(endlabel)) {
    cat("\\label{", endlabel, "}", sep = "")
  }
  cat("\n\\nocite{", paste(items, ",", sep = "", collapse = "\n"), "}", sep="")
}

getbibentry <- function(pkg)
{
  # Grab locally stored package info
  meta <- suppressWarnings(packageDescription(pkg))
  if(!is.list(meta))
  {
    if(is.na(meta))
    {
      install.packages(pkg)
      meta <- suppressWarnings(packageDescription(pkg))
    }
  }
  # Check if CRAN version exists
  url <- paste("https://CRAN.R-project.org/web/packages/",
               pkg,"/index.html",sep="")
  z <- suppressWarnings(rvest::html_session(url))
  # Grab CRAN info if the package is on CRAN
  if(z$response$status != 404)
  {
    x <- rvest::html_nodes(z, "td")
    meta$Version <- stringr::str_extract(as.character(x[2]), "([0-9.]+)")
    pub <- which(!is.na(stringr::str_locate(as.character(x), "<td>Published:</td>")[,1]))
    meta$Year <- stringr::str_extract(as.character(x[pub+1]), "([0-9]+)")
    meta$URL <- paste("https://CRAN.R-project.org/package=",
                   pkg,sep="")

  }
  else # Grab github info
  {
    if(is.null(meta$URL))
      meta$URL <- paste("https://github.com/",meta$RemoteUsername,
                        "/",meta$RemoteRepo,sep="")
    # Find last github commit
    commits <- gh::gh(paste("GET /repos/",meta$RemoteUsername,"/",meta$RemoteRepo,"/commits",sep=""))
    meta$Year <- substr(commits[1][[1]]$commit$author$date,1,4)
  }

  # Fix any & in title
  meta$Title <- gsub("&","\\\\&",meta$Title)

  # Add J to my name
  meta$Author <- gsub("Rob Hyndman","Rob J Hyndman",meta$Author)

  # Fix Souhaib's name
  meta$Author <- gsub("Ben Taieb", "Ben~Taieb", meta$Author)

  # Replace R Core Team with {R Core Team}
  meta$Author <- gsub("R Core Team","{R Core Team}",meta$Author)

    # Create bibentry
  rref <- bibentry(
    bibtype="Manual",
    title=paste(meta$Package,": ",meta$Title, sep=""),
    year=meta$Year,
    author = meta$Author,
    url = strsplit(meta$URL,",")[[1]][1],
    version = meta$Version,
    key = paste("R",meta$Package,sep="")
  )
  return(rref)
}

#' Create bib file for R packages
#'
#' Given a list of R packages, this function will generate a bib file using CRAN information if
#' it is available. Otherwise, it uses github. Packages that are not on CRAN or github will generate
#' errors. Also packages that have not been installed using either `install.packages()` or `devtools::install_github()`
#' will cause errors.
#'
#' @param pkglist A character vector containing package names.
#' @param file Name of bib file to write to.
#'
#' @return Nothing.
#'
#' @author Rob J Hyndman
#'
#' @export
write_packages_bib <- function(pkglist, file)
{
  fh <- file(file, open = "w+")
  on.exit( if( isOpen(fh) ) close(fh) )
  for(i in seq_along(pkglist))
  {
    bibs <- try(getbibentry(pkglist[i]))
    if("try-error" %in% class(bibs))
      stop(paste("Package not found:",pkglist[i]))
    else
      writeLines(toBibtex(bibs), fh)
  }
  message(paste("OK\nResults written to",file))
}
