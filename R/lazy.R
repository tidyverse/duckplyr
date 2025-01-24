as_funneled_duckplyr_df <- function(x, allow_materialization, n_rows, n_cells) {
  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(
    rel,
    allow_materialization = allow_materialization,
    n_rows = n_rows,
    n_cells = n_cells
  )

  out <- dplyr_reconstruct(out, x)
  add_funneled_duckplyr_df_class(out)
}

add_funneled_duckplyr_df_class <- function(x) {
  class(x) <- unique(c("funneled_duckplyr_df", class(x)))
  x
}

as_unfunneled_duckplyr_df <- function(x) {
  if (!inherits(x, "funneled_duckplyr_df")) {
    return(x)
  }

  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(rel, allow_materialization = TRUE)

  out <- dplyr_reconstruct(out, x)
  remove_funneled_duckplyr_df_class(out)
}

is_funneled_duckplyr_df <- function(x) {
  inherits(x, "funneled_duckplyr_df")
}

remove_funneled_duckplyr_df_class <- function(x) {
  class(x) <- setdiff(class(x), "funneled_duckplyr_df")
  x
}

duckplyr_reconstruct <- function(rel, template) {
  lazy <- inherits(template, "funneled_duckplyr_df")
  out <- rel_to_df(rel, allow_materialization = !lazy)
  dplyr_reconstruct(out, template)
}

#' @export
collect.funneled_duckplyr_df <- function(x, ...) {
  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(rel, allow_materialization = TRUE)

  out <- dplyr_reconstruct(out, x)
  out <- remove_funneled_duckplyr_df_class(out)
  collect(out)
}

#' @export
as.data.frame.duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), c("duckplyr_df", "tbl_df", "tbl"))
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as.data.frame.funneled_duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as_tibble.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  as_tibble(out)
}
