test_that("methods_overwrite() works", {
  methods_overwrite()
  on.exit(methods_restore())

  out <-
    data.frame(a = 1) %>%
    mutate(b = 2)

  expect_false(duckdb$df_is_materialized(out))
})
