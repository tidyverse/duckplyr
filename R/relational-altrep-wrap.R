#' @export
wrap <- function(x) {
	.Call(chunkrep_wrap, x)
}

#' @export
wrap_df <- function(df) {
  stopifnot(is.data.frame(df))
  out <- lapply(df, wrap)
  class(out) <- "data.frame"
  .Call(set_row_names, out, wrap(.set_row_names(nrow(df))))
  out
}
