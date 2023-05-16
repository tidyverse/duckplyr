pkgload::load_all()

load("tools/tpch/100.rda")

con <- get_default_duckdb_connection()
experimental <- FALSE

test_dplyr_q <- head(n = -1, list(
    q01 = tpch_raw_oo_01,
    q02 = tpch_raw_oo_02,
    q03 = tpch_raw_oo_03,
    q04 = tpch_raw_oo_04,
    q05 = tpch_raw_oo_05,
    q06 = tpch_raw_oo_06,
    q07 = tpch_raw_oo_07, # string error
    q08 = tpch_raw_oo_08, # string error
    q09 = tpch_raw_oo_09, # string error
    q10 = tpch_raw_oo_10,
    q11 = tpch_raw_oo_11,
    q12 = tpch_raw_oo_12,
    q13 = tpch_raw_oo_13, # takes prohibitively long time
    q14 = tpch_raw_oo_14,
    q15 = tpch_raw_oo_15,
    q16 = tpch_raw_oo_16,
    q17 = tpch_raw_oo_17,
    q18 = tpch_raw_oo_18,
    q19 = tpch_raw_oo_19,
    q20 = tpch_raw_oo_20,
    q21 = tpch_raw_oo_21, # string error
    q22 = tpch_raw_oo_22, # string error
  NULL
))

res <- list()
pkg <- "duckplyr-raw-oo"

for (q in names(test_dplyr_q)) {
  f <- test_dplyr_q[[q]]
  cold <- collect(f(con, experimental))
  time <- system.time(collect(f(con, experimental)))[[3]]
  print(q)
  print(time)
  res[[q]] <- data.frame(pkg = pkg, q = q, time = time)
}

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))
