test_that("as_duckplyr_df() commutes for n_groups()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% n_groups()
  post <- test_df %>% n_groups() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
