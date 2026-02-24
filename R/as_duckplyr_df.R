#' Convert to a duckplyr data frame
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' These functions convert a data-frame-like input to an object of class `"duckpylr_df"`.
#' For such objects,
#' dplyr verbs such as [mutate()], [select()] or [filter()]  will attempt to use DuckDB.
#' If this is not possible, the original dplyr implementation is used.
#'
#' `as_duckplyr_df()` requires the input to be a plain data frame or a tibble,
#' and will fail for any other classes, including subclasses of `"data.frame"` or `"tbl_df"`.
#' This behavior is likely to change, do not rely on it.
#'
#' @details
#' Set the `DUCKPLYR_FALLBACK_INFO` and `DUCKPLYR_FORCE` environment variables
#' for more control over the behavior, see [config] for more details.
#'
#' @param .data data frame or tibble to transform
#'
#' @return For `as_duckplyr_df()`, an object of class `"duckplyr_df"`,
#'   inheriting from the classes of the `.data` argument.
#'
#' @keywords internal
#' @export
#' @examples
#' tibble(a = 1:3) %>%
#'   mutate(b = a + 1)
as_duckplyr_df <- function(.data) {
  lifecycle::deprecate_soft("1.0.0", "as_duckplyr_df()", "as_duckdb_tibble()")

  as_duckplyr_df_impl(.data)
}

as_duckplyr_df_impl <- function(x, error_call = caller_env()) {
  # FIXME: Move to as_duckdb_tibble()
  if (
    !identical(class(x), "data.frame") &&
      !identical(class(x), c("tbl_df", "tbl", "data.frame"))
  ) {
    cli::cli_abort(
      call = error_call,
      c(
        "Must pass a plain data frame or a tibble, not {.obj_type_friendly {x}}.",
        i = "Convert it with {.fun as.data.frame} or {.fun tibble::as_tibble}."
      )
    )
  }

  new_duckdb_tibble(x, class = class(x), error_call = error_call)
}
