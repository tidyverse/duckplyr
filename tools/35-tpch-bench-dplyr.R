pkgload::load_all()

load("tools/tpch/100.rda")

test_dplyr_q <- head(n = -1, list(
    q01 = tpch_01,
    q02 = tpch_02,
    q03 = tpch_03,
    q04 = tpch_04,
    q05 = tpch_05,
    q06 = tpch_06,
    q07 = tpch_07,
    q08 = tpch_08,
    q09 = tpch_09,
    q10 = tpch_10,
    q11 = tpch_11,
    q12 = tpch_12,
    q13 = tpch_13,
    q14 = tpch_14,
    q15 = tpch_15,
    q16 = tpch_16,
    q17 = tpch_17,
    q18 = tpch_18,
    q19 = tpch_19,
    q20 = tpch_20,
  # q21 = tpch_21, # prohibitive
    q22 = tpch_22,
  NULL
))

res <- list()
pkg <- "dplyr"

for (q in names(test_dplyr_q)) {
  f <- test_dplyr_q[[q]]
  cold <- collect(f())
  time <- system.time(collect(f()))[[3]]
  print(q)
  print(time)
  res[[q]] <- data.frame(pkg = pkg, q = q, time = time)
}

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))
