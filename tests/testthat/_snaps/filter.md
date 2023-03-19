# duckplyr_filter() allows matrices with 1 column with a deprecation warning (#6091)

    Code
      out <- duckplyr_filter(df, matrix(c(TRUE, FALSE), nrow = 2))
    Condition
      Warning:
      Using one column matrices in `filter()` was deprecated in dplyr 1.1.0.
      i Please use one dimensional logical vectors instead.

# duckplyr_filter() disallows matrices with >1 column

    Code
      (expect_error(duckplyr_filter(df, matrix(TRUE, nrow = 3, ncol = 2))))
    Output
      <error/rlang_error>
      Error in `filter()`:
      i In argument: `matrix(TRUE, nrow = 3, ncol = 2)`.
      Caused by error:
      ! `..1` must be a logical vector, not a logical matrix.

# duckplyr_filter() disallows arrays with >2 dimensions

    Code
      (expect_error(duckplyr_filter(df, array(TRUE, dim = c(3, 1, 1)))))
    Output
      <error/rlang_error>
      Error in `filter()`:
      i In argument: `array(TRUE, dim = c(3, 1, 1))`.
      Caused by error:
      ! `..1` must be a logical vector, not a logical array.

# `duckplyr_filter()` doesn't allow data frames with missing or empty names (#6758)

    Code
      duckplyr_filter(df1)
    Condition
      Error in `filter()`:
      ! Can't transform a data frame with `NA` or `""` names.

---

    Code
      duckplyr_filter(df2)
    Condition
      Error in `filter()`:
      ! Can't transform a data frame with `NA` or `""` names.

# can't use `.by` with `.preserve`

    Code
      duckplyr_filter(df, .by = x, .preserve = TRUE)
    Condition
      Error in `filter()`:
      ! Can't supply both `.by` and `.preserve`.

# catches `by` typo (#6647)

    Code
      duckplyr_filter(df, by = x)
    Condition
      Error in `filter()`:
      ! Can't specify an argument named `by` in this verb.
      i Did you mean to use `.by` instead?

