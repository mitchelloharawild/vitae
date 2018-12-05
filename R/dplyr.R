# dplyr methods to preserve attributes
#' @importFrom rlang !!! set_names %@%
preserve_attributes <- function(fn){
  function(.data, ...){
    out <- NextMethod()
    if(any(miss_col <- !(.data%@%"key" %in% colnames(out)))){
      miss_nm <- colnames(.data)[miss_col]
      rlang::warn(glue("This function lost the ",
                       glue_collapse(miss_nm, sep = ", ", last = " and "),
                       " columns! These values will be removed from the report."))
      out <- mutate(out, !!!set_names(rep(list(NA), sum(miss_col)), miss_nm))
    }
    out <- structure(out, class = union(class(.data), class(out)))
    attr <- append(attributes(out), attributes(.data))
    `attributes<-`(out, attr[!duplicated(names(attr))])
  }
}

#' @export
#' @importFrom dplyr %>%
dplyr::`%>%`


#' @export
#' @importFrom dplyr mutate
dplyr::mutate
#' @export
mutate.vitae_preserve <- preserve_attributes(dplyr::mutate)

#' @export
#' @importFrom dplyr transmute
dplyr::transmute
#' @export
transmute.vitae_preserve <- preserve_attributes(dplyr::transmute)

#' @export
#' @importFrom dplyr group_by
dplyr::group_by
#' @export
group_by.vitae_preserve <- preserve_attributes(dplyr::group_by)

#' @export
#' @importFrom dplyr summarise
dplyr::summarise
#' @export
summarise.vitae_preserve <- preserve_attributes(dplyr::summarise)

#' @export
#' @importFrom dplyr rename
dplyr::rename
#' @export
rename.vitae_preserve <- preserve_attributes(dplyr::rename)

#' @export
#' @importFrom dplyr arrange
dplyr::arrange
#' @export
arrange.vitae_preserve <- preserve_attributes(dplyr::arrange)

#' @export
#' @importFrom dplyr select
dplyr::select
#' @export
select.vitae_preserve <- preserve_attributes(dplyr::select)

#' @export
#' @importFrom dplyr filter
dplyr::filter
#' @export
filter.vitae_preserve <- preserve_attributes(dplyr::filter)

#' @export
#' @importFrom dplyr distinct
dplyr::distinct
#' @export
distinct.vitae_preserve <- preserve_attributes(dplyr::distinct)

#' @export
#' @importFrom dplyr slice
dplyr::slice
#' @export
slice.vitae_preserve <- preserve_attributes(dplyr::slice)
