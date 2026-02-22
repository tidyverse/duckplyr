pkgload::load_all()

tables <- c("lineitem", "partsupp", "part", "supplier", "nation", "orders", "customer", "region")

data <- lapply(tables, function(t) {
  duckplyr::read_parquet_duckdb(fs::path("tools/tpch/001", paste0(t, ".parquet")), prudence = "lavish")
})

qs2::qs_save(rlang::set_names(data, tables), file = "tools/tpch/001.qs", compress_level = 1, shuffle = FALSE)

data <- lapply(tables, function(t) {
  duckplyr::read_parquet_duckdb(fs::path("tools/tpch/010", paste0(t, ".parquet")), prudence = "lavish")
})

qs2::qs_save(rlang::set_names(data, tables), file = "tools/tpch/010.qs", compress_level = 1, shuffle = FALSE)

data <- lapply(tables, function(t) {
  duckplyr::read_parquet_duckdb(fs::path("tools/tpch/100", paste0(t, ".parquet")), prudence = "lavish")
})

qs2::qs_save(rlang::set_names(data, tables), file = "tools/tpch/100.qs", compress_level = 1, shuffle = FALSE)
