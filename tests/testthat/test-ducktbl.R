test_that("Can construct", {
  expect_identical(
    ducktbl(a = 1),
    as_ducktbl(tibble::tibble(a = 1))
  )

  expect_identical(ducktbl(a = 1)$a, 1)
})

test_that(".lazy = TRUE forbids materialization", {
  tbl <- ducktbl(a = 1, .lazy = TRUE)
  expect_error(length(tbl$a))
})

test_that(".lazy = TRUE forbids materialization for as_ducktbl()", {
  tbl <- as_ducktbl(data.frame(a = 1), .lazy = TRUE)
  expect_error(length(tbl$a))
})

test_that("as_ducktbl() and grouped df", {
  expect_snapshot(error = TRUE, {
    as_ducktbl(dplyr::group_by(mtcars, cyl))
  })
})

test_that("as_ducktbl() and rowwise df", {
  expect_snapshot(error = TRUE, {
    as_ducktbl(dplyr::rowwise(mtcars))
  })
})

test_that("as_ducktbl() and dbplyr tables", {
  skip_if_not_installed("dbplyr")
  con <- withr::local_db_connection(DBI::dbConnect(duckdb::duckdb()))

  db_tbl <-
    data.frame(a = 1) %>%
    dplyr::copy_to(dest = con)

  duck <- db_tbl %>%
    as_ducktbl(.lazy = TRUE) %>%
    mutate(b = 2) %>%
    collect()

  db <- db_tbl %>%
    mutate(b = 2) %>%
    as_ducktbl() %>%
    collect()

  expect_identical(duck, db)
})

test_that("is_ducktbl()", {
  expect_true(is_ducktbl(ducktbl(a = 1)))
  expect_false(is_ducktbl(tibble::tibble(a = 1)))
  expect_false(is_ducktbl(data.frame(a = 1)))
})
