# name must be string

    Code
      duckplyr_count(df, x, name = 1)
    Condition
      Error in `tally()`:
      ! `name` must be a single string, not the number 1.

---

    Code
      duckplyr_count(df, x, name = letters)
    Condition
      Error in `tally()`:
      ! `name` must be a single string, not a character vector.

# add_tally() owns errors (#6139)

    Code
      (expect_error(add_tally(mtcars, wt = 1 + "")))
    Output
      <error/dplyr:::mutate_error>
      Error in `add_tally()`:
      i In argument: `n = sum(1 + "", na.rm = TRUE)`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator

