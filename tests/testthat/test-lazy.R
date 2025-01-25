test_that("funneled duckplyr frames will collect", {
  tbl <- duckdb_tibble(a = 1, .funnel = TRUE)
  expect_identical(
    collect(tbl),
    tibble(a = 1)
  )
})

test_that("unfunneled duckplyr frames are converted to data frames", {
  tbl <- duckdb_tibble(a = 1)
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("funneled duckplyr frames are converted to data frames", {
  tbl <- duckdb_tibble(a = 1, .funnel = TRUE)
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("unfunneled duckplyr frames are converted to tibbles", {
  tbl <- duckdb_tibble(a = 1)
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})

test_that("funneled duckplyr frames are converted to tibbles", {
  tbl <- duckdb_tibble(a = 1, .funnel = TRUE)
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})
