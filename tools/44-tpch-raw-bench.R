pkgload::load_all()

qloadm("tools/tpch/100.qs")

con <- get_default_duckdb_connection()
experimental <- FALSE

compiler::enableJIT(0)

test_dplyr_q <- head(n = -1, list(
  tpch_01 = tpch_raw_01,
  tpch_02 = tpch_raw_02,
  tpch_03 = tpch_raw_03,
  tpch_04 = tpch_raw_04,
  tpch_05 = tpch_raw_05,
  tpch_06 = tpch_raw_06,
  tpch_07 = tpch_raw_07, # string error
  tpch_08 = tpch_raw_08, # string error
  tpch_09 = tpch_raw_09, # string error
  tpch_10 = tpch_raw_10,
  tpch_11 = tpch_raw_11,
  tpch_12 = tpch_raw_12,
  tpch_13 = tpch_raw_13, # takes prohibitively long time
  tpch_14 = tpch_raw_14,
  tpch_15 = tpch_raw_15,
  tpch_16 = tpch_raw_16,
  tpch_17 = tpch_raw_17,
  tpch_18 = tpch_raw_18,
  tpch_19 = tpch_raw_19,
  tpch_20 = tpch_raw_20,
  tpch_21 = tpch_raw_21, # string error
  tpch_22 = tpch_raw_22, # string error
  NULL
))

res <- list()
pkg <- "duckplyr-raw"

for (q in names(test_dplyr_q)) {
  gc()
  f <- test_dplyr_q[[q]]
  # Use nrow() to collect
  cold <- nrow(f(con, experimental))
  cold <- nrow(f(con, experimental))
  time <- system.time(nrow(f(con, experimental)))[[3]]
  print(q)
  print(time)
  res[[q]] <- data.frame(pkg = pkg, q = q, time = time)
}

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))
