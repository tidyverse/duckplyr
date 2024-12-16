test_that("Can construct", {
  expect_identical(
    ducktbl(a = 1),
    as_ducktbl(tibble::tibble(a = 1))
  )

  expect_identical(ducktbl(a = 1)$a, 1)
})

test_that(".lazy = TRUE forbids materialization", {
  tbl <- ducktbl(a = 1, .lazy = TRUE)
  expect_error(length(tbl$a))
})

test_that(".lazy = TRUE forbids materialization for as_ducktbl()", {
  tbl <- as_ducktbl(data.frame(a = 1), .lazy = TRUE)
  expect_error(length(tbl$a))
})
