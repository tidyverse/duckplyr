pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = 1)

load("tools/tpch/001.rda")

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
  tpch_10
)

res <- list()

for (q in seq_along(test_dplyr_q)) {
  f <- test_dplyr_q[[q]]
  cold <- as.data.frame(f())
  time <- system.time(as.data.frame(f()))[[3]]
  print(q)
  print(time)
  res[[q]] <- data.frame(pkg = pkg, q = q, time = time)
}

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))
