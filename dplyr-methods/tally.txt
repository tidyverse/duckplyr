tally.data.frame <- function(x, wt = NULL, sort = FALSE, name = NULL) {
  name <- check_name(name, group_vars(x))

  dplyr_local_error_call()

  n <- tally_n(x, {{ wt }})

  local_options(dplyr.summarise.inform = FALSE)
  out <- summarise(x, !!name := !!n)

  if (sort) {
    arrange(out, desc(!!sym(name)))
  } else {
    out
  }
}
