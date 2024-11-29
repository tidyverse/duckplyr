#' @title Explain details of a tbl
#'
#' @description  This is a method for the [`dplyr::explain()`] generic.
#' This is a generic function which gives more details about an object
#' than `print()`, and is more focused on human readable output than `str()`.
#'
#' @inheritParams dplyr::explain
#' @examplesIf rlang::is_interactive() && rlang::is_installed("dbplyr") && rlang::is_installed("Lahman")
#' lahman_s <- dbplyr::lahman_sqlite()
#' batting <- tbl(lahman_s, "Batting")
#' explain(batting)
#' @seealso [`dplyr::explain()`]
#' @rdname explain.duckplyr_df
#' @name explain.duckplyr_df
NULL
