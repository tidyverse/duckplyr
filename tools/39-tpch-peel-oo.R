withr::local_envvar(DUCKPLYR_META_ENABLE = TRUE)
pkgload::load_all()

withr::local_envvar(DUCKPLYR_FORCE = TRUE)
# Don't care
# withr::local_envvar(DUCKPLYR_EXPERIMENTAL = FALSE)
withr::local_envvar(DUCKPLYR_META_GLOBAL = TRUE)
withr::local_envvar(DUCKPLYR_OUTPUT_ORDER = TRUE)

qloadm("tools/tpch/001.qs")

methods_overwrite()
withr::defer(methods_restore())

invisible(tpch_01())
meta_replay_to_file("tools/tpch-raw-oo/01.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_01", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_02())
meta_replay_to_file("tools/tpch-raw-oo/02.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_02", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_03())
meta_replay_to_file("tools/tpch-raw-oo/03.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_03", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_04())
meta_replay_to_file("tools/tpch-raw-oo/04.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_04", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_05())
meta_replay_to_file("tools/tpch-raw-oo/05.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_05", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_06())
meta_replay_to_file("tools/tpch-raw-oo/06.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_06", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_07())
meta_replay_to_file("tools/tpch-raw-oo/07.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_07", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_08())
meta_replay_to_file("tools/tpch-raw-oo/08.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_08", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_09())
meta_replay_to_file("tools/tpch-raw-oo/09.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_09", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_10())
meta_replay_to_file("tools/tpch-raw-oo/10.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_10", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_11())
meta_replay_to_file("tools/tpch-raw-oo/11.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_11", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_12())
meta_replay_to_file("tools/tpch-raw-oo/12.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_12", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_13())
meta_replay_to_file("tools/tpch-raw-oo/13.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_13", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_14())
meta_replay_to_file("tools/tpch-raw-oo/14.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_14", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_15())
meta_replay_to_file("tools/tpch-raw-oo/15.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_15", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_16())
meta_replay_to_file("tools/tpch-raw-oo/16.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_16", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_17())
meta_replay_to_file("tools/tpch-raw-oo/17.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_17", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_18())
meta_replay_to_file("tools/tpch-raw-oo/18.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_18", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_19())
meta_replay_to_file("tools/tpch-raw-oo/19.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_19", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_20())
meta_replay_to_file("tools/tpch-raw-oo/20.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_20", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_21())
meta_replay_to_file("tools/tpch-raw-oo/21.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_21", "# nocov start\n", "# nocov end\n")
meta_clear()

invisible(tpch_22())
meta_replay_to_file("tools/tpch-raw-oo/22.R", 'qloadm("tools/tpch/001.qs")')
meta_replay_to_fun_file("tpch_raw_oo_22", "# nocov start\n", "# nocov end\n")
meta_clear()
