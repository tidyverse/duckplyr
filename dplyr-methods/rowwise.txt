rowwise.data.frame <- function(data, ...) {
  vars <- tidyselect::eval_select(expr(c(...)), data)
  rowwise_df(data, vars)
}
