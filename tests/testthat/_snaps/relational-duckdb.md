# duckdb_rel_from_df()

    Code
      data.frame(a = vctrs::new_vctr(1:3)) %>% duckdb_rel_from_df()
    Condition
      Error in `duckdb_rel_from_df()`:
      ! Can't convert column `a` to relational.

# duckdb_rel_from_df() error call

    Code
      as_duckdb_tibble(data.frame(a = factor(letters)))
    Condition
      Error in `duckdb_rel_from_df()`:
      ! Can't convert column `a` to relational.

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
      

