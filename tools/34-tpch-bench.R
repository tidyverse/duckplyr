pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)
Sys.setenv(DUCKPLYR_EXPERIMENTAL = FALSE)
Sys.setenv(DUCKPLYR_META_SKIP = TRUE)

# Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)

qloadm("tools/tpch/100.qs")

customer <- as_duckplyr_df(customer)
lineitem <- as_duckplyr_df(lineitem)
nation <- as_duckplyr_df(nation)
orders <- as_duckplyr_df(orders)
part <- as_duckplyr_df(part)
partsupp <- as_duckplyr_df(partsupp)
region <- as_duckplyr_df(region)
supplier <- as_duckplyr_df(supplier)

test_dplyr_q <- head(n = -1, list(
  tpch_01 = tpch_01,
  tpch_02 = tpch_02,
  tpch_03 = tpch_03,
  tpch_04 = tpch_04,
  tpch_05 = tpch_05,
  tpch_06 = tpch_06,
  tpch_07 = tpch_07, # string error
  tpch_08 = tpch_08, # string error
  tpch_09 = tpch_09, # string error
  tpch_10 = tpch_10,
  tpch_11 = tpch_11,
  tpch_12 = tpch_12,
  tpch_13 = tpch_13, # takes prohibitively long time
  tpch_14 = tpch_14,
  tpch_15 = tpch_15,
  tpch_16 = tpch_16,
  tpch_17 = tpch_17,
  tpch_18 = tpch_18,
  tpch_19 = tpch_19,
  tpch_20 = tpch_20,
  tpch_21 = tpch_21, # string error
  tpch_22 = tpch_22, # string error
  NULL
))

res <- list()
pkg <- "duckplyr"

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
