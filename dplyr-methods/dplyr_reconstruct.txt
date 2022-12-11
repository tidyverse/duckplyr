dplyr_reconstruct.data.frame <- function(data, template) {
  attrs <- attributes(template)
  attrs$names <- names(data)
  attrs$row.names <- .row_names_info(data, type = 0L)

  attributes(data) <- attrs
  data
}
