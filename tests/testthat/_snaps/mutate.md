# can't overwrite column active bindings (#6666)

    Code
      duckplyr_mutate(df, y = {
        x <<- 2
        x
      })
    Condition
      Error in `mutate()`:
      i In argument: `y = { ... }`.
      Caused by error:
      ! unused argument (base::quote(2))

---

    Code
      duckplyr_mutate(df, .by = g, y = {
        x <<- 2
        x
      })
    Condition
      Error in `mutate()`:
      i In argument: `y = { ... }`.
      i In group 1: `g = 1`.
      Caused by error:
      ! unused argument (base::quote(2))

# can't share local variables across expressions (#6666)

    Code
      duckplyr_mutate(df, x2 = {
        foo <- x
        x
      }, y2 = {
        foo
      })
    Condition
      Error in `mutate()`:
      i In argument: `y2 = { ... }`.
      Caused by error:
      ! object 'foo' not found

# `duckplyr_mutate()` doesn't allow data frames with missing or empty names (#6758)

    Code
      duckplyr_mutate(df2)
    Condition
      Error in `mutate()`:
      ! Can't transform a data frame with `NA` or `""` names.

