test_that("as_duckplyr_df() commutes for rows_insert()", {
  # Data
  test_df <- data.frame(a = 1, b = 2)

  # Run
  pre <- test_df %>% as_duckplyr_df() %>% rows_insert()
  post <- test_df %>% rows_insert() %>% as_duckplyr_df()

  # Compare
  expect_equal(pre, post)
})
