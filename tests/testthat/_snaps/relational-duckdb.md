# duckdb_rel_from_df()

    Code
      data.frame(a = vctrs::new_vctr(1:3)) %>% duckdb_rel_from_df()
    Condition
      Error in `duckdb_rel_from_df()`:
      ! Attributes are lost during conversion. Affected column: `a`.

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

