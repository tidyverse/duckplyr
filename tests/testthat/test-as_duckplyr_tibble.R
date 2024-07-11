test_that("as_duckplyr_tibble() works", {
  expect_s3_class(as_duckplyr_tibble(tibble(a = 1)), "duckplyr_df")
  expect_equal(class(as_duckplyr_tibble(tibble(a = 1))), c("duckplyr_df", class(tibble())))

  expect_s3_class(as_duckplyr_tibble(data.frame(a = 1)), "duckplyr_df")
  expect_equal(class(as_duckplyr_tibble(data.frame(a = 1))), c("duckplyr_df", class(tibble())))
})
