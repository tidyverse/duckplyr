DBI::dbExecute(duckdb:::default_connection(), "INSTALL tpch")

generate_tpch <- function(sf, target_dir) {
  fs::dir_create(target_dir)
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  DBI::dbExecute(con, "LOAD tpch")
  DBI::dbExecute(con, paste0("CALL dbgen(sf=", DBI::dbQuoteLiteral(con, sf), ")"))
  for (table in DBI::dbListTables(con)) {
      DBI::dbExecute(con, sprintf("COPY (FROM %s) TO '%s/%s.parquet'", table, target_dir, table))
  }
  DBI::dbDisconnect(con, shutdown=TRUE)
}

generate_tpch(0.01, 'tools/tpch/001')
generate_tpch(0.1, 'tools/tpch/010')
generate_tpch(1, 'tools/tpch/100')

