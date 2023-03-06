tables <- c("lineitem", "partsupp", "part", "supplier", "nation", "orders", "customer", "region")

lapply(tables, function(t) {
  df <- arrow::read_parquet(fs::path("tools/tpch/001", paste0(t, ".parquet")))
  assign(t, as.data.frame(df), env = .GlobalEnv)
})

save(list = tables, file = "tools/tpch/001.rda", compress = FALSE)

lapply(tables, function(t) {
  df <- arrow::read_parquet(fs::path("tools/tpch/010", paste0(t, ".parquet")))
  assign(t, as.data.frame(df), env = .GlobalEnv)
})

save(list = tables, file = "tools/tpch/010.rda", compress = FALSE)

lapply(tables, function(t) {
  df <- arrow::read_parquet(fs::path("tools/tpch/100", paste0(t, ".parquet")))
  assign(t, as.data.frame(df), env = .GlobalEnv)
})

save(list = tables, file = "tools/tpch/100.rda", compress = FALSE)
