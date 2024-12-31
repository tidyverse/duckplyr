test_that("compute()", {
  skip_if_not_installed("duckdb", "1.1.3.9029")
  set.seed(20241230)

  df <- duck_tbl(x = c(1, 2))
  out <- compute(df)
  expect_snapshot({
    duckdb_rel_from_df(out)
  })

  expect_identical(out, as_duck_tbl(df))
  expect_false(is_lazy_duckplyr_df(out))
})
