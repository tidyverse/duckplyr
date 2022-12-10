test_that("as_duckplyr_df() commutes for group_keys()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% group_keys()
  post <- test_df %>% group_keys() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
