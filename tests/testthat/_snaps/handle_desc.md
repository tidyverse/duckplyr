# desc() fails if it points elsewhere

    Code
      duckdb_tibble(a = 1:3, .prudence = "frugal") %>% arrange(desc(a))
    Condition
      Error in `arrange()`:
      ! This operation cannot be carried out by DuckDB, and the input is a frugal duckplyr frame.
      i Use `compute(prudence = "lavish")` to materialize to temporary storage and continue with duckplyr.
      i See `vignette("prudence")` for other options.
      Caused by error in `arrange()`:
      ! Function `desc()` does not map to `dplyr::desc()`.

# desc() fails for more than one argument

    Code
      duckdb_tibble(a = 1:3, b = 4:6, .prudence = "frugal") %>% arrange(desc(a, b))
    Condition
      Error in `arrange()`:
      ! This operation cannot be carried out by DuckDB, and the input is a frugal duckplyr frame.
      i Use `compute(prudence = "lavish")` to materialize to temporary storage and continue with duckplyr.
      i See `vignette("prudence")` for other options.
      Caused by error in `arrange()`:
      ! Function `desc()` must be called with exactly one argument.

