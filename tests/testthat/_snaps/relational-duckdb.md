# duckdb_rel_from_df()

    Code
      data.frame(a = vctrs::new_vctr(1:3)) %>% duckdb_rel_from_df()
    Condition
      Error in `check_df_for_rel()`:
      ! Can't convert columns of class <vctrs_vctr> to relational. Affected column: `a`.

# rel_aggregate()

    Code
      grouped %>% rel_to_df() %>% arrange(species)
    Output
          species mean_bill_length_mm
      1    Adelie            38.79139
      2 Chinstrap            48.83382
      3    Gentoo            47.50488
    Code
      ungrouped %>% rel_to_df()
    Output
        mean_bill_length_mm
      1            43.92193

# duckdb_rel_from_df() uses materialized results

    Code
      duckdb_rel_from_df(df)
    Message
      DuckDB Relation: 
      ---------------------
      --- Relation Tree ---
      ---------------------
      Projection [a as a]
        Order [___row_number ASC]
          Filter ["r_base::=="(a, 1.0)]
            Projection [a as a, row_number() OVER () as ___row_number]
              r_dataframe_scan(0xdeadbeef)
      
      ---------------------
      -- Result Columns  --
      ---------------------
      - a (DOUBLE)
      
    Code
      nrow(df)
    Output
      duckplyr: materializing
      [1] 1
    Code
      duckdb_rel_from_df(df)
    Message
      DuckDB Relation: 
      ---------------------
      --- Relation Tree ---
      ---------------------
      r_dataframe_scan(0xdeadbeef)
      
      ---------------------
      -- Result Columns  --
      ---------------------
      - a (DOUBLE)
      

