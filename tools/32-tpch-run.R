pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)
Sys.setenv(DUCKPLYR_EXPERIMENTAL = FALSE)
Sys.setenv(DUCKPLYR_META_GLOBAL = TRUE)

# Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)

qloadm("tools/tpch/001.qs")

customer <- as_duckplyr_df(customer)
lineitem <- as_duckplyr_df(lineitem)
nation <- as_duckplyr_df(nation)
orders <- as_duckplyr_df(orders)
part <- as_duckplyr_df(part)
partsupp <- as_duckplyr_df(partsupp)
region <- as_duckplyr_df(region)
supplier <- as_duckplyr_df(supplier)

run <- identity
# run <- invisible

run(tpch_01())
run(tpch_02())
run(tpch_03())
run(tpch_04())
run(tpch_05())
run(tpch_06())
run(tpch_07())
run(tpch_08())
run(tpch_09())
run(tpch_10())
run(tpch_11())
run(tpch_12())
run(tpch_13())
run(tpch_14())
run(tpch_15())
run(tpch_16())
run(tpch_17())
run(tpch_18())
run(tpch_19())
run(tpch_20())
run(tpch_21())
run(tpch_22())
