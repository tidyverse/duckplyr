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
as.data.frame.duckplyr_df <- function(x, row.names, optional, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), c("duckplyr_df", "tbl_df", "tbl"))
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as.data.frame.lazy_duckplyr_df <- function(x, row.names, optional, ...) {
  out <- collect(x)
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as_tibble.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  as_tibble(out)
}
