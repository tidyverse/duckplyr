# as_duckplyr_tibble() works

    Code
      as_duckplyr_tibble(tibble(a = 1))
    Condition
      Warning:
      `as_duckplyr_tibble()` was deprecated in duckplyr 1.0.0.
      i Please use `as_duck_tbl()` instead.
    Output
      # A duckplyr data frame: 1 variable
    Message
      DuckDB Relation: 
      ---------------------
      --- Relation Tree ---
      ---------------------
      r_dataframe_scan(0x5650c704bd30)
      
      ---------------------
      -- Result Columns  --
      ---------------------
      - a (DOUBLE)
      
    Output
            a
        <dbl>
      1     1

# as_duckplyr_df() and special df

    Code
      as_duckplyr_df(by_cyl)
    Condition
      Warning:
      `as_duckplyr_df()` was deprecated in duckplyr 1.0.0.
      i Please use `as_duck_tbl()` instead.
      Error in `as_duckplyr_df()`:
      ! Must pass a plain data frame or a tibble, not a <grouped_df> object.
      i Convert it with `as.data.frame()` or `tibble::as_tibble()`.

