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

test_that("compute_csv() is a generic function", {
  expect_true(is.function(compute_csv))
  m <- methods("compute_csv")
  expect_true(any(grepl("compute_csv.duckplyr_df", m)))
  expect_true(any(grepl("compute_csv.data.frame", m)))
})

test_that("compute_csv() with duckplyr_df", {
  df <- duckdb_tibble(x = c(1, 2))
  withr::defer(unlink("test_duck.csv"))
  out <- compute_csv(df, path = "test_duck.csv")

  expect_identical(collect(out), collect(df))
  expect_true(inherits(out, "duckplyr_df"))
})
