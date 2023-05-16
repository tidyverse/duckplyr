pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)
Sys.setenv(DUCKPLYR_EXPERIMENTAL = FALSE)
Sys.setenv(DUCKPLYR_META_SKIP = TRUE)

# Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)

load("tools/tpch/100.rda")

con <- get_default_duckdb_connection()
experimental <- FALSE

customer <- as_duckplyr_df(customer)
lineitem <- as_duckplyr_df(lineitem)
nation <- as_duckplyr_df(nation)
orders <- as_duckplyr_df(orders)
part <- as_duckplyr_df(part)
partsupp <- as_duckplyr_df(partsupp)
region <- as_duckplyr_df(region)
supplier <- as_duckplyr_df(supplier)

test_dplyr_q <- head(n = -1, list(
	q01 = tpch_raw_01,
	q02 = tpch_raw_02,
	q03 = tpch_raw_03,
	q04 = tpch_raw_04,
	q05 = tpch_raw_05,
	q06 = tpch_raw_06,
	q07 = tpch_raw_07, # string error
	q08 = tpch_raw_08, # string error
	q09 = tpch_raw_09, # string error
	q10 = tpch_raw_10,
	q11 = tpch_raw_11,
	q12 = tpch_raw_12,
	q13 = tpch_raw_13, # takes prohibitively long time
	q14 = tpch_raw_14,
	q15 = tpch_raw_15,
	q16 = tpch_raw_16,
	q17 = tpch_raw_17,
	q18 = tpch_raw_18,
	q19 = tpch_raw_19,
	q20 = tpch_raw_20,
	q21 = tpch_raw_21, # string error
	q22 = tpch_raw_22, # string error
  NULL
))

res <- list()
pkg <- "relational-duckdb"

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