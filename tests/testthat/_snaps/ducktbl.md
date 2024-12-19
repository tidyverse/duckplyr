# as_duck_tbl() and grouped df

    Code
      as_duck_tbl(dplyr::group_by(mtcars, cyl))
    Condition
      Error in `as_duck_tbl_dispatch()`:
      ! duckplyr does not support `group_by()`.
      i Use `.by` instead.
      i To proceed with dplyr, use `as_tibble()` or `as.data.frame()`.

# as_duck_tbl() and rowwise df

    Code
      as_duck_tbl(dplyr::rowwise(mtcars))
    Condition
      Error in `as_duck_tbl_dispatch()`:
      ! duckplyr does not support `rowwise()`.
      i To proceed with dplyr, use `as_tibble()` or `as.data.frame()`.

