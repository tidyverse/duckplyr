test_that("as_duckplyr_df() commutes for union_all()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% union_all()
  post <- test_df %>% union_all() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
