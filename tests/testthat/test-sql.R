test_that("read_sql_duckdb() works", {
  con <- withr::local_db_connection(DBI::dbConnect(duckdb::duckdb()))

  expect_identical(
    read_sql_duckdb("SELECT 1 AS a", con = con, inert = "open"),
    duckdb_tibble(a = 1L)
  )
})
