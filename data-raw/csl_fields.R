csl_types <- jsonlite::read_json("https://resource.citationstyles.org/schema/latest/input/json/csl-data.json")
csl_fields <- csl_types$items$properties
csl_field_type <- function(x) {
  type <- x[["type"]][[1]]
  if(is.null(type)) type <- sub("#/definitions/", "", x[["$ref"]], fixed = TRUE)
  if(type == "array") {
    x <- csl_field_type(x[["items"]])
    if(vec_is(x, csl_names())) {
      return(vctrs::new_list_of(ptype = x, class = "list_of_csl_names"))
    } else {
      # Too hard to convert to list_of for all types
      return(list())
    }
  }
  switch (type,
          "string" = character(),
          "number" = numeric(),
          "name-variable" = csl_names(),
          "date-variable" = csl_dates(),
          "object" = list()
  )
}
csl_fields <- tibble::as_tibble(lapply(csl_fields, csl_field_type))

usethis::use_data(csl_fields, overwrite = TRUE, internal = TRUE)
