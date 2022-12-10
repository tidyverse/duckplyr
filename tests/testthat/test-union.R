test_that("as_duckplyr_df() commutes for union()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% union()
  post <- test_df %>% union() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
