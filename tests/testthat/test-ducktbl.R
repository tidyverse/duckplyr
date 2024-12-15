test_that("Can construct", {
  expect_identical(
    ducktbl(a = 1),
    as_duckplyr_df_impl(tibble::tibble(a = 1))
  )

  expect_identical(ducktbl(a = 1)$a, 1)
})
