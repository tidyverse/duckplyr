# duckplyr_group_by(add =) is defunct

    Code
      duckplyr_group_by(df, x, add = TRUE)
    Condition
      Error:
      ! The `add` argument of `group_by()` was deprecated in dplyr 1.0.0 and is now defunct.
      i Please use the `.add` argument instead.

# group_by_prepare(add =) is defunct

    Code
      group_by_prepare(df, x, add = TRUE)
    Condition
      Error:
      ! The `add` argument of `group_by()` was deprecated in dplyr 1.0.0 and is now defunct.
      i Please use the `.add` argument instead.

# duckplyr_group_by(.dots =) is defunct

    Code
      duckplyr_group_by(df, .dots = "x")
    Condition
      Error:
      ! The `.dots` argument of `group_by()` was deprecated in dplyr 1.0.0 and is now defunct.

# group_by_prepare(.dots =) is defunct

    Code
      group_by_prepare(df, .dots = "x")
    Condition
      Error:
      ! The `.dots` argument of `group_by()` was deprecated in dplyr 1.0.0 and is now defunct.

