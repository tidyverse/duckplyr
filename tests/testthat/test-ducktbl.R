test_that("Can construct", {
  expect_identical(
    duckdb_tibble(a = 1),
    as_duckdb_tibble(tibble::tibble(a = 1))
  )

  expect_identical(duckdb_tibble(a = 1)$a, 1)
})

test_that('.prudence = "frugal" forbids materialization', {
  tbl <- duckdb_tibble(a = 1, .prudence = "frugal")
  expect_error(length(tbl$a))
})

test_that('.prudence = c(rows = ) forbids materialization', {
  tbl <- duckdb_tibble(a = 1:10, .prudence = c(rows = 5))
  expect_error(length(tbl$a))
})

test_that('.prudence = c(cells = ) forbids materialization', {
  tbl <- duckdb_tibble(a = 1:10, b = 1, .prudence = c(cells = 10))
  expect_error(length(tbl$a))
})

test_that('.prudence = "frugal" forbids materialization for as_duckdb_tibble', {
  tbl <- as_duckdb_tibble(data.frame(a = 1), prudence = "frugal")
  expect_error(length(tbl$a))
})

test_that("as_duckdb_tibble() and grouped df", {
  expect_snapshot(error = TRUE, {
    as_duckdb_tibble(dplyr::group_by(mtcars, cyl))
  })
})

test_that("as_duckdb_tibble() and rowwise df", {
  expect_snapshot(error = TRUE, {
    as_duckdb_tibble(dplyr::rowwise(mtcars))
  })
})

test_that("as_duckdb_tibble() and readr data", {
  skip_if_not_installed("readr")

  path <- withr::local_tempfile(fileext = ".csv")
  readr::write_csv(data.frame(a = 1), path)

  expect_snapshot(error = TRUE, {
    as_duckdb_tibble(readr::read_csv(path, show_col_types = FALSE))
  })

  expect_equal(
    as_duckdb_tibble(as_tibble(readr::read_csv(path, show_col_types = FALSE))),
    duckdb_tibble(a = 1)
  )
})

test_that("as_duckdb_tibble() and dbplyr tables", {
  skip_if_not_installed("dbplyr")
  con <- withr::local_db_connection(DBI::dbConnect(duckdb::duckdb()))

  db_tbl <-
    data.frame(a = 1) %>%
    dplyr::copy_to(dest = con)

  duck <- db_tbl %>%
    as_duckdb_tibble(prudence = "frugal") %>%
    mutate(b = 2)

  expect_error(length(duck$b))

  db <- db_tbl %>%
    mutate(b = 2) %>%
    as_duckdb_tibble(prudence = "frugal")

  expect_error(length(db$b))

  expect_identical(collect(duck), collect(db))
})

test_that("is_duckdb_tibble()", {
  expect_true(is_duckdb_tibble(duckdb_tibble(a = 1)))
  expect_false(is_duckdb_tibble(tibble::tibble(a = 1)))
  expect_false(is_duckdb_tibble(data.frame(a = 1)))
})
