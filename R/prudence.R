#' @export
collect.prudent_duckplyr_df <- function(x, ...) {
  # Do nothing if already materialized
  adjust_prudence <- !is.null(duckdb$rel_from_altrep_df(x, strict = FALSE, allow_materialized = FALSE))

  out <- new_duckdb_tibble(x, class(x), adjust_prudence = adjust_prudence, prudence = "lavish")
  collect(out)
}

#' @export
as.data.frame.duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), c("duckplyr_df", "tbl_df", "tbl"))
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as.data.frame.prudent_duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as_tibble.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  as_tibble(out)
}
