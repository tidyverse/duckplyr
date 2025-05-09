pkgload::load_all()

df <-
  duckdb_tibble(a = 1, b = 2, c = 3) |>
  select(a, b)

names(df) <- c("c", "d")

df2 <-
  df |>
  slice_head(n = 1) |>
  select(c)

df2 |>
  duckdb$rel_from_altrep_df()

df$c

df2 |>
  duckdb$rel_from_altrep_df()
