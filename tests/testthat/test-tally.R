test_that("as_duckplyr_df() commutes for tally()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% tally()
  post <- test_df %>% tally() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
