# as_duckdb_tibble() and grouped df

    Code
      as_duckdb_tibble(dplyr::group_by(mtcars, cyl))
    Condition
      Error in `as_duckdb_tibble()`:
      ! `funnel` must be an unnamed character vector or a named numeric vector

# as_duckdb_tibble() and rowwise df

    Code
      as_duckdb_tibble(dplyr::rowwise(mtcars))
    Condition
      Error in `as_duckdb_tibble()`:
      ! `funnel` must be an unnamed character vector or a named numeric vector

# as_duckdb_tibble() and readr data

    Code
      as_duckdb_tibble(readr::read_csv(path, show_col_types = FALSE))
    Condition
      Error in `as_duckdb_tibble()`:
      ! `funnel` must be an unnamed character vector or a named numeric vector

