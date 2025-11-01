# Output format for entries
entry_format_functions <- new.env(parent = emptyenv())

set_entry_formats <- function(entry_format) {
  entry_format_functions$format <- entry_format
}

new_entry_formats <- function(brief, detailed, honor = NULL, skill = NULL) {
  formats <- list(brief = brief, detailed = detailed)
  if (!is.null(honor)) formats$honor <- honor
  if (!is.null(skill)) formats$skill <- skill
  formats
}
