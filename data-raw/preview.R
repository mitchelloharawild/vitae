render_preview <- function(template, input = NULL) {
  if(is.null(input)) {
    input <- file.path("inst", "rmarkdown", "templates", template, "skeleton", "skeleton.Rmd")
  }
  file.copy(input, input <- tempfile(fileext = ".rmd"))
  output <- rmarkdown::render(
    input, output_dir = tempdir()
  )
  outfile <- file.path("man", "figures", paste0("preview-", template, ".png"))

  # Output is html based
  if(grepl("html$", output)) {
    require_package("webshot")
    webshot::webshot(output, outfile, vwidth = 595, vheight = 842)
  } else {
    require_package("pdftools")
    pdftools::pdf_convert(output, "png", pages = 1, filenames = outfile)
  }
}
