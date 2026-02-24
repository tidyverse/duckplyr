#' Convert a duckplyr frame to a dbplyr table
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function converts a lazy duckplyr frame or a data frame
#' to a dbplyr table in duckplyr's internal connection.
#' This allows using dbplyr functions on the data,
#' including hand-written SQL queries.
#' Use [as_duckdb_tibble()] to convert back to a lazy duckplyr frame.
#'
#' @param .data A lazy duckplyr frame or a data frame.
#' @return A dbplyr table.
#' @export
#' @examplesIf requireNamespace("dbplyr", quietly = TRUE)
#' df <- duckdb_tibble(a = 1L)
#' df
#'
#' tbl <- as_tbl(df)
#' tbl
#'
#' tbl %>%
#'   mutate(b = sql("a + 1")) %>%
#'   as_duckdb_tibble()
as_tbl <- function(.data) {
  check_installed("dbplyr")

  rel <- duckdb_rel_from_df(.data)

  con <- get_default_duckdb_connection()
  name <- unique_table_name("as_tbl_")

  # Drop view when object goes out of scope
  scope_guard <- new_environment()
  reg.finalizer(
    scope_guard,
    function(e) {
      tryCatch(
        DBI::dbExecute(con, paste0("DROP VIEW ", name)),
        # Ignore errors
        error = function(e) {
          message(conditionMessage(e))
        }
      )
    },
    onexit = FALSE
  )

  # Side effect
  duckdb$rel_to_view(rel, "", name, temporary = TRUE)

  out <- dplyr::tbl(con, name)
  attr(out, "duckplyr_scope_guard") <- scope_guard
  out
}
