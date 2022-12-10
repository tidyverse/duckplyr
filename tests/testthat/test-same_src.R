test_that("as_duckplyr_df() commutes for same_src()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% same_src()
  post <- test_df %>% same_src() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
