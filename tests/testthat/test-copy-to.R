test_that("`duckplyr_auto_copy()` is a no-op when they share the same source", {
  skip("TODO duckdb")
  df1 <- tibble(x = 1)
  df2 <- tibble(x = 2)

  expect_identical(duckplyr_auto_copy(df1, df2), df2)
})

test_that("`duckplyr_auto_copy()` throws an informative error on different sources (#6798)", {
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_auto_copy(df, NULL)
  })
})
