test_that("last_rel() works", {
  last_rel_store(NULL)
  expect_null(last_rel())

  out <- duckplyr_mutate(data.frame(a = 1), b = 2)
  rel <- duckdb$rel_from_altrep_df(out)

  expect_null(last_rel())

  expect_silent(nrow(out))
  expect_identical(last_rel(), rel)
})
