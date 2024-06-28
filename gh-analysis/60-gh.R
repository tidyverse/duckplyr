library(tidyverse)
pkgload::load_all()

contents <- duckplyr_df_from_parquet("gh-analysis/data/r_contents-*.parquet", class = class(tibble()))

contents |>
  count(binary)

ids <-
  contents |>
  filter(!binary) |>
  pull(id)

fs::dir_create("gh-analysis/data/contents")

sql <- paste0(
  ".output\nSELECT ", seq_along(ids), ";\n",
  ".output gh-analysis/data/contents/", ids, ".R\n",
  "SELECT content FROM contents WHERE id = '", ids, "';"
)

header <- ".bail on
CREATE TEMP TABLE contents AS SELECT * FROM read_parquet('gh-analysis/data/r_contents-*.parquet');
.mode line
.headers off
"

writeLines(c(header, sql), "gh-analysis/data/extract.sql")
