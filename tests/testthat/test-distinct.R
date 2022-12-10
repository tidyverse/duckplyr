test_that("as_duckplyr_df() commutes for distinct()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% distinct()
  post <- test_df %>% distinct() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
