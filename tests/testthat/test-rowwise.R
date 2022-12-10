test_that("as_duckplyr_df() commutes for rowwise()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% rowwise()
  post <- test_df %>% rowwise() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
