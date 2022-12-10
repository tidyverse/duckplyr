test_that("as_duckplyr_df() commutes for dplyr_reconstruct()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% dplyr_reconstruct()
  post <- test_df %>% dplyr_reconstruct() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
