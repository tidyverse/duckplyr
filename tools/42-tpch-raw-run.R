pkgload::load_all()

qloadm("tools/tpch/001.qs")

con <- get_default_duckdb_connection()
experimental <- FALSE

run <- identity
# run <- invisible

run(tpch_raw_01(con, experimental))
run(tpch_raw_02(con, experimental))
run(tpch_raw_03(con, experimental))
run(tpch_raw_04(con, experimental))
run(tpch_raw_05(con, experimental))
run(tpch_raw_06(con, experimental))
run(tpch_raw_07(con, experimental))
run(tpch_raw_08(con, experimental))
run(tpch_raw_09(con, experimental))
run(tpch_raw_10(con, experimental))
run(tpch_raw_11(con, experimental))
run(tpch_raw_12(con, experimental))
run(tpch_raw_13(con, experimental))
run(tpch_raw_14(con, experimental))
run(tpch_raw_15(con, experimental))
run(tpch_raw_16(con, experimental))
run(tpch_raw_17(con, experimental))
run(tpch_raw_18(con, experimental))
run(tpch_raw_19(con, experimental))
run(tpch_raw_20(con, experimental))
run(tpch_raw_21(con, experimental))
run(tpch_raw_22(con, experimental))
