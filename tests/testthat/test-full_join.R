test_that("as_duckplyr_df() commutes for full_join()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% full_join()
  post <- test_df %>% full_join() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
