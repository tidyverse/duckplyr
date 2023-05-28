pkgload::load_all()

qloadm("tools/tpch/001.qs")
answer <- "tpch-sf0.01"

# load("tools/tpch/100.qs")
# answer <- "tpch-sf1"

con <- get_default_duckdb_connection()
experimental <- FALSE

res <- tpch_raw_oo_01(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q01.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_02(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q02.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_03(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q03.csv"), sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_04(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q04.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_05(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q05.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_06(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q06.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_07(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q07.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_08(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q08.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_09(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q09.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_10(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q10.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_11(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q11.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_12(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q12.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_13(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q13.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_14(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q14.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_15(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q15.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_16(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q16.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_17(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q17.csv"), sep = "|")
correct$avg_yearly <- as.numeric(correct$avg_yearly)
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_18(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q18.csv"), sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_19(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q19.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_20(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q20.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_21(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q21.csv"), sep = "|")
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))

res <- tpch_raw_oo_22(con, experimental)
correct <- read.delim(fs::path("tests/testthat", answer, "q22.csv"), sep = "|")
correct$cntrycode <- as.character(correct$cntrycode)
stopifnot(isTRUE(all.equal(res, correct, tolerance = 1e-12)))
