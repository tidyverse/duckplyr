pkgload::load_all()
library(tictoc)

load("tools/tpch/500.rda")

con <- get_default_duckdb_connection()
experimental <- FALSE

run <- identity
# run <- invisible

res <- list()
pkg <- "raw-relational-force-parallelism"

q =1 
tic()
tpch_raw_01(con, experimental)
tmp = toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 2
tic()
tpch_raw_02(con, experimental)
tmp = toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 3
tic()
tpch_raw_03(con, experimental)
tmp = toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 4
tic()
tpch_raw_04(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 5
tic()
tpch_raw_05(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 6
tic()
tpch_raw_06(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 7
tic()
tpch_raw_07(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 8
tic()
tpch_raw_08(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 9
tic()
tpch_raw_09(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 10
tic()
tpch_raw_10(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 11
tic()
tpch_raw_11(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 12
tic()
tpch_raw_12(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 13
tic()
tpch_raw_13(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 14
tic()
tpch_raw_14(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 15
tic()
tpch_raw_15(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 16
tic()
tpch_raw_16(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 17
tic()
tpch_raw_17(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 18
tic()
tpch_raw_18(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 19
tic()
tpch_raw_19(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 20
tic()
tpch_raw_20(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 21
tic()
tpch_raw_21(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

q = 22
tic()
tpch_raw_22(con, experimental)
tmp <- toc()
time = tmp$toc - tmp$tic
res[[q]] <- data.frame(pkg = pkg, q=q, time = time)

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))