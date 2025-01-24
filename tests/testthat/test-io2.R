test_that("Roundtrip to CSV works", {
  df <- tibble(a = 1:3, b = letters[4:6])

  path_csv <- withr::local_tempfile(fileext = ".csv")

  write.csv(df, path_csv, row.names = FALSE)
  out <- read_csv_duckdb(path_csv)

  expect_equal(collect(out), df)
})

test_that("Roundtrip to Parquet works", {
  df <- tibble(a = 1:3, b = letters[4:6])

  path_parquet <- withr::local_tempfile(fileext = ".parquet")

  compute_parquet(df, path_parquet)
  out <- read_parquet_duckdb(path_parquet)

  expect_equal(collect(out), df)
})

test_that("Writing to Parquet works without materialization", {
  n_calls <- 0
  withr::local_options(duckdb.materialize_callback = function(...) {
    n_calls <<- n_calls + 1
  })

  df <- tibble(a = 1:3, b = letters[4:6])
  path_parquet <- withr::local_tempfile(fileext = ".parquet")

  out <- df %>%
    as_duckplyr_df_impl() %>%
    select(b, a) %>%
    compute_parquet(path_parquet)

  expect_equal(n_calls, 0)

  # Side effect
  nrow(out)
  expect_equal(n_calls, 1)

  expect_equal(collect(out), df[2:1])
  expect_equal(n_calls, 1)
})

test_that("Reading from Parquet and collecting", {
  n_calls <- 0
  withr::local_options(duckdb.materialize_callback = function(...) {
    n_calls <<- n_calls + 1
  })

  df <- tibble(a = 1:3, b = letters[4:6])
  path_parquet <- withr::local_tempfile(fileext = ".parquet")

  df %>%
    as_duckplyr_df_impl() %>%
    select(b, a) %>%
    compute_parquet(path_parquet)

  expect_equal(n_calls, 0)

  out <- read_parquet_duckdb(path_parquet)
  expect_equal(n_calls, 0)

  # Side effect
  nrow(out)
  expect_equal(n_calls, 1)

  collected <- collect(out)
  expect_equal(collected, df[2:1])
})
