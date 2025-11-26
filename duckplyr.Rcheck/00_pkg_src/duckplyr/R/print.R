#' @importFrom pillar tbl_sum
#' @export
tbl_sum.duckplyr_df <- function(x) {
  c("A duckplyr data frame" = cli::pluralize("{length(x)} variable{?s}"))
}

# dim.prudent_duckplyr_df is not called, special dispatch

#' @importFrom pillar tbl_nrow
#' @export
tbl_nrow.duckplyr_df <- function(x, ...) {
  NA_real_
}

#' @importFrom pillar tbl_format_setup
#' @export
tbl_format_setup.duckplyr_df <- function(
  x,
  width,
  ...,
  setup,
  n,
  max_extra_cols,
  max_footer_lines,
  focus
) {
  local_options(duckdb.materialize_callback = NULL, duckdb.materialize_message = NULL)
  NextMethod()
}
