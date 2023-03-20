pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)

load("tools/tpch/100.rda")

con <- get_default_duckdb_connection()

test_dplyr_q <- head(n = -1, list(
  tpch_raw_01,
  tpch_raw_02,
  tpch_raw_03,
  tpch_raw_04,
  tpch_raw_05,
  tpch_raw_06,
  tpch_raw_07,
  tpch_raw_08,
  tpch_raw_09,
  tpch_raw_10,
  tpch_raw_11,
  tpch_raw_12,
  tpch_raw_13,
  tpch_raw_14,
  tpch_raw_15,
  tpch_raw_16,
  tpch_raw_17,
  tpch_raw_18,
  tpch_raw_19,
  tpch_raw_20,
  tpch_raw_21,
  tpch_raw_22,
  NULL
))

res <- list()
pkg <- "duckdb"

for (q in seq_along(test_dplyr_q)) {
  f <- test_dplyr_q[[q]]
  cold <- collect(f())
  time <- system.time(collect(f()))[[3]]
  print(q)
  print(time)
  res[[q]] <- data.frame(pkg = pkg, q = q, time = time)
}

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))
