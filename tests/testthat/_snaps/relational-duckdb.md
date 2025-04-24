# rel_aggregate()

    Code
      grouped %>% rel_to_df(prudence = "lavish") %>% arrange(species)
    Output
      # A duckplyr data frame: 2 variables
        species   mean_bill_length_mm
        <chr>                   <dbl>
      1 Adelie                   38.8
      2 Chinstrap                48.8
      3 Gentoo                   47.5
    Code
      ungrouped %>% rel_to_df(prudence = "lavish")
    Output
      # A duckplyr data frame: 1 variable
        mean_bill_length_mm
                      <dbl>
      1                43.9

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
          Filter [(a = 1.0)]
            Projection [a as a, row_number() OVER () as ___row_number]
              r_dataframe_scan(0xdeadbeef)
      
      ---------------------
      -- Result Columns  --
      ---------------------
      - a (DOUBLE)
      

---

    Code
      nrow(df)
    Output
      [1] 1

---

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
      

