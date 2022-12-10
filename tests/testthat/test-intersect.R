test_that("as_duckplyr_df() commutes for intersect()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% intersect()
  post <- test_df %>% intersect() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
