#' Include a preview of the CV template output for documentation
#'
#' @param template Name of the template
#'
#' @keywords internal
insert_preview <- function(template) {
  preview <- paste0("preview-", template, ".png")
  if(!file.exists(file.path("man", "figures", preview))) {
    abort(paste0("Missing preview for ", template, ". Add it with render_preview(<template>) from data-raw/preview.R."))
  }

  knitr::asis_output(
    sprintf(
      "![](%s 'Template preview')",
      preview
    )
  )
}
