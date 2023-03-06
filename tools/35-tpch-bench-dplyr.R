pkgload::load_all()

load("tools/tpch/100.rda")

test_dplyr_q <- list(
  tpch_01,
  tpch_02,
  tpch_03,
  tpch_04,
  tpch_05,
  tpch_06,
  tpch_07,
  tpch_08,
  tpch_09,
  tpch_10,
  tpch_11,
  tpch_12,
  tpch_13,
  tpch_14,
  tpch_15,
  tpch_16,
  tpch_17,
  tpch_18,
  tpch_19,
  tpch_20,
  tpch_21,
  tpch_22
)

res <- list()
pkg <- "dplyr"

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
