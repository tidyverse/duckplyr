test_that("read_tbl_duckdb() reads table from database file", {
  db_path <- withr::local_tempfile(fileext = ".duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), db_path)
  DBI::dbWriteTable(
    con,
    "test_table",
    data.frame(a = 1:3, b = c("x", "y", "z"))
  )

  # Force write
  DBI::dbDisconnect(con)

  out <- read_tbl_duckdb(db_path, "test_table", prudence = "lavish")

  expect_equal(
    collect(out),
    tibble::tibble(a = 1:3L, b = c("x", "y", "z"))
  )
})

test_that("read_tbl_duckdb() works with dplyr operations", {
  db_path <- withr::local_tempfile(fileext = ".duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), db_path)
  DBI::dbWriteTable(con, "test_table", data.frame(a = 1:10, b = letters[1:10]))
  DBI::dbDisconnect(con)

  out <- read_tbl_duckdb(db_path, "test_table", prudence = "lavish") %>%
    filter(a > 5) %>%
    select(b, a) %>%
    mutate(c = a * 2)

  expect_equal(
    collect(out),
    tibble::tibble(
      b = c("f", "g", "h", "i", "j"),
      a = 6:10L,
      c = c(12, 14, 16, 18, 20)
    )
  )
})

test_that("read_tbl_duckdb() can read multiple tables from same database", {
  db_path <- withr::local_tempfile(fileext = ".duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), db_path)
  DBI::dbWriteTable(con, "table1", data.frame(x = 1:3))
  DBI::dbWriteTable(con, "table2", data.frame(y = 4:6))
  DBI::dbDisconnect(con)

  out1 <- read_tbl_duckdb(db_path, "table1", prudence = "lavish")
  out2 <- read_tbl_duckdb(db_path, "table2", prudence = "lavish")

  expect_equal(collect(out1), tibble::tibble(x = 1:3L))
  expect_equal(collect(out2), tibble::tibble(y = 4:6L))
})

test_that("read_tbl_duckdb() validates inputs", {
  expect_error(
    read_tbl_duckdb(123, "table"),
    "must be a string"
  )
  expect_error(
    read_tbl_duckdb("path.duckdb", 456),
    "must be a string"
  )
  expect_error(
    read_tbl_duckdb("path.duckdb", "table", schema = 789),
    "must be a string"
  )
})

test_that("read_tbl_duckdb() errors on non-existent file", {
  expect_error(
    read_tbl_duckdb("/nonexistent/path.duckdb", "table"),
    class = "simpleError"
  )
})

test_that("read_tbl_duckdb() errors on non-existent table", {
  db_path <- withr::local_tempfile(fileext = ".duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), db_path)
  DBI::dbWriteTable(con, "existing_table", data.frame(a = 1))
  DBI::dbDisconnect(con)

  expect_error(
    read_tbl_duckdb(db_path, "nonexistent_table"),
    "does not exist"
  )
})
