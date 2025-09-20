pkgload::load_all()

df1 <-
  duckdb_tibble(a = 1, b = 2, c = 3) |>
  select(a, b) |>
  slice_head(n = 1)

df2 <-
  df1 |>
  select(b)

df2 |>
  duckdb$rel_from_altrep_df()

df2 |>
  explain()

df1$a

df2 |>
  duckdb$rel_from_altrep_df(wrap = TRUE)

df2 |>
  explain()

df2$b

df2 |>
  duckdb$rel_from_altrep_df(wrap = TRUE)
