test_that("compute_parquet()", {
  df <- data.frame(x = c(1, 2))
  withr::defer(unlink("test.parquet"))
  out <- compute_parquet(df, path = "test.parquet")

  expect_identical(out, as_duckdb_tibble(df))
  expect_false(is_prudent_duckplyr_df(out))
})

test_that("compute_parquet() with options", {
  df <- data.frame(x = c(1, 2), a = c("a", "b"))
  withr::defer(unlink("test", recursive = TRUE))
  dir.create("test")
  out <- compute_parquet(df, path = "test", options = list(partition_by = "a"))

  expect_identical(out, as_duckdb_tibble(df))
  expect_false(is_prudent_duckplyr_df(out))
})

test_that("compute_parquet() with write-only options passed to write but removed for read", {
  df <- data.frame(x = c(1, 2))
  path <- tempfile(fileext = ".parquet")
  withr::defer(unlink(path))

  expect_silent(
    out <- compute_parquet(
      df,
      path = path,
      options = list(compression = "zstd", compression_level = 9)
    )
  )

  expect_identical(out, as_duckdb_tibble(df))
})

test_that("compute_parquet() with options passed to read", {
  # Test with compression option which is valid for both read and write
  df <- data.frame(x = c(1, 2))
  path <- tempfile(fileext = ".parquet")
  withr::defer(unlink(path))

  out <- compute_parquet(df, path = path, options = list(compression = "gzip"))

  expect_identical(out, as_duckdb_tibble(df))
  expect_identical(collect(out), as_tibble(df))
})

test_that("compute_parquet() is a generic function", {
  expect_true(is.function(compute_parquet))
  m <- methods("compute_parquet")
  expect_true(any(grepl("compute_parquet.duckplyr_df", m)))
  expect_true(any(grepl("compute_parquet.data.frame", m)))
})

test_that("compute_parquet() with duckplyr_df", {
  df <- duckdb_tibble(x = c(1, 2))
  withr::defer(unlink("test_duck.parquet"))
  out <- compute_parquet(df, path = "test_duck.parquet")

  expect_identical(collect(out), collect(df))
  expect_true(inherits(out, "duckplyr_df"))
})
