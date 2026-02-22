# name must be string

    Code
      duckplyr_count(df, x, name = 1)
    Condition
      Error in `count()`:
      ! `name` must be a single string, not the number 1.

---

    Code
      duckplyr_count(df, x, name = letters)
    Condition
      Error in `count()`:
      ! `name` must be a single string, not a character vector.

# duckplyr_count() owns errors (#6139)

    Code
      (expect_error(duckplyr_count(mtcars, new = 1 + "")))
    Output
      <error/dplyr:::mutate_error>
      Error in `group_by()`:
      i In argument: `new = 1 + ""`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator
    Code
      (expect_error(duckplyr_count(mtcars, wt = 1 + "")))
    Output
      <error/rlang_error>
      Error in `summarise()`:
      i In argument: `n = base::sum(1 + "", na.rm = TRUE)`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator

# tally() owns errors (#6139)

    Code
      (expect_error(tally(mtcars, wt = 1 + "")))
    Output
      <error/rlang_error>
      Error in `tally()`:
      i In argument: `n = base::sum(1 + "", na.rm = TRUE)`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator

# duckplyr_add_count() owns errors (#6139)

    Code
      (expect_error(duckplyr_add_count(mtcars, new = 1 + "")))
    Output
      <error/dplyr:::mutate_error>
      Error in `group_by()`:
      i In argument: `new = 1 + ""`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator
    Code
      (expect_error(duckplyr_add_count(mtcars, wt = 1 + "")))
    Output
      <error/dplyr:::mutate_error>
      Error in `mutate()`:
      i In argument: `n = base::sum(1 + "", na.rm = TRUE)`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator

# add_tally() owns errors (#6139)

    Code
      (expect_error(add_tally(mtcars, wt = 1 + "")))
    Output
      <error/dplyr:::mutate_error>
      Error in `add_tally()`:
      i In argument: `n = base::sum(1 + "", na.rm = TRUE)`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator

