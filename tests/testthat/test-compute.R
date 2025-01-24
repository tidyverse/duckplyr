test_that("compute()", {
  skip_if_not_installed("duckdb", "1.1.3.9029")
  set.seed(20241230)

  df <- duckdb_tibble(x = c(1, 2))
  out <- compute(df)
  expect_snapshot({
    duckdb_rel_from_df(out)
  })

  expect_identical(out, as_duckdb_tibble(df))
  expect_false(is_funneled_duckplyr_df(out))
})
