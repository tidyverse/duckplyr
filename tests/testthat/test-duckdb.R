test_that("case-insensitive duplicates", {
  out <- duck_tbl(a = 1:2) %>%
    mutate(A = a + 1L, b = A - 1L)

  expect_identical(out$a, out$b)
})
