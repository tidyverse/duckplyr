pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)
Sys.setenv(DUCKPLYR_EXPERIMENTAL = FALSE)
Sys.setenv(DUCKPLYR_META_GLOBAL = TRUE)

# Sys.setenv(DUCKPLYR_FALLBACK_FORCE = TRUE)

# Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)

qloadm("tools/tpch/001.qs")
answer <- "tpch-sf0.01"

# qloadm("tools/tpch/100.qs")
# answer <- "tpch-sf1"

customer <- as_ducktbl(customer)
lineitem <- as_ducktbl(lineitem)
nation <- as_ducktbl(nation)
orders <- as_ducktbl(orders)
part <- as_ducktbl(part)
partsupp <- as_ducktbl(partsupp)
region <- as_ducktbl(region)
supplier <- as_ducktbl(supplier)

run <- identity
# run <- collect

res <- run(tpch_01())
correct <- read.delim(fs::path("tests/testthat", answer, "q01.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_02())
correct <- read.delim(fs::path("tests/testthat", answer, "q02.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))
# write.table(as.data.frame(res), fs::path("tests/testthat", answer, "q02.csv"), sep = "|", quote = FALSE, row.names = FALSE)

res <- run(tpch_03())
correct <- read.delim(fs::path("tests/testthat", answer, "q03.csv"), sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_04())
correct <- read.delim(fs::path("tests/testthat", answer, "q04.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_05())
correct <- read.delim(fs::path("tests/testthat", answer, "q05.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_06())
correct <- read.delim(fs::path("tests/testthat", answer, "q06.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_07())
correct <- read.delim(fs::path("tests/testthat", answer, "q07.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_08())
correct <- read.delim(fs::path("tests/testthat", answer, "q08.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_09())
correct <- read.delim(fs::path("tests/testthat", answer, "q09.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_10())
correct <- read.delim(fs::path("tests/testthat", answer, "q10.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))
# write.table(as.data.frame(res), fs::path("tests/testthat", answer, "q10.csv"), sep = "|", quote = FALSE, row.names = FALSE)

res <- run(tpch_11())
correct <- read.delim(fs::path("tests/testthat", answer, "q11.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_12())
correct <- read.delim(fs::path("tests/testthat", answer, "q12.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_13())
correct <- read.delim(fs::path("tests/testthat", answer, "q13.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))
# write.table(as.data.frame(res), fs::path("tests/testthat", answer, "q13.csv"), sep = "|", quote = FALSE, row.names = FALSE)

res <- run(tpch_14())
correct <- read.delim(fs::path("tests/testthat", answer, "q14.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_15())
correct <- read.delim(fs::path("tests/testthat", answer, "q15.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_16())
correct <- read.delim(fs::path("tests/testthat", answer, "q16.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_17())
correct <- read.delim(fs::path("tests/testthat", answer, "q17.csv"), sep = "|")
correct$avg_yearly <- as.numeric(correct$avg_yearly)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_18())
correct <- read.delim(fs::path("tests/testthat", answer, "q18.csv"), sep = "|")
correct$o_orderdate <- as.Date(correct$o_orderdate)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_19())
correct <- read.delim(fs::path("tests/testthat", answer, "q19.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_20())
correct <- read.delim(fs::path("tests/testthat", answer, "q20.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_21())
correct <- read.delim(fs::path("tests/testthat", answer, "q21.csv"), sep = "|")
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))

res <- run(tpch_22())
correct <- read.delim(fs::path("tests/testthat", answer, "q22.csv"), sep = "|")
correct$cntrycode <- as.character(correct$cntrycode)
stopifnot(isTRUE(all.equal(as.data.frame(res), correct, tolerance = 4e-12)))
