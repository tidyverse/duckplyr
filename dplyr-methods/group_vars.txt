group_vars.data.frame <- function(x) {
  setdiff(names(group_data(x)), ".rows")
}
