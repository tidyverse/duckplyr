pkgload::load_all()

load("tools/tpch/001.rda")

con <- get_default_duckdb_connection()
experimental <- FALSE

run <- identity
# run <- invisible

run(tpch_raw_01(experimental))
run(tpch_raw_02(experimental))
run(tpch_raw_03(experimental))
run(tpch_raw_04(experimental))
run(tpch_raw_05(experimental))
run(tpch_raw_06(experimental))
run(tpch_raw_07(experimental))
run(tpch_raw_08(experimental))
run(tpch_raw_09(experimental))
run(tpch_raw_10(experimental))
run(tpch_raw_11(experimental))
run(tpch_raw_12(experimental))
run(tpch_raw_13(experimental))
run(tpch_raw_14(experimental))
run(tpch_raw_15(experimental))
run(tpch_raw_16(experimental))
run(tpch_raw_17(experimental))
run(tpch_raw_18(experimental))
run(tpch_raw_19(experimental))
run(tpch_raw_20(experimental))
run(tpch_raw_21(experimental))
run(tpch_raw_22(experimental))
