test_that("Can construct", {
  expect_identical(
    duck_tbl(a = 1),
    as_duck_tbl(tibble::tibble(a = 1))
  )

  expect_identical(duck_tbl(a = 1)$a, 1)
})

test_that(".lazy = TRUE forbids materialization", {
  tbl <- duck_tbl(a = 1, .lazy = TRUE)
  expect_error(length(tbl$a))
})

test_that(".lazy = TRUE forbids materialization for as_duck_tbl()", {
  tbl <- as_duck_tbl(data.frame(a = 1), .lazy = TRUE)
  expect_error(length(tbl$a))
})

test_that("as_duck_tbl() and grouped df", {
  expect_snapshot(error = TRUE, {
    as_duck_tbl(dplyr::group_by(mtcars, cyl))
  })
})

test_that("as_duck_tbl() and rowwise df", {
  expect_snapshot(error = TRUE, {
    as_duck_tbl(dplyr::rowwise(mtcars))
  })
})

test_that("as_duck_tbl() and dbplyr tables", {
  skip_if_not_installed("dbplyr")
  con <- withr::local_db_connection(DBI::dbConnect(duckdb::duckdb()))

  db_tbl <-
    data.frame(a = 1) %>%
    dplyr::copy_to(dest = con)

  duck <- db_tbl %>%
    as_duck_tbl(.lazy = TRUE) %>%
    mutate(b = 2) %>%
    collect()

  db <- db_tbl %>%
    mutate(b = 2) %>%
    as_duck_tbl() %>%
    collect()

  expect_identical(duck, db)
})

test_that("is_duck_tbl()", {
  expect_true(is_duck_tbl(duck_tbl(a = 1)))
  expect_false(is_duck_tbl(tibble::tibble(a = 1)))
  expect_false(is_duck_tbl(data.frame(a = 1)))
})
