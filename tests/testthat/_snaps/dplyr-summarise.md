# can't overwrite column active bindings (#6666)

    Code
      duckplyr_summarise(df, y = {
        x <<- x + 2L
        mean(x)
      })
    Condition
      Error in `summarise()`:
      i In argument: `y = { ... }`.
      Caused by error:
      ! unused argument (base::quote(3:6))

---

    Code
      duckplyr_summarise(df, .by = g, y = {
        x <<- x + 2L
        mean(x)
      })
    Condition
      Error in `summarise()`:
      i In argument: `y = { ... }`.
      i In group 1: `g = 1`.
      Caused by error:
      ! unused argument (base::quote(3:4))

# can't use `.by` with `.groups`

    Code
      duckplyr_summarise(df, .by = x, .groups = "drop")
    Condition
      Error in `summarise()`:
      ! Can't supply both `.by` and `.groups`.

# non-summary results are deprecated in favor of `duckplyr_reframe()` (#6382)

    Code
      out <- duckplyr_summarise(df, x = which(x < 3))
    Condition
      Warning:
      Returning more (or less) than 1 row per `summarise()` group was deprecated in dplyr 1.1.0.
      i Please use `reframe()` instead.
      i When switching from `summarise()` to `reframe()`, remember that `reframe()` always returns an ungrouped data frame and adjust accordingly.

---

    Code
      out <- duckplyr_summarise(df, x = which(x < 3), .by = g)
    Condition
      Warning:
      Returning more (or less) than 1 row per `summarise()` group was deprecated in dplyr 1.1.0.
      i Please use `reframe()` instead.
      i When switching from `summarise()` to `reframe()`, remember that `reframe()` always returns an ungrouped data frame and adjust accordingly.

