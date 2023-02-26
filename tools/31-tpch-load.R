tables <- c("lineitem", "partsupp", "part", "supplier", "nation", "orders", "customer", "region")


lapply(tables, function(t) {
  assign(t, arrow::read_parquet(fs::path("tools/tpch/001", paste0(t, ".parquet"))), env = .GlobalEnv)
})

save(list = tables, file = "tools/tpch/001.rda")
