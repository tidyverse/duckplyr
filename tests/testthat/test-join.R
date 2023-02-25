# Basic properties --------------------------------------------------------

test_that("when keep = TRUE, duckplyr_right_join() preserves both sets of keys", {
  message("a")
  # when keys have different names
  df1 <- data.frame(a = c(2, 3))
  df2 <- data.frame(x = c(3, 4))

  out <- duckplyr_right_join(df1, df2, by = c("a" = "x"), keep = TRUE)
  message("b")
  expect_equal(out$a, c(3, NA))
  message("c")
  expect_equal(out$x, c(3, 4))
})
