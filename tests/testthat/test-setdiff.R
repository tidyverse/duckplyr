test_that("as_duckplyr_df() commutes for setdiff()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% setdiff()
  post <- test_df %>% setdiff() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
