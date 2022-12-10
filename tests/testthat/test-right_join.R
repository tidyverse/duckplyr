test_that("as_duckplyr_df() commutes for right_join()", {
  # Data
  test_df_x <- data.frame(a = 1, b = 2)
  test_df_y <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df_x %>% as_duckplyr_df() %>% right_join(test_df_y)
  post <- test_df_x %>% right_join(test_df_y) %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
