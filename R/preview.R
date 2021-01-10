#' Include a preview of the CV template output for documentation
#'
#' @param input Path to the CV's template rmd file
insert_preview <- function(input) {
  knitr::asis_output(
    sprintf(
      "![](%s 'Template preview')",
      basename(render_preview_screenshot(input))
    )
  )
}

render_preview_screenshot <- function(input) {
  output <- rmarkdown::render(
    input, output_dir = file.path("man", "figures")
  )

  # Output is html based
  if(grepl("html$", output)) {
    require_package("pagedown")
    pagedown::chrome_print(output, "png")
  } else {
    require_package("pdftools")
    pdftools::pdf_convert(output, "png", pages = 1, filenames = with_ext(output, "png"))
  }
}
