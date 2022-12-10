test_that("as_duckplyr_df() commutes for group_modify()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% group_modify()
  post <- test_df %>% group_modify() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
