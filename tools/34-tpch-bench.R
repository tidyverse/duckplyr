pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = 1)

load("tools/tpch/100.rda")

customer <- as_duckplyr_df(customer)
lineitem <- as_duckplyr_df(lineitem)
nation <- as_duckplyr_df(nation)
orders <- as_duckplyr_df(orders)
part <- as_duckplyr_df(part)
partsupp <- as_duckplyr_df(partsupp)
region <- as_duckplyr_df(region)
supplier <- as_duckplyr_df(supplier)

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
