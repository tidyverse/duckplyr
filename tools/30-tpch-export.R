pkgload::load_all()
con <- get_default_duckdb_connection()
DBI::dbExecute(con, "INSTALL tpch")
DBI::dbExecute(con, "LOAD tpch")

DBI::dbExecute(con, "call dbgen(sf=0.01)")
tables <- DBI::dbListTables(con)

fs::dir_create("tools/tpch/001")

for (table in tables) {
  arrow <- DBI::dbGetQuery(con, paste0("SELECT * FROM ", table), arrow = TRUE)
  arrow::write_parquet(arrow, fs::path("tools/tpch/001", paste0(table, ".parquet")))
  DBI::dbRemoveTable(con, table)
}

DBI::dbExecute(con, "call dbgen(sf=0.1)")
tables <- DBI::dbListTables(con)

fs::dir_create("tools/tpch/010")

for (table in tables) {
  arrow <- DBI::dbGetQuery(con, paste0("SELECT * FROM ", table), arrow = TRUE)
  arrow::write_parquet(arrow, fs::path("tools/tpch/010", paste0(table, ".parquet")))
  DBI::dbRemoveTable(con, table)
}

DBI::dbExecute(con, "call dbgen(sf=1)")
tables <- DBI::dbListTables(con)

fs::dir_create("tools/tpch/100")

for (table in tables) {
  arrow <- DBI::dbGetQuery(con, paste0("SELECT * FROM ", table), arrow = TRUE)
  arrow::write_parquet(arrow, fs::path("tools/tpch/100", paste0(table, ".parquet")))
  DBI::dbRemoveTable(con, table)
}
