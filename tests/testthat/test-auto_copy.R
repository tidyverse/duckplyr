test_that("as_duckplyr_df() commutes for auto_copy()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% auto_copy()
  post <- test_df %>% auto_copy() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
