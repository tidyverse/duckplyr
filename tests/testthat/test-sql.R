test_that("ducksql() works", {
  con <- withr::local_db_connection(DBI::dbConnect(duckdb::duckdb()))

  expect_identical(
    ducksql("SELECT 1 AS a", con = con, lazy = FALSE),
    ducktbl(a = 1L)
  )
})
