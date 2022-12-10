test_that("as_duckplyr_df() commutes for arrange()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% arrange()
  post <- test_df %>% arrange() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
