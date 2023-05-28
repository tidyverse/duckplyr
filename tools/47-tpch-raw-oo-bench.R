pkgload::load_all()

qloadm("tools/tpch/100.qs")

con <- get_default_duckdb_connection()
experimental <- FALSE

test_dplyr_q <- head(n = -1, list(
  tpch_01 = tpch_raw_oo_01,
  tpch_02 = tpch_raw_oo_02,
  tpch_03 = tpch_raw_oo_03,
  tpch_04 = tpch_raw_oo_04,
  tpch_05 = tpch_raw_oo_05,
  tpch_06 = tpch_raw_oo_06,
  tpch_07 = tpch_raw_oo_07, # string error
  tpch_08 = tpch_raw_oo_08, # string error
  tpch_09 = tpch_raw_oo_09, # string error
  tpch_10 = tpch_raw_oo_10,
  tpch_11 = tpch_raw_oo_11,
  tpch_12 = tpch_raw_oo_12,
  tpch_13 = tpch_raw_oo_13, # takes prohibitively long time
  tpch_14 = tpch_raw_oo_14,
  tpch_15 = tpch_raw_oo_15,
  tpch_16 = tpch_raw_oo_16,
  tpch_17 = tpch_raw_oo_17,
  tpch_18 = tpch_raw_oo_18,
  tpch_19 = tpch_raw_oo_19,
  tpch_20 = tpch_raw_oo_20,
  tpch_21 = tpch_raw_oo_21, # string error
  tpch_22 = tpch_raw_oo_22, # string error
  NULL
))

res <- list()
pkg <- "duckplyr-raw-oo"

for (q in names(test_dplyr_q)) {
  gc()
  f <- test_dplyr_q[[q]]
  cold <- nrow(f(con, experimental))
  time <- system.time(nrow(f(con, experimental)))[[3]]
  print(q)
  print(time)
  res[[q]] <- data.frame(pkg = pkg, q = q, time = time)
}

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))
