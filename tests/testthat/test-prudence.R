test_that("stingy duckplyr frames will collect", {
  tbl <- duckdb_tibble(a = 1, .prudence = "stingy")
  expect_identical(
    collect(tbl),
    tibble(a = 1)
  )
})

test_that("lavish duckplyr frames are converted to data frames", {
  tbl <- duckdb_tibble(a = 1)
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("stingy duckplyr frames are converted to data frames", {
  tbl <- duckdb_tibble(a = 1, .prudence = "stingy")
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("lavish duckplyr frames are converted to tibbles", {
  tbl <- duckdb_tibble(a = 1)
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})

test_that("stingy duckplyr frames are converted to tibbles", {
  tbl <- duckdb_tibble(a = 1, .prudence = "stingy")
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})

test_that("prudence after operation with failure", {
  df <- duckdb_tibble(x = 1:10, .prudence = c(rows = 5))
  out <- df %>%
    count(x)

  expect_identical(get_prudence_duckplyr_df(out), c(rows = 5))
  expect_error(nrow(out))
})

test_that("prudence after operation with success", {
  df <- duckdb_tibble(x = 1:10, .prudence = c(rows = 5))
  out <- df %>%
    count()

  expect_identical(get_prudence_duckplyr_df(out), c(rows = 5))
  expect_error(nrow(out), NA)
})

test_that("prudence after summarise() with success", {
  df <- duckdb_tibble(x = 1:10, .prudence = c(rows = 5))
  out <- df %>%
    summarise(n())

  expect_identical(get_prudence_duckplyr_df(out), c(rows = 5))
  expect_error(nrow(out), NA)
})

test_that("mutate(n()) works with stingy duckplyr frames", {
  df <- duckdb_tibble(a = 1:3, b = c(1, 1, 2), .prudence = "stingy")

  out <- df %>% mutate(n = n(), .by = b)
  expect_s3_class(out, "duckplyr_df")
  expect_identical(collect(out)$n, c(2L, 2L, 1L))

  out2 <- df %>% mutate(n = n())
  expect_s3_class(out2, "duckplyr_df")
  expect_identical(collect(out2)$n, c(3L, 3L, 3L))
})
