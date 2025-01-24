test_that("compute_parquet()", {
  skip_if_not_installed("duckdb", "1.1.3.9028")

  df <- data.frame(x = c(1, 2))
  withr::defer(unlink("test.parquet"))
  out <- compute_parquet(df, path = "test.parquet")

  expect_identical(out, as_duckdb_tibble(df))
  expect_false(is_funneled_duckplyr_df(out))
})

test_that("compute_parquet() with options", {
  skip_if_not_installed("duckdb", "1.1.3.9028")

  df <- data.frame(x = c(1, 2), a = c("a", "b"))
  withr::defer(unlink("test", recursive = TRUE))
  dir.create("test")
  out <- compute_parquet(df, path = "test", options = list(partition_by = "a"))

  expect_identical(out, as_duckdb_tibble(df))
  expect_false(is_funneled_duckplyr_df(out))
})

test_that("compute_csv()", {
  skip_if_not_installed("duckdb", "1.1.3.9028")

  df <- data.frame(x = c(1, 2))
  withr::defer(unlink("test.csv"))
  out <- compute_csv(df, path = "test.csv")

  expect_identical(out, as_duckdb_tibble(df))
  expect_false(is_funneled_duckplyr_df(out))
})

test_that("compute_csv() funnel", {
  skip_if_not_installed("duckdb", "1.1.3.9028")

  df <- data.frame(x = c(1, 2))
  withr::defer(unlink("test.csv"))
  out <- compute_csv(df, path = "test.csv", funnel = TRUE)

  expect_true(is_funneled_duckplyr_df(out))
  expect_identical(collect(out), as_tibble(df))
})
