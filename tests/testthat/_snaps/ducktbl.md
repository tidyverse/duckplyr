# as_ducktbl() and grouped df

    Code
      as_ducktbl(dplyr::group_by(mtcars, cyl))
    Condition
      Error in `as_ducktbl_dispatch()`:
      ! duckplyr does not support `group_by()`.
      i Use `.by` instead.
      i To proceed with dplyr, use `as_tibble()` or `as.data.frame()`.

# as_ducktbl() and rowwise df

    Code
      as_ducktbl(dplyr::rowwise(mtcars))
    Condition
      Error in `as_ducktbl_dispatch()`:
      ! duckplyr does not support `rowwise()`.
      i To proceed with dplyr, use `as_tibble()` or `as.data.frame()`.

