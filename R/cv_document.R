#' Output format for vitae
#'
#' This output format provides support for including LaTeX dependencies and
#' bibliography entries in extension of the `rmarkdown::pdf_document()` format.
#'
#' @inheritParams rmarkdown::pdf_document
#' @inheritParams bookdown::pdf_document2
#' @param ... Arguments passed to rmarkdown::pdf_document().
#' @param pandoc_vars Pandoc variables to be passed to the template.
#'
#' @keywords internal
#' @export
cv_document <- function(..., pandoc_args = NULL, pandoc_vars = NULL,
                        base_format = rmarkdown::pdf_document) {
  for (i in seq_along(pandoc_vars)){
    pandoc_args <- c(pandoc_args, rmarkdown::pandoc_variable_arg(names(pandoc_vars)[[i]], pandoc_vars[[i]]))
  }

  pandoc_args <- c(
    c(rbind("--lua-filter", system.file("multiple-bibliographies.lua", package = "vitae", mustWork = TRUE))),
    pandoc_args
  )

  out <- base_format(..., pandoc_args = pandoc_args)
  pre <- out$pre_processor
  out$pre_processor <- function (metadata, input_file, runtime, knit_meta,
                                 files_dir, output_dir){
    pre(metadata, input_file, runtime, knit_meta,
               files_dir, output_dir)

    # Add citations to front matter yaml, there may be a better way to do this.
    # For example, @* wildcard. Keeping as is to avoid unintended side effects.
    meta_nocite <- vapply(knit_meta, inherits, logical(1L), "vitae_nocite")

    bib_files <- lapply(knit_meta[meta_nocite], function(x) x$file)
    names(bib_files) <- vapply(bib_files, rlang::hash_file, character(1L))
    metadata$bibliography <- bib_files

    bib_ids <- unique(unlist(lapply(knit_meta[meta_nocite], function(x) x$id)))
    metadata$nocite <- c(metadata$nocite, paste0("@", bib_ids, collapse = ", "))
    if(is.null(metadata$csl)) metadata$csl <- system.file("vitae.csl", package = "vitae", mustWork = TRUE)

    body <- partition_yaml_front_matter(xfun::read_utf8(input_file))$body
    xfun::write_utf8(
      c("---", yaml::as.yaml(metadata), "---", body),
      input_file
    )
  }
  out
}

copy_supporting_files <- function(template) {
  path <- system.file("rmarkdown", "templates", template, "skeleton", package = "vitae")
  files <- list.files(path)
  # Copy class and style files
  for (f in files[files != "skeleton.Rmd"]) {
    if (!file.exists(f)) {
      file.copy(file.path(path, f), ".", recursive = TRUE)
    }
  }
}
