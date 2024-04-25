test_that("case-insensitive duplicates", {
  out <- data.frame(a = 1:2) %>%
    as_duckplyr_df() %>%
    mutate(A = a + 1L, b = A - 1L)

  expect_identical(out$a, out$b)
})
