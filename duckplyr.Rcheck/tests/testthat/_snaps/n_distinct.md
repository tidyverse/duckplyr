# duckdb n_distinct() error with more than one argument

    Code
      df %>% summarise(dummy = n_distinct(a, b))
    Condition
      Error in `summarise()`:
      ! `n_distinct()` needs exactly one argument besides the optional `na.rm`

# duckdb n_distinct() error with na.rm not being TRUE/FALSE

    Code
      df %>% summarise(dummy = n_distinct(a, na.rm = "b"))
    Condition
      Error in `summarise()`:
      ! Invalid value for `na.rm` in call to `n_distinct()`

# duckdb n_distinct() error with mutate

    Code
      df %>% mutate(dummy = n_distinct(a))
    Condition
      Error in `mutate()`:
      ! `n_distinct()` not supported in window functions

