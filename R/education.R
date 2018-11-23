sample_education <- tibble::tribble(
  ~ qual, ~uni, ~loc, ~years,
  "BComm", "MonashUni", "Melbourne", "1996-2000",
  "Bsc", "MelbUni", "Melbourne", "2001-2005"
)

#' @importFrom rlang enexpr expr_text !!
#' @importFrom tidyr nest
#' @export
education <- function(data, qualification, institution, location, years, items){
  edu_exprs <- list(
    qualification = enexpr(qualification),
    institution = enexpr(institution),
    location = enexpr(location),
    years = enexpr(years)
  )
  if(!missing(items)){
    data <- group_by(data, !!!edu_exprs)
    edu_exprs$items <- enexpr(items)
    data <- summarise(data, "items" := list(!!edu_exprs$items))
    data <- ungroup(data)
  }
  else{
    data <- dplyr::rename(data,  !!!edu_exprs)
  }
  add_class(data, "vitae_education")
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_education <- function(x, options){
  if("items" %in% colnames(x)){
    x <- dplyr::mutate(x,
      "items" := map(items, ~ glue_collapse(
        glue("\\item{<<.x>>}", .open = "<<", .close = ">>")
      ))
    )
  }
  else{
    x <- dplyr::mutate(x, "items" := "")
  }

  out <- glue_data(x,
            "\\educationitem
            {<<qualification>>}
            {<<institution>>}
            {<<location>>}
            {<<years>>}
            {<<items>>}",
            .open = "<<", .close = ">>")

  knitr::asis_output(glue("\\educationsection{<<glue_collapse(out)>>}", .open = "<<", .close = ">>"))
}
