#' Awesome CV template
#'
#' Awesome CV is LaTeX template for a CV or Résumé inspired by
#' [Fancy CV](https://www.overleaf.com/latex/templates/friggeri-cv-template/hmnchbfmjgqh):
#' https://github.com/posquit0/Awesome-CV
#'
#' @param \dots Arguments passed to \code{\link[vitae]{cv_document}}.
#' @inheritParams rmarkdown::pdf_document
#' @param page_total If TRUE, the total number of pages is shown in the footer.
#' @param show_footer If TRUE, a footer showing your name, document name, and page number.
#' @param font_scale Numeric multiplier applied to hard-coded font sizes in the
#' Awesome‑CV class (default = 1). Use values like 0.95–1.10.
#'
#' @section Preview:
#' `r insert_preview("awesomecv")`
#'
#' @return An R Markdown output format object.
#'
#' @author Mitchell O'Hara-Wild, theme by Byungjin Park
#' ([@posquit0](https://github.com/posquit0))
#'
#' @export
awesomecv <- function(...,
                      latex_engine = "xelatex",
                      page_total = FALSE,
                      show_footer = TRUE,
                      font_scale = 1) {
  template <- system.file("rmarkdown", "templates", "awesomecv",
                          "resources", "awesome-cv.tex",
                          package = "vitae"
  )
  set_entry_formats(awesome_cv_entries)
  copy_supporting_files("awesomecv")

  if (!isTRUE(all.equal(font_scale, 1))) {
    cls_path <- "awesome-cv.cls"
    if (!file.exists(cls_path)) {
      stop("Expected 'awesome-cv.cls' in the working directory after copy_supporting_files().")
    }
    font_size_scaling(scale = font_scale, file_path = cls_path)
  }

  pandoc_vars <- list()
  if(page_total) pandoc_vars$page_total <- TRUE
  if(show_footer) pandoc_vars$show_footer <- TRUE
  cv_document(..., pandoc_vars = pandoc_vars,
              template = template, latex_engine = latex_engine)
}

awesome_cv_entries <- new_entry_formats(
  brief = function(what, when, with){
    paste(
      c(
        "\\begin{cvhonors}",
        glue_alt("\t\\cvhonor{}{<<what>>}{<<with>>}{<<when>>}"),
        "\\end{cvhonors}"
      ),
      collapse = "\n"
    )
  },
  detailed = function(what, when, with, where, why){
    why <- lapply(why, function(x) {
      if(length(x) == 0) {
        "{}\\vspace{-4.0mm}"
      } else {
        paste(c("{\\begin{cvitems}", paste("\\item", x), "\\end{cvitems}}"),
              collapse = "\n")
      }
    })

    paste(c(
      "\\begin{cventries}",
      glue_alt("\t\\cventry{<<what>>}{<<with>>}{<<where>>}{<<when>>}<<why>>"),
      "\\end{cventries}"
    ), collapse = "\n")
  }
)

# Patches the local copy of awesome-cv.cls.
# Strategy: inject \usepackage{xfp} and \newcommand\ACVscale{<scale>},
# then convert \fontsize{<n>pt}{...} -> \fontsize{\fpeval{<n>*\ACVscale}pt}{...}
font_size_scaling <- function(scale = 1, file_path = "awesome-cv.cls") {
  stopifnot(is.numeric(scale), length(scale) == 1, scale > 0)
  if (!file.exists(file_path)) stop("File not found: ", file_path)

  x <- readLines(file_path, warn = FALSE)

  # Insert just after fontspec so \fpeval is available before any uses
  anchor <- grep("\\\\RequirePackage\\[quiet\\]\\{fontspec\\}", x, perl = TRUE)[1]
  if (is.na(anchor)) anchor <- 0L

  # Ensure xfp is loaded once
  if (!any(grepl("\\\\usepackage\\{xfp\\}", x, perl = TRUE))) {
    x <- append(x, "\\usepackage{xfp}", after = anchor); anchor <- anchor + 1L
  }

  # Replace any prior ACVscale defs, then provide+renew (idempotent update)
  x <- x[!grepl("\\\\(re)?newcommand\\\\ACVscale|\\\\providecommand\\\\ACVscale", x, perl = TRUE)]
  x <- append(x,
              c("\\providecommand\\ACVscale{1}",
                sprintf("\\renewcommand\\ACVscale{%.6f}", scale)),
              after = anchor)

  # Rewrite \fontsize{<n>pt}{...} -> \fontsize{\fpeval{<n>*\ACVscale}pt}{...}
  # (Note the doubled backslashes in the R string to yield single backslashes in .cls)
  x <- gsub("\\\\fontsize\\{([0-9.]+)pt\\}\\{",
            "\\\\fontsize{\\\\fpeval{\\1*\\\\ACVscale}pt}{",
            x, perl = TRUE)

  writeLines(x, file_path)
  message("Font sizes will be scaled by LaTeX (xfp) using ACVscale = ", scale, ".")
}
