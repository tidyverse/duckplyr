pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)

load("tools/tpch/001.rda")
answer <- "tpch-sf0.01"

# load("tools/tpch/100.rda")
# answer <- "tpch-sf1"

customer <- as_duckplyr_df(customer)
lineitem <- as_duckplyr_df(lineitem)
nation <- as_duckplyr_df(nation)
orders <- as_duckplyr_df(orders)
part <- as_duckplyr_df(part)
partsupp <- as_duckplyr_df(partsupp)
region <- as_duckplyr_df(region)
supplier <- as_duckplyr_df(supplier)

res <- tpch_01()
correct <- read.delim(fs::path("tests/testthat", answer, "q01.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_02()
correct <- read.delim(fs::path("tests/testthat", answer, "q02.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_03()
correct <- read.delim(fs::path("tests/testthat", answer, "q03.csv"), sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_04()
correct <- read.delim(fs::path("tests/testthat", answer, "q04.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_05()
correct <- read.delim(fs::path("tests/testthat", answer, "q05.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_06()
correct <- read.delim(fs::path("tests/testthat", answer, "q06.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_07()
correct <- read.delim(fs::path("tests/testthat", answer, "q07.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_08()
correct <- read.delim(fs::path("tests/testthat", answer, "q08.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_09()
correct <- read.delim(fs::path("tests/testthat", answer, "q09.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_10()
correct <- read.delim(fs::path("tests/testthat", answer, "q10.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_11()
correct <- read.delim(fs::path("tests/testthat", answer, "q11.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_12()
correct <- read.delim(fs::path("tests/testthat", answer, "q12.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_13()
correct <- read.delim(fs::path("tests/testthat", answer, "q13.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_14()
correct <- read.delim(fs::path("tests/testthat", answer, "q14.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_15()
correct <- read.delim(fs::path("tests/testthat", answer, "q15.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_16()
correct <- read.delim(fs::path("tests/testthat", answer, "q16.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_17()
correct <- read.delim(fs::path("tests/testthat", answer, "q17.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_18()
correct <- read.delim(fs::path("tests/testthat", answer, "q18.csv"), sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_19()
correct <- read.delim(fs::path("tests/testthat", answer, "q19.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_20()
correct <- read.delim(fs::path("tests/testthat", answer, "q20.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_21()
correct <- read.delim(fs::path("tests/testthat", answer, "q21.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))

res <- tpch_22()
correct <- read.delim(fs::path("tests/testthat", answer, "q22.csv"), sep = "|")
correct$cntrycode <- as.character(correct$cntrycode)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 1e-12)))
