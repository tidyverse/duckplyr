#' as_duckplyr_tibble
#'
#' `as_duckplyr_tibble()` converts the input to a tibble and then to a duckplyr data frame.
#'
#' @return For `as_duckplyr_df()`, an object of class
#'   `c("duckplyr_df", class(tibble()))` .
#'
#' @rdname as_duckplyr_df
#' @export
as_duckplyr_tibble <- function(.data) {
  if (inherits(.data, "tbl_duckdb_connection")) {
    con <- dbplyr::remote_con(.data)
    sql <- dbplyr::remote_query(.data)
    rel <- duckdb$rel_from_sql(con, sql)
    out <- rel_to_df(rel)
    class(out) <- c("duckplyr_df", class(new_tibble(list())))
    return(out)
  }

  # Extra as.data.frame() call for good measure and perhaps https://github.com/tidyverse/tibble/issues/1556
  as_duckplyr_df(as_tibble(as.data.frame(.data)))
}
