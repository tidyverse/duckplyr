pkgload::load_all()

qloadm("tools/tpch/001.qs")

con <- get_default_duckdb_connection()
experimental <- FALSE

run <- identity
# run <- invisible

run(tpch_raw_oo_01(con, experimental))
run(tpch_raw_oo_02(con, experimental))
run(tpch_raw_oo_03(con, experimental))
run(tpch_raw_oo_04(con, experimental))
run(tpch_raw_oo_05(con, experimental))
run(tpch_raw_oo_06(con, experimental))
run(tpch_raw_oo_07(con, experimental))
run(tpch_raw_oo_08(con, experimental))
run(tpch_raw_oo_09(con, experimental))
run(tpch_raw_oo_10(con, experimental))
run(tpch_raw_oo_11(con, experimental))
run(tpch_raw_oo_12(con, experimental))
run(tpch_raw_oo_13(con, experimental))
run(tpch_raw_oo_14(con, experimental))
run(tpch_raw_oo_15(con, experimental))
run(tpch_raw_oo_16(con, experimental))
run(tpch_raw_oo_17(con, experimental))
run(tpch_raw_oo_18(con, experimental))
run(tpch_raw_oo_19(con, experimental))
run(tpch_raw_oo_20(con, experimental))
run(tpch_raw_oo_21(con, experimental))
run(tpch_raw_oo_22(con, experimental))
