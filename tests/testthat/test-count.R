test_that("as_duckplyr_df() commutes for count()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% count()
  post <- test_df %>% count() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
