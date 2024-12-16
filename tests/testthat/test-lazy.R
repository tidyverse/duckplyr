test_that("lazy duckplyr frames will collect", {
  tbl <- ducktbl(a = 1, .lazy = TRUE)
  expect_identical(
    collect(tbl),
    ducktbl(a = 1)
  )
})

test_that("eager duckplyr frames are converted to data frames", {
  tbl <- ducktbl(a = 1)
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("lazy duckplyr frames are converted to data frames", {
  tbl <- ducktbl(a = 1, .lazy = TRUE)
  expect_identical(
    as.data.frame(tbl),
    data.frame(a = 1)
  )
})

test_that("eager duckplyr frames are converted to tibbles", {
  tbl <- ducktbl(a = 1)
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})

test_that("lazy duckplyr frames are converted to tibbles", {
  tbl <- ducktbl(a = 1, .lazy = TRUE)
  expect_identical(
    as_tibble(tbl),
    tibble(a = 1)
  )
})
