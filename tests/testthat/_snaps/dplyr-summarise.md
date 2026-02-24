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

# non-summary results are defunct in favor of `duckplyr_reframe()` (#6382, #7761)

    Code
      out <- duckplyr_summarise(df, x = which(x < 3))
    Condition
      Error in `summarise()`:
      i In argument: `x = which(x < 3)`.
      Caused by error:
      ! `x` must be size 1, not 2.
      i To return more or less than 1 row per group, use `reframe()`.

---

    Code
      out <- duckplyr_summarise(df, x = which(x < 3), .by = g)
    Condition
      Error in `summarise()`:
      i In argument: `x = which(x < 3)`.
      i In group 1: `g = 1`.
      Caused by error:
      ! `x` must be size 1, not 2.
      i To return more or less than 1 row per group, use `reframe()`.

