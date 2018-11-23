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
    qualification = enexpr(qualification) %missing% NA,
    institution = enexpr(institution) %missing% NA,
    location = enexpr(location) %missing% NA,
    years = enexpr(years) %missing% NA,
    items = enexpr(items) %missing% NA
  )

  data <- dplyr::transmute(data,  !!!edu_exprs)
  data <- group_by(data, !!!syms(names(edu_exprs))[-5])
  data <- summarise(data, "items" := compact_list(!!edu_exprs$items))
  data <- ungroup(data)

  add_class(data, "vitae_education")
}

#' @importFrom knitr knit_print
#' @export
knit_print.vitae_education <- function(x, options){
  x <- dplyr::mutate(x,
                     "items" := map_chr(items, ~ glue_collapse(
                       glue("\\item{<<.x>>}", .open = "<<", .close = ">>")
                     ) %empty% "\\empty")
  )

  x[is.na(x)] <- ""

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
