#' Create skill entries
#'
#' @param data A `data.frame` or `tibble` containing the skill entries
#' @param type Skill type/category
#' @param details Skill details/descriptions
#' @param .protect Logical, if TRUE (default) protects special LaTeX characters in input
#'
#' @return Object of class \code{vitae_skill}
#' @importFrom rlang enexpr expr_text !!
#' @export
skill_entries <- function(data, type, details, .protect = TRUE) {
  skill_exprs <- list(
    type = enquo(type) %missing% NA_character_,
    details = enquo(details) %missing% NA_character_
  )

  out <- dplyr::as_tibble(map(skill_exprs, eval_tidy, data = data))
  structure(out,
    preserve = names(skill_exprs),
    protect = .protect,
    class = c("vitae_skill", "vitae_preserve", class(data))
  )
}

#' @importFrom tibble tbl_sum
#' @export
tbl_sum.vitae_skill <- function(x) {
  x <- NextMethod()
  c(x, "vitae type" = "skill entries")
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_skill <- function(x, options, ...) {
  if(is.null(entry_format_functions$format)) {
    warn("Skill entry formatter is not defined for this output format.")
    return(knit_print(tibble::as_tibble(x)))
  }

  format <- entry_format_functions$format$skill
  if (is.null(format)) {
    warning("Skill format not supported for this template, using brief format instead")
    format <- entry_format_functions$format$brief
  }
  
  x[is.na(x)] <- ""

  if(!(x%@%"protect")){
    protect_tex_input <- identity
  }

  knitr::asis_output(
    format(
      protect_tex_input(x$type), 
      protect_tex_input(x$details)
    )
  )
}