# distinct errors when selecting an unknown column (#3140)

    Code
      df <- tibble(g = c(1, 2), x = c(1, 2))
      (expect_error(df %>% duckplyr_distinct(aa, x)))
    Message
      DuckDB Relation: 
      ---------------------
      --- Relation Tree ---
      ---------------------
      r_dataframe_scan(0x5650bfdf0218)
      
      ---------------------
      -- Result Columns  --
      ---------------------
      - g (DOUBLE)
      - x (DOUBLE)
      
    Output
      <error/rlang_error>
      Error in `distinct()`:
      ! Must use existing variables.
      x `aa` not found in `.data`.
    Code
      (expect_error(df %>% duckplyr_distinct(aa, bb)))
    Message
      DuckDB Relation: 
      ---------------------
      --- Relation Tree ---
      ---------------------
      r_dataframe_scan(0x5650bd6c5d48)
      
      ---------------------
      -- Result Columns  --
      ---------------------
      - g (DOUBLE)
      - x (DOUBLE)
      
    Output
      <error/rlang_error>
      Error in `distinct()`:
      ! Must use existing variables.
      x `aa` not found in `.data`.
      x `bb` not found in `.data`.
    Code
      (expect_error(df %>% duckplyr_distinct(.data$aa)))
    Message
      DuckDB Relation: 
      ---------------------
      --- Relation Tree ---
      ---------------------
      r_dataframe_scan(0x5650c8b4a468)
      
      ---------------------
      -- Result Columns  --
      ---------------------
      - g (DOUBLE)
      - x (DOUBLE)
      
    Output
      <error/rlang_error>
      Error in `distinct()`:
      ! Must use existing variables.
      x `aa` not found in `.data`.
    Code
      (expect_error(df %>% duckplyr_distinct(y = a + 1)))
    Message
      DuckDB Relation: 
      ---------------------
      --- Relation Tree ---
      ---------------------
      r_dataframe_scan(0x5650c3935d58)
      
      ---------------------
      -- Result Columns  --
      ---------------------
      - g (DOUBLE)
      - x (DOUBLE)
      
    Output
      <error/dplyr:::mutate_error>
      Error in `distinct()`:
      i In argument: `y = a + 1`.
      Caused by error:
      ! object 'a' not found

