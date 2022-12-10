test_that("as_duckplyr_df() commutes for slice_tail()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% slice_tail()
  post <- test_df %>% slice_tail() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
