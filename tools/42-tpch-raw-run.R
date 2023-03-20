pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)

load("tools/tpch/001.rda")

con <- get_default_duckdb_connection()

run <- identity
# run <- invisible

run(tpch_raw_01())
run(tpch_raw_02())
run(tpch_raw_03())
run(tpch_raw_04())
run(tpch_raw_05())
run(tpch_raw_06())
run(tpch_raw_07())
run(tpch_raw_08())
run(tpch_raw_09())
run(tpch_raw_10())
run(tpch_raw_11())
run(tpch_raw_12())
run(tpch_raw_13())
run(tpch_raw_14())
run(tpch_raw_15())
run(tpch_raw_16())
run(tpch_raw_17())
run(tpch_raw_18())
run(tpch_raw_19())
run(tpch_raw_20())
run(tpch_raw_21())
run(tpch_raw_22())
