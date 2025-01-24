as_tethered_duckplyr_df <- function(x, allow_materialization, n_rows, n_cells) {
  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(
    rel,
    allow_materialization = allow_materialization,
    n_rows = n_rows,
    n_cells = n_cells
  )

  out <- dplyr_reconstruct(out, x)
  add_tethered_duckplyr_df_class(out)
}

add_tethered_duckplyr_df_class <- function(x) {
  class(x) <- unique(c("tethered_duckplyr_df", class(x)))
  x
}

as_untethered_duckplyr_df <- function(x) {
  if (!inherits(x, "tethered_duckplyr_df")) {
    return(x)
  }

  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(rel, allow_materialization = TRUE)

  out <- dplyr_reconstruct(out, x)
  remove_tethered_duckplyr_df_class(out)
}

is_tethered_duckplyr_df <- function(x) {
  inherits(x, "tethered_duckplyr_df")
}

remove_tethered_duckplyr_df_class <- function(x) {
  class(x) <- setdiff(class(x), "tethered_duckplyr_df")
  x
}

duckplyr_reconstruct <- function(rel, template) {
  lazy <- inherits(template, "tethered_duckplyr_df")
  out <- rel_to_df(rel, allow_materialization = !lazy)
  dplyr_reconstruct(out, template)
}

#' @export
collect.tethered_duckplyr_df <- function(x, ...) {
  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(rel, allow_materialization = TRUE)

  out <- dplyr_reconstruct(out, x)
  out <- remove_tethered_duckplyr_df_class(out)
  collect(out)
}

#' @export
as.data.frame.duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), c("duckplyr_df", "tbl_df", "tbl"))
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as.data.frame.tethered_duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as_tibble.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  as_tibble(out)
}
