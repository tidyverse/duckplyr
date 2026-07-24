pkgload::load_all()

tables <- c(
  "lineitem",
  "partsupp",
  "part",
  "supplier",
  "nation",
  "orders",
  "customer",
  "region"
)

scale_factors <- c("001", "010", "100")

# Convert one table at a time, and give each table its own file.
#
# Collecting every table into a list before writing peaks at the size of the
# whole dataset, which at scale factor 1 is dominated by `lineitem`.
# Doing the work per table bounds peak memory by the largest single table
# instead, and lets the benchmark load them the same way.
#
# `dplyr::collect()` materializes the lazy, DuckDB-backed `duckplyr_df` into a
# plain tibble. Without it, qs2 stores an object that comes back carrying the
# `duckplyr_df` class and explicit row names, and `as_duckdb_tibble()` then
# aborts with "Need data frame without row names to convert to relational".
convert_table <- function(sf, table) {
  data <- dplyr::collect(
    duckplyr::read_parquet_duckdb(
      fs::path("tools/tpch", sf, paste0(table, ".parquet")),
      prudence = "lavish"
    )
  )

  qs2::qs_save(
    data,
    file = fs::path("tools/tpch", sf, paste0(table, ".qs")),
    compress_level = 1,
    shuffle = FALSE
  )
}

for (sf in scale_factors) {
  for (table in tables) {
    convert_table(sf, table)
    # Release the table before reading the next one.
    gc()
  }
}
