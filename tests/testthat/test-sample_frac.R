test_that("as_duckplyr_df() commutes for sample_frac()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% sample_frac()
  post <- test_df %>% sample_frac() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
