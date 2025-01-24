test_that("tether duckplyr frames will collect", {
  tbl <- duckdb_tibble(a = 1, .tether = TRUE)
  expect_identical(
    collect(tbl),
    tibble(a = 1)
  )
})

test_that("untethered duckplyr frames are converted to data frames", {
  tbl <- duckdb_tibble(a = 1)
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("tether duckplyr frames are converted to data frames", {
  tbl <- duckdb_tibble(a = 1, .tether = TRUE)
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("untethered duckplyr frames are converted to tibbles", {
  tbl <- duckdb_tibble(a = 1)
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})

test_that("tether duckplyr frames are converted to tibbles", {
  tbl <- duckdb_tibble(a = 1, .tether = TRUE)
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})
