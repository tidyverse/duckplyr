test_that("as_duckplyr_df() commutes for nest_by()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% nest_by()
  post <- test_df %>% nest_by() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
