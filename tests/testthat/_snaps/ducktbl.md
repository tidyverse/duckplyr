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

