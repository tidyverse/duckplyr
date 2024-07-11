#' Convert to a duckplyr data frame
#'
#' For an object of class `duckplyr_df`,
#' dplyr verbs such as [mutate()], [select()] or [filter()]  will attempt to use DuckDB.
#' If this is not possible, the original dplyr implementation is used.
#'
#' Set the `DUCKPLYR_FALLBACK_INFO` and `DUCKPLYR_FORCE` environment variables
#' for more control over the behavior, see [config] for more details.
#'
#' @param .data data frame or tibble to transform
#'
#' @return An object of class `"duckplyr_df"`, inheriting from the classes of the
#'   `.data` argument.
#'
#' @export
#' @examples
#' tibble(a = 1:3) %>%
#'   mutate(b = a + 1)
#'
#' tibble(a = 1:3) %>%
#'   as_duckplyr_df() %>%
#'   mutate(b = a + 1)
as_duckplyr_df <- function(.data) {
  if (inherits(.data, "duckplyr_df")) {
    return(.data)
  }

  if (!identical(class(.data), "data.frame") && !identical(class(.data), c("tbl_df", "tbl", "data.frame"))) {
    cli::cli_abort("Must pass a plain data frame or a tibble to `as_duckplyr_df()`.")
  }

  if (anyNA(names(.data)) || any(names(.data) == "")) {
    cli::cli_abort("Missing or empty names not allowed.")
  }

  class(.data) <- c("duckplyr_df", class(.data))
  .data
}

default_df_class <- function() {
  class(new_tibble(list()))
}
