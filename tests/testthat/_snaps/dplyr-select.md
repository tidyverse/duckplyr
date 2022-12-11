# grouping variables preserved with a message, unless already selected (#1511, #5841)

    Code
      res <- duckplyr_select(df, x)

# non-syntactic grouping variable is preserved (#1138)

    Code
      df <- tibble(`a b` = 1L) %>% duckplyr_group_by(`a b`) %>% duckplyr_select()

# duckplyr_select() provides informative errors

    Code
      (expect_error(duckplyr_select(mtcars, 1 + "")))
    Output
      <error/rlang_error>
      Error in `select()`:
      ! Problem while evaluating `1 + ""`.
      Caused by error in `1 + ""`:
      ! non-numeric argument to binary operator

# dplyr_col_select() aborts when `[` implementation is broken

    Code
      (expect_error(duckplyr_select(df1, 1:2)))
    Output
      <error/vctrs_error_subscript_oob>
      Error in `select()`:
      ! Can't subset columns past the end.
      i Location 2 doesn't exist.
      i There is only 1 column.
    Code
      (expect_error(duckplyr_select(df1, 0)))
    Output
      <error/rlang_error>
      Error in `select()`:
      ! Can't reconstruct data frame.
      x The `[` method for class <duckplyr_df/dplyr_test_broken_operator/tbl_df/tbl/data.frame> must return a data frame.
      i It returned a <list>.

---

    Code
      (expect_error(duckplyr_select(df1, 2)))
    Output
      <error/vctrs_error_subscript_oob>
      Error in `select()`:
      ! Can't subset columns past the end.
      i Location 2 doesn't exist.
      i There is only 1 column.
    Code
      (expect_error(duckplyr_select(df1, 1)))
    Output
      <error/rlang_error>
      Error in `select()`:
      ! Can't reconstruct data frame.
      x The `[` method for class <duckplyr_df/dplyr_test_broken_operator/tbl_df/tbl/data.frame> must return a data frame.
      i It returned a <list>.
    Code
      (expect_error(duckplyr_select(df2, 1)))
    Output
      <error/rlang_error>
      Error in `select()`:
      ! Can't reconstruct data frame.
      x The `[` method for class <duckplyr_df/dplyr_test_operator_wrong_size/tbl_df/tbl/data.frame> must return a data frame with 1 column.
      i It returned a <data.frame> of 0 columns.

