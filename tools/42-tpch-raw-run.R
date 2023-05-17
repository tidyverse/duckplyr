pkgload::load_all()

load("tools/tpch/100.rda")

con <- get_default_duckdb_connection()
experimental <- FALSE

run <- identity
# run <- invisible

res <- list()
pkg <- "relational-duckdb"

q =1 
tpch_raw_01(con, experimental)
start = Sys.time()
tpch_raw_01(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_01"]] <- data.frame(pkg = pkg, q="tpch_01", time = time)

q = 2
tpch_raw_02(con, experimental)
start = Sys.time()
tpch_raw_02(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_02"]] <- data.frame(pkg = pkg, q="tpch_02", time = time)

q = 3
tpch_raw_03(con, experimental)
start = Sys.time()
tpch_raw_03(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_03"]] <- data.frame(pkg = pkg, q="tpch_03", time = time)

q = 4
tpch_raw_04(con, experimental)
start = Sys.time()
tpch_raw_04(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_04"]] <- data.frame(pkg = pkg, q="tpch_04", time = time)

q = 5
tpch_raw_05(con, experimental)
start = Sys.time()
tpch_raw_05(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_05"]] <- data.frame(pkg = pkg, q="tpch_05", time = time)

q = 6
tpch_raw_06(con, experimental)
start = Sys.time()
tpch_raw_06(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_06"]] <- data.frame(pkg = pkg, q="tpch_06", time = time)

q = 7
tpch_raw_07(con, experimental)
start = Sys.time()
tpch_raw_07(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_07"]] <- data.frame(pkg = pkg, q="tpch_07", time = time)

q = 8
tpch_raw_08(con, experimental)
start = Sys.time()
tpch_raw_08(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_08"]] <- data.frame(pkg = pkg, q="tpch_08", time = time)

q = 9
tpch_raw_09(con, experimental)
start = Sys.time()
tpch_raw_09(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_09"]] <- data.frame(pkg = pkg, q="tpch_09", time = time)

q = 10
tpch_raw_10(con, experimental)
start = Sys.time()
tpch_raw_10(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_10"]] <- data.frame(pkg = pkg, q="tpch_10", time = time)

q = 11
tpch_raw_11(con, experimental)
start = Sys.time()
tpch_raw_11(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_11"]] <- data.frame(pkg = pkg, q="tpch_11", time = time)

q = 12
tpch_raw_12(con, experimental)
start = Sys.time()
tpch_raw_12(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_12"]] <- data.frame(pkg = pkg, q="tpch_12", time = time)

q = 13
tpch_raw_13(con, experimental)
start = Sys.time()
tpch_raw_13(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_13"]] <- data.frame(pkg = pkg, q="tpch_13", time = time)

q = 14
tpch_raw_14(con, experimental)
start = Sys.time()
tpch_raw_14(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_14"]] <- data.frame(pkg = pkg, q="tpch_14", time = time)

q = 15
tpch_raw_15(con, experimental)
start = Sys.time()
tpch_raw_15(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_15"]] <- data.frame(pkg = pkg, q="tpch_15", time = time)

q = 16
tpch_raw_16(con, experimental)
start = Sys.time()
tpch_raw_16(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_16"]] <- data.frame(pkg = pkg, q="tpch_16", time = time)

q = 17
tpch_raw_17(con, experimental)
start = Sys.time()
tpch_raw_17(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_17"]] <- data.frame(pkg = pkg, q="tpch_17", time = time)

q = 18
tpch_raw_18(con, experimental)
start = Sys.time()
tpch_raw_18(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_18"]] <- data.frame(pkg = pkg, q="tpch_18", time = time)

q = 19
tpch_raw_19(con, experimental)
start = Sys.time()
tpch_raw_19(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_19"]] <- data.frame(pkg = pkg, q="tpch_19", time = time)

q = 20
tpch_raw_20(con, experimental)
start = Sys.time()
tpch_raw_20(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_20"]] <- data.frame(pkg = pkg, q="tpch_20", time = time)

q = 21
tpch_raw_21(con, experimental)
start = Sys.time()
tpch_raw_21(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_21"]] <- data.frame(pkg = pkg, q="tpch_21", time = time)

q = 22
tpch_raw_22(con, experimental)
start = Sys.time()
tpch_raw_22(con, experimental)
end = Sys.time()
time = end - start
res[["tpch_22"]] <- data.frame(pkg = pkg, q="tpch_22", time = time)

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))