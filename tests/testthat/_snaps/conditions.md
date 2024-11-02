# `err_locs()` works as expected

    Code
      err_locs(1.5)
    Condition
      Error in `err_locs()`:
      ! could not find function "err_locs"

---

    Code
      err_locs(integer())
    Condition
      Error in `err_locs()`:
      ! could not find function "err_locs"

# errors during dots collection are not enriched (#6178)

    Code
      duckplyr_mutate(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"
    Code
      duckplyr_transmute(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"
    Code
      duckplyr_select(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"
    Code
      duckplyr_arrange(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"
    Code
      duckplyr_filter(mtcars, !!foobarbaz())
    Condition
      Error in `foobarbaz()`:
      ! could not find function "foobarbaz"

# warnings are collected for `last_dplyr_warnings()`

    Code
      # Ungrouped
      df %>% duckplyr_mutate(x = f()) %>% invisible()
    Condition
      Warning:
      There was 1 warning in `mutate()`.
      i In argument: `x = f()`.
      Caused by warning in `f()`:
      ! msg
    Code
      last_dplyr_warnings()
    Output
      [[1]]
      <warning/rlang_warning>
      Warning in `mutate()`:
      i In argument: `x = f()`.
      Caused by warning in `f()`:
      ! msg
      ---
      Backtrace:
          x
       1. +-df %>% duckplyr_mutate(x = f()) %>% invisible()
       2. \-duckplyr:::duckplyr_mutate(., x = f())
       3.   +-dplyr::mutate(.data, ...)
       4.   \-duckplyr:::mutate.duckplyr_df(.data, ...)
       5.     \-dplyr::mutate(...)
      

