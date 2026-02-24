# duckplyr_filter() and duckplyr_filter_out() allow matrices with 1 column with a deprecation warning (#6091)

    Code
      out <- duckplyr_filter(df, matrix(c(TRUE, FALSE), nrow = 2))
    Condition
      Warning:
      Using one column matrices in `filter()` or `filter_out()` was deprecated in dplyr 1.1.0.
      i Please use one dimensional logical vectors instead.

---

    Code
      out <- duckplyr_filter_out(df, matrix(c(TRUE, FALSE), nrow = 2))
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(.by)
      
        # Now:
        data %>% select(all_of(.by))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Warning:
      Using one column matrices in `filter()` or `filter_out()` was deprecated in dplyr 1.1.0.
      i Please use one dimensional logical vectors instead.

# duckplyr_filter() and duckplyr_filter_out() disallow matrices with >1 column

    Code
      duckplyr_filter(df, matrix(TRUE, nrow = 3, ncol = 2))
    Condition
      Error in `filter()`:
      i In argument: `matrix(TRUE, nrow = 3, ncol = 2)`.
      Caused by error:
      ! `..1` must be a logical vector, not a logical matrix.

---

    Code
      duckplyr_filter_out(df, matrix(TRUE, nrow = 3, ncol = 2))
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(.by)
      
        # Now:
        data %>% select(all_of(.by))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Error in `filter_out()`:
      i In argument: `matrix(TRUE, nrow = 3, ncol = 2)`.
      Caused by error:
      ! `..1` must be a logical vector, not a logical matrix.

# duckplyr_filter() and duckplyr_filter_out() disallow arrays with >2 dimensions

    Code
      duckplyr_filter(df, array(TRUE, dim = c(3, 1, 1)))
    Condition
      Error in `filter()`:
      i In argument: `array(TRUE, dim = c(3, 1, 1))`.
      Caused by error:
      ! `..1` must be a logical vector, not a logical array.

---

    Code
      duckplyr_filter_out(df, array(TRUE, dim = c(3, 1, 1)))
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(.by)
      
        # Now:
        data %>% select(all_of(.by))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Error in `filter_out()`:
      i In argument: `array(TRUE, dim = c(3, 1, 1))`.
      Caused by error:
      ! `..1` must be a logical vector, not a logical array.

# Using data frames in `duckplyr_filter()` is defunct (#7758)

    Code
      duckplyr_filter(df, across(everything(), ~ .x > 0))
    Condition
      Error in `filter()`:
      i In argument: `across(everything(), ~.x > 0)`.
      Caused by error:
      ! `..1` must be a logical vector, not a <tbl_df/tbl/data.frame> object.
      i If you used `across()` to generate this data frame, please use `if_any()` or `if_all()` instead.

# can't use `.by` with `.preserve`

    Code
      duckplyr_filter(df, .by = x, .preserve = TRUE)
    Condition
      Error in `filter()`:
      ! Can't supply both `.by` and `.preserve`.

---

    Code
      duckplyr_filter_out(df, .by = x, .preserve = TRUE)
    Condition
      Error in `filter_out()`:
      ! Can't supply both `.by` and `.preserve`.

# catches `by` typo (#6647)

    Code
      duckplyr_filter(df, by = x)
    Condition
      Error in `filter()`:
      ! Can't specify an argument named `by` in this verb.
      i Did you mean to use `.by` instead?

---

    Code
      duckplyr_filter_out(df, by = x)
    Condition
      Error in `filter_out()`:
      ! Can't specify an argument named `by` in this verb.
      i Did you mean to use `.by` instead?

