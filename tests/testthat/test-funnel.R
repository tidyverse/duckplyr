test_that("inert duckplyr frames will collect", {
  tbl <- duckdb_tibble(a = 1, .inert = "closed")
  expect_identical(
    collect(tbl),
    tibble(a = 1)
  )
})

test_that("non_inert duckplyr frames are converted to data frames", {
  tbl <- duckdb_tibble(a = 1)
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("inert duckplyr frames are converted to data frames", {
  tbl <- duckdb_tibble(a = 1, .inert = "closed")
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("non_inert duckplyr frames are converted to tibbles", {
  tbl <- duckdb_tibble(a = 1)
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})

test_that("inert duckplyr frames are converted to tibbles", {
  tbl <- duckdb_tibble(a = 1, .inert = "closed")
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})

test_that("inerting after operation with failure", {
  df <- duckdb_tibble(x = 1:10, .inert = c(rows = 5))
  out <- df %>%
    count(x)

  expect_identical(get_inert_duckplyr_df(out), c(rows = 5))
  expect_error(nrow(out))
})

test_that("inerting after operation with success", {
  df <- duckdb_tibble(x = 1:10, .inert = c(rows = 5))
  out <- df %>%
    count()

  expect_identical(get_inert_duckplyr_df(out), c(rows = 5))
  expect_error(nrow(out), NA)
})
