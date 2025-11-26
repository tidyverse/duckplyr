test_that("compute_csv()", {
  df <- data.frame(x = c(1, 2))
  withr::defer(unlink("test.csv"))
  out <- compute_csv(df, path = "test.csv")

  expect_identical(out, as_duckdb_tibble(df))
  expect_false(is_prudent_duckplyr_df(out))
})

test_that("compute_csv() prudence", {
  df <- data.frame(x = c(1, 2))
  withr::defer(unlink("test.csv"))
  out <- compute_csv(df, path = "test.csv", prudence = "stingy")

  expect_true(is_prudent_duckplyr_df(out))
  expect_identical(collect(out), as_tibble(df))
})

test_that("compute_csv() with options passed to read", {
  # Test with delimiter option which is valid for both read and write
  df <- data.frame(x = c(1, 2))
  path <- tempfile(fileext = ".csv")
  withr::defer(unlink(path))

  out <- compute_csv(df, path = path, options = list(delim = ";"))

  expect_identical(out, as_duckdb_tibble(df))
  expect_identical(collect(out), as_tibble(df))
})
