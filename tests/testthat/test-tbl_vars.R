test_that("as_duckplyr_df() commutes for tbl_vars()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% tbl_vars()
  post <- test_df %>% tbl_vars() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
