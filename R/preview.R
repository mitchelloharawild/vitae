#' Include a preview of the CV template output for documentation
#'
#' @param input Path to the CV's template rmd file
#' @keywords internal
insert_preview <- function(template) {
  preview <- paste0("preview_", template, ".png")
  if(!file.exists(file.path("man", "figures", preview))) {
    input <- file.path("inst", "rmarkdown", "templates", template, "skeleton", "skeleton.Rmd")
    render_preview_screenshot(input, template)
  }

  knitr::asis_output(
    sprintf(
      "![](%s 'Template preview')",
      preview
    )
  )
}

render_preview_screenshot <- function(input, template) {
  file.copy(input, input <- tempfile(fileext = ".rmd"))
  output <- rmarkdown::render(
    input, output_dir = tempdir()
  )
  outfile <- file.path("man", "figures", paste0("preview_", template, ".png"))

  # Output is html based
  if(grepl("html$", output)) {
    require_package("webshot")
    webshot::webshot(output, outfile, vwidth = 595, vheight = 842)
  } else {
    require_package("pdftools")
    pdftools::pdf_convert(output, "png", pages = 1, filenames = outfile)
  }
}
