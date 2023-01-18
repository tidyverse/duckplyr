# can't use `.by` with `.groups`

    Code
      duckplyr_summarise(df, .by = x, .groups = "drop")
    Condition
      Error in `summarise()`:
      ! Can't supply both `.by` and `.groups`.

