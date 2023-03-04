pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = 1)

load("tools/tpch/001.rda")

res <- tpch_01()
correct <- read.delim("tests/testthat/tpch-sf0.01/q01.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_02()
correct <- read.delim("tests/testthat/tpch-sf0.01/q02.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_03()
correct <- read.delim("tests/testthat/tpch-sf0.01/q03.csv", sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_04()
correct <- read.delim("tests/testthat/tpch-sf0.01/q04.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_05()
correct <- read.delim("tests/testthat/tpch-sf0.01/q05.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_06()
correct <- read.delim("tests/testthat/tpch-sf0.01/q06.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_07()
correct <- read.delim("tests/testthat/tpch-sf0.01/q07.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_08()
correct <- read.delim("tests/testthat/tpch-sf0.01/q08.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_09()
correct <- read.delim("tests/testthat/tpch-sf0.01/q09.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

res <- tpch_10()
correct <- read.delim("tests/testthat/tpch-sf0.01/q10.csv", sep = "|")
waldo::compare(res, correct, tolerance = 1e-12)

