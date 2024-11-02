# validate_grouped_df() gives useful errors

    Code
      (expect_error(validate_grouped_df(df1)))
    Output
      <simpleError in validate_grouped_df(df1): could not find function "validate_grouped_df">
    Code
      (expect_error(group_data(df1)))
    Output
      <error/rlang_error>
      Error in `group_data()`:
      ! `.data` must be a valid <grouped_df> object.
      Caused by error in `validate_grouped_df()`:
      ! The `.rows` column must be list of one-based integer vectors.
    Code
      (expect_error(validate_grouped_df(df2)))
    Output
      <simpleError in validate_grouped_df(df2): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df2)))
    Output
      <simpleError in validate_grouped_df(df2): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df3)))
    Output
      <simpleError in validate_grouped_df(df3): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df4)))
    Output
      <simpleError in validate_grouped_df(df4): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df5)))
    Output
      <simpleError in validate_grouped_df(df5): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df6, check_bounds = TRUE)))
    Output
      <simpleError in validate_grouped_df(df6, check_bounds = TRUE): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df7, check_bounds = TRUE)))
    Output
      <simpleError in validate_grouped_df(df7, check_bounds = TRUE): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df8, check_bounds = TRUE)))
    Output
      <simpleError in validate_grouped_df(df8, check_bounds = TRUE): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df10)))
    Output
      <simpleError in validate_grouped_df(df10): could not find function "validate_grouped_df">
    Code
      (expect_error(validate_grouped_df(df11)))
    Output
      <simpleError in validate_grouped_df(df11): could not find function "validate_grouped_df">
    Code
      (expect_error(new_grouped_df(tibble(x = 1:10), tibble(other = list(1:2)))))
    Output
      <error/rlang_error>
      Error in `new_grouped_df()`:
      ! The last column of `groups` must be called ".rows".
    Code
      (expect_error(new_grouped_df(10)))
    Output
      <error/rlang_error>
      Error in `new_grouped_df()`:
      ! `x` must be a data frame.

# helper gives meaningful error messages

    Code
      (expect_error(grouped_df(data.frame(x = 1), "y", FALSE)))
    Output
      <error/rlang_error>
      Error in `compute_groups()`:
      ! `vars` missing from `data`: `y`.
    Code
      (expect_error(grouped_df(data.frame(x = 1), 1)))
    Output
      <error/rlang_error>
      Error in `grouped_df()`:
      ! `vars` must be a character vector.

