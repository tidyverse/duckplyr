test_that("duck_sql() works", {
  con <- withr::local_db_connection(DBI::dbConnect(duckdb::duckdb()))

  expect_identical(
    duck_sql("SELECT 1 AS a", con = con, lazy = FALSE),
    duckdb_tibble(a = 1L)
  )
})
