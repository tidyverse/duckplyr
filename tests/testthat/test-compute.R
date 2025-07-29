test_that("compute()", {
  set.seed(20241230)

  transform <- function(x) {
    x <- gsub("0x[0-9a-f]+", "0xdeadbeef", x)
    x
  }

  df <- duckdb_tibble(x = c(1, 2))
  out <- compute(df)
  expect_snapshot(transform = transform, {
    duckdb_rel_from_df(out)
  })

  expect_identical(out, as_duckdb_tibble(df))
  expect_false(is_prudent_duckplyr_df(out))
})

test_that("prudence with failure", {
  set.seed(20250124)

  df <- duckdb_tibble(x = 1:10, .prudence = c(rows = 5))
  out <- compute(df)

  expect_identical(collect(out), collect(df))
  expect_identical(get_prudence_duckplyr_df(out), c(rows = 5))

  expect_error(nrow(out))
})

test_that("prudence with success", {
  set.seed(20250126)

  df <- duckdb_tibble(x = 1:10, .prudence = c(rows = 20))
  out <- compute(df)

  expect_identical(collect(out), collect(df))
  expect_identical(get_prudence_duckplyr_df(out), c(rows = 20))

  expect_error(nrow(out), NA)
})
