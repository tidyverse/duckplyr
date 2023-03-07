pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)

load("tools/tpch/001.rda")

customer <- as_duckplyr_df(customer)
lineitem <- as_duckplyr_df(lineitem)
nation <- as_duckplyr_df(nation)
orders <- as_duckplyr_df(orders)
part <- as_duckplyr_df(part)
partsupp <- as_duckplyr_df(partsupp)
region <- as_duckplyr_df(region)
supplier <- as_duckplyr_df(supplier)

res <- tpch_01()
correct <- read.delim("tests/testthat/tpch-sf0.01/q01.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_02()
correct <- read.delim("tests/testthat/tpch-sf0.01/q02.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_03()
correct <- read.delim("tests/testthat/tpch-sf0.01/q03.csv", sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_04()
correct <- read.delim("tests/testthat/tpch-sf0.01/q04.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_05()
correct <- read.delim("tests/testthat/tpch-sf0.01/q05.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_06()
correct <- read.delim("tests/testthat/tpch-sf0.01/q06.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_07()
correct <- read.delim("tests/testthat/tpch-sf0.01/q07.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_08()
correct <- read.delim("tests/testthat/tpch-sf0.01/q08.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_09()
correct <- read.delim("tests/testthat/tpch-sf0.01/q09.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_10()
correct <- read.delim("tests/testthat/tpch-sf0.01/q10.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_11()
correct <- read.delim("tests/testthat/tpch-sf0.01/q11.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_12()
correct <- read.delim("tests/testthat/tpch-sf0.01/q12.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_13()
correct <- read.delim("tests/testthat/tpch-sf0.01/q13.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_14()
correct <- read.delim("tests/testthat/tpch-sf0.01/q14.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_15()
correct <- read.delim("tests/testthat/tpch-sf0.01/q15.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_16()
correct <- read.delim("tests/testthat/tpch-sf0.01/q16.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_17()
correct <- read.delim("tests/testthat/tpch-sf0.01/q17.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_18()
correct <- read.delim("tests/testthat/tpch-sf0.01/q18.csv", sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_19()
correct <- read.delim("tests/testthat/tpch-sf0.01/q19.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_20()
correct <- read.delim("tests/testthat/tpch-sf0.01/q20.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_21()
correct <- read.delim("tests/testthat/tpch-sf0.01/q21.csv", sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_22()
correct <- read.delim("tests/testthat/tpch-sf0.01/q22.csv", sep = "|")
correct$cntrycode <- as.character(correct$cntrycode)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))
