# as_duckdb_tibble() and grouped df

    Code
      as_duckdb_tibble(dplyr::group_by(mtcars, cyl))
    Condition
      Error in `as_duckdb_tibble()`:
      ! duckplyr does not support `group_by()`.
      i Use `.by` instead.
      i To proceed with dplyr, use `as_tibble()` or `as.data.frame()`.

# as_duckdb_tibble() and rowwise df

    Code
      as_duckdb_tibble(dplyr::rowwise(mtcars))
    Condition
      Error in `as_duckdb_tibble()`:
      ! duckplyr does not support `rowwise()`.
      i To proceed with dplyr, use `as_tibble()` or `as.data.frame()`.

# as_duckdb_tibble() and readr data

    Code
      as_duckdb_tibble(readr::read_csv(path, show_col_types = FALSE))
    Condition
      Error in `as_duckdb_tibble()`:
      ! The input is data read by readr, and duckplyr supports reading CSV files directly.
      i Use `read_csv_duckdb()` to read with the built-in reader.
      i To proceed with the data as read by readr, use `as_tibble()` before `as_duckdb_tibble()`.

