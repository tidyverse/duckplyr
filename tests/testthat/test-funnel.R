test_that("funneled duckplyr frames will collect", {
  tbl <- duckdb_tibble(a = 1, .funnel = "closed")
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
  tbl <- duckdb_tibble(a = 1, .funnel = "closed")
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
  tbl <- duckdb_tibble(a = 1, .funnel = "closed")
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})

test_that("funneling after operation with failure", {
  df <- duckdb_tibble(x = 1:10, .funnel = c(rows = 5))
  out <- df %>%
    count(x)

  expect_identical(get_funnel_duckplyr_df(out), c(rows = 5))
  expect_error(nrow(out))
})

test_that("funneling after operation with success", {
  df <- duckdb_tibble(x = 1:10, .funnel = c(rows = 5))
  out <- df %>%
    count()

  expect_identical(get_funnel_duckplyr_df(out), c(rows = 5))
  expect_error(nrow(out), NA)
})
