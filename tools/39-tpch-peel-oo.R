pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)
# Don't care
# Sys.setenv(DUCKPLYR_EXPERIMENTAL = FALSE)
Sys.setenv(DUCKPLYR_META_GLOBAL = TRUE)
Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)

qloadm("tools/tpch/001.qs")

customer <- as_duckplyr_df(customer)
lineitem <- as_duckplyr_df(lineitem)
nation <- as_duckplyr_df(nation)
orders <- as_duckplyr_df(orders)
part <- as_duckplyr_df(part)
partsupp <- as_duckplyr_df(partsupp)
region <- as_duckplyr_df(region)
supplier <- as_duckplyr_df(supplier)

invisible(tpch_01())
meta_replay_to_file("tools/tpch-raw-oo/01.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_01")
meta_clear()

invisible(tpch_02())
meta_replay_to_file("tools/tpch-raw-oo/02.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_02")
meta_clear()

invisible(tpch_03())
meta_replay_to_file("tools/tpch-raw-oo/03.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_03")
meta_clear()

invisible(tpch_04())
meta_replay_to_file("tools/tpch-raw-oo/04.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_04")
meta_clear()

invisible(tpch_05())
meta_replay_to_file("tools/tpch-raw-oo/05.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_05")
meta_clear()

invisible(tpch_06())
meta_replay_to_file("tools/tpch-raw-oo/06.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_06")
meta_clear()

invisible(tpch_07())
meta_replay_to_file("tools/tpch-raw-oo/07.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_07")
meta_clear()

invisible(tpch_08())
meta_replay_to_file("tools/tpch-raw-oo/08.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_08")
meta_clear()

invisible(tpch_09())
meta_replay_to_file("tools/tpch-raw-oo/09.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_09")
meta_clear()

invisible(tpch_10())
meta_replay_to_file("tools/tpch-raw-oo/10.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_10")
meta_clear()

invisible(tpch_11())
meta_replay_to_file("tools/tpch-raw-oo/11.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_11")
meta_clear()

invisible(tpch_12())
meta_replay_to_file("tools/tpch-raw-oo/12.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_12")
meta_clear()

invisible(tpch_13())
meta_replay_to_file("tools/tpch-raw-oo/13.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_13")
meta_clear()

invisible(tpch_14())
meta_replay_to_file("tools/tpch-raw-oo/14.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_14")
meta_clear()

invisible(tpch_15())
meta_replay_to_file("tools/tpch-raw-oo/15.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_15")
meta_clear()

invisible(tpch_16())
meta_replay_to_file("tools/tpch-raw-oo/16.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_16")
meta_clear()

invisible(tpch_17())
meta_replay_to_file("tools/tpch-raw-oo/17.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_17")
meta_clear()

invisible(tpch_18())
meta_replay_to_file("tools/tpch-raw-oo/18.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_18")
meta_clear()

invisible(tpch_19())
meta_replay_to_file("tools/tpch-raw-oo/19.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_19")
meta_clear()

invisible(tpch_20())
meta_replay_to_file("tools/tpch-raw-oo/20.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_20")
meta_clear()

invisible(tpch_21())
meta_replay_to_file("tools/tpch-raw-oo/21.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_21")
meta_clear()

invisible(tpch_22())
meta_replay_to_file("tools/tpch-raw-oo/22.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_22")
meta_clear()
