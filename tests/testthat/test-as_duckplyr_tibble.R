test_that("as_duckplyr_tibble() works", {
  expect_snapshot({
    as_duckplyr_tibble(tibble(a = 1))
  })

  local_options(lifecycle_verbosity = "quiet")

  expect_s3_class(as_duckplyr_tibble(tibble(a = 1)), "duckplyr_df")
  expect_equal(
    class(as_duckplyr_tibble(tibble(a = 1))),
    c("duckplyr_df", class(tibble()))
  )

  expect_s3_class(as_duckplyr_tibble(data.frame(a = 1)), "duckplyr_df")
  expect_equal(
    class(as_duckplyr_tibble(data.frame(a = 1))),
    c("duckplyr_df", class(tibble()))
  )
})

test_that("as_duckplyr_df() and special df", {
  # https://github.com/tidyverse/duckplyr/issues/127

  by_cyl <- dplyr::group_by(mtcars, cyl)
  expect_snapshot(error = TRUE, {
    as_duckplyr_df(by_cyl)
  })
})
