# can only supply one of .before and .after

    Code
      duckplyr_relocate(df, .before = 1, .after = 1)
    Condition
      Error in `relocate()`:
      ! Can't supply both `.before` and `.after`.

