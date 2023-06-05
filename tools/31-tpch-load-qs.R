tables <- c("lineitem", "partsupp", "part", "supplier", "nation", "orders", "customer", "region")

data <- lapply(tables, function(t) {
  arrow::read_parquet(fs::path("tools/tpch/001", paste0(t, ".parquet")))
})

qs::qsave(set_names(data, tables), file = "tools/tpch/001.qs", preset = "fast")

data <- lapply(tables, function(t) {
  arrow::read_parquet(fs::path("tools/tpch/010", paste0(t, ".parquet")))
})

qs::qsave(set_names(data, tables), file = "tools/tpch/010.qs", preset = "fast")

data <- lapply(tables, function(t) {
  arrow::read_parquet(fs::path("tools/tpch/100", paste0(t, ".parquet")))
})

qs::qsave(set_names(data, tables), file = "tools/tpch/100.qs", preset = "fast")
