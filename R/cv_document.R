cv_document <- function(...){
  config <- bookdown::pdf_document2(...)

  pre <- config$pre_processor
  config$pre_processor = function(metadata, input_file, runtime, knit_meta,
                               files_dir, output_dir) {
    args <- pre(metadata, input_file, runtime, knit_meta, files_dir, output_dir)

    header_contents <- NULL

    if (has_meta(knit_meta, "latex_dependency")) {
      header_contents <- c(
        header_contents,
        latex_dependencies_as_string(
          flatten_meta(knit_meta, function(x) inherits(x, "latex_dependency"))
        )
      )
    }

    if (has_meta(knit_meta, "biliography_entry")) {
      header_contents <- c(
        header_contents,
        readLines(system.file("bib_format.tex", package="vitae")),
        bibliography_header(
          flatten_meta(knit_meta, function(x) inherits(x, "biliography_entry"))
        )
      )
    }

    if("--include-in-header" %in% args){
      header_file <- args[which(args == "--include-in-header")+1]
    }
    else{
      header_file <- tempfile("cv-header", fileext = ".tex")
      if ("header-includes" %in% names(metadata)) {
        cat(c("", metadata[["header-includes"]]), sep = "\n", file = header_file, append = TRUE)
      }
      args <- c(args, rmarkdown::includes_to_pandoc_args(rmarkdown::includes(in_header = header_file)))
    }

    cat(header_contents, sep = "\n", file = header_file, append = TRUE)

    args
  }
  config
}

flatten_meta <- function(knit_meta, test) {
  all_meta <- list()
  for (dep in knit_meta) {
    if (is.null(names(dep)) && is.list(dep)) {
      inner_meta <- flatten_meta(dep, test)
      all_meta <- append(all_meta, inner_meta)
    } else if (test(dep)) {
      all_meta[[length(all_meta) + 1]] <- dep
    }
  }
  all_meta
}

latex_dependencies_as_string <- function(dependencies) {
  lines <- sapply(dependencies, function(dep) {
    opts <- paste(dep$options, collapse = ",")
    if (opts != "") opts <- paste0("[", opts, "]")
    # \\usepackage[opt1,opt2]{pkgname}
    paste0("\\usepackage", opts, "{", dep$name, "}")
  })
  paste(unique(lines), collapse = "\n")
}

bibliography_header <- function(bibs){
  titles <- lapply(bibs, function(x) x[["title"]])
  files <- lapply(bibs, function(x) x[["file"]])
  c(
    paste0("\\DeclareBibliographyCategory{", titles, "}"),
    paste0("\\bibliography{", unique(files), "}", collapse = ", ")
  )
}

has_meta <- function(knit_meta, class) {
  if (inherits(knit_meta, class))
    return(TRUE)

  if (is.list(knit_meta)) {
    for (meta in knit_meta) {
      if (is.null(names(meta))) {
        if (has_meta(meta, class))
          return(TRUE)
      } else {
        if (inherits(meta, class))
          return(TRUE)
      }
    }
  }
  FALSE
}
