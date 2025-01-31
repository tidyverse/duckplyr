# desc() fails if it points elsewhere

    Code
      duckdb_tibble(a = 1:3, .prudence = "frugal") %>% arrange(desc(a))
    Condition
      Error in `arrange()`:
      ! This operation cannot be carried out by DuckDB, and the input is a frugal duckplyr frame.
      i Use `compute(prudence = "lavish")` to materialize to temporary storage and continue with duckplyr.
      i See `vignette("funnel")` for other options.
      Caused by error in `rel_find_call()`:
      ! Function `desc` does not map to `dplyr::desc`.

