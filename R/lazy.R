
as_lazy_duckplyr_df <- function(x) {
  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(rel, allow_materialization = FALSE)

  out <- dplyr_reconstruct(out, x)
  add_lazy_duckplyr_df_class(out)
}

add_lazy_duckplyr_df_class <- function(x) {
  class(x) <- unique(c("lazy_duckplyr_df", class(x)))
  x
}

remove_lazy_duckplyr_df_class <- function(x) {
  class(x) <- setdiff(class(x), "lazy_duckplyr_df")
  x
}

#' @export
collect.lazy_duckplyr_df <- function(x, ...) {
  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(rel, allow_materialization = TRUE)

  out <- dplyr_reconstruct(out, x)
  out <- remove_lazy_duckplyr_df_class(out)
  collect(out)
}

#' @export
as.data.frame.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  out
}

# dim.lazy_duckplyr_df is not called, special dispatch

#' @export
as.data.frame.lazy_duckplyr_df <- function(x) {
  as.data.frame(collect(x))
}

#' @import pillar
#' @export
tbl_sum.duckplyr_df <- function(x) {
  c("A duckplyr data frame" = paste0(length(x), " variables"))
}

#' @export
tbl_nrow.duckplyr_df <- function(x, ...) {
  NA_real_
}

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
