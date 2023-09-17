wrap_integer <- function(x) {
  .Call(chunkrep_wrap, x)
}

wrap_df <- function(df) {
  stopifnot(is.data.frame(df))
  out <- lapply(df, wrap_integer)
  class(out) <- "data.frame"
  .Call(set_row_names, out, wrap_integer(.set_row_names(nrow(df))))
  out
}
