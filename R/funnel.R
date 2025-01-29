as_funneled_duckplyr_df <- function(x, allow_materialization, n_rows, n_cells) {
  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(
    rel,
    allow_materialization = allow_materialization,
    n_rows = n_rows,
    n_cells = n_cells
  )

  out <- dplyr_reconstruct(out, x)
  add_funneled_duckplyr_df_class(out, n_rows, n_cells)
}

add_funneled_duckplyr_df_class <- function(x, n_rows, n_cells) {
  class(x) <- unique(c("funneled_duckplyr_df", class(x)))

  funnel <- c(
    rows = if (is.finite(n_rows)) n_rows,
    cells = if (is.finite(n_cells)) n_cells
  )
  attr(x, "funnel") <- funnel

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

get_funnel_duckplyr_df <- function(x) {
  if (!is_funneled_duckplyr_df(x)) {
    return("open")
  }

  funnel <- attr(x, "funnel")
  if (is.null(funnel)) {
    return("closed")
  }

  funnel
}

remove_funneled_duckplyr_df_class <- function(x) {
  class(x) <- setdiff(class(x), "funneled_duckplyr_df")
  attr(x, "funnel") <- NULL
  x
}

duckplyr_reconstruct <- function(rel, template) {
  funnel <- get_funnel_duckplyr_df(template)
  funnel_parsed <- funnel_parse(funnel)
  out <- rel_to_df(
    rel,
    allow_materialization = funnel_parsed$allow_materialization,
    n_rows = funnel_parsed$n_rows,
    n_cells = funnel_parsed$n_cells
  )
  dplyr_reconstruct(out, template)
}

#' @export
collect.funneled_duckplyr_df <- function(x, ...) {
  # Do nothing if already materialized
  if (is.null(duckdb$rel_from_altrep_df(x, allow_materialized = FALSE))) {
    out <- x
  } else {
    rel <- duckdb_rel_from_df(x)
    out <- rel_to_df(rel, allow_materialization = TRUE)
    out <- dplyr_reconstruct(out, x)
  }

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
