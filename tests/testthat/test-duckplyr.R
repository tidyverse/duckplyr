test_that("same_src() works", {
  x <- data.frame(a = 1)
  y <- as_duckplyr_df(x)

  expect_true(same_src(x, y))
  expect_true(same_src(y, x))
  expect_true(same_src(y, y))
})

test_that("collect() works", {
  x <- data.frame(a = 1)
  y <- as_duckplyr_df(x)
  z <- select(y, a)

  local_options(duckdb.materialize_message = TRUE)
  expect_output(collect(z))

  expect_snapshot({
    print(z)
  })
})

test_that("tbl_vars() works", {
  x <- data.frame(a = 1)
  y <- as_duckplyr_df(x)
  z <- select(y, a)

  expect_identical(tbl_vars(z), tbl_vars(x))

  local_options(duckdb.materialize_message = TRUE)
  expect_output(collect(z))
})
