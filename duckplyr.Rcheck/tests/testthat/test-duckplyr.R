test_that("same_src() works", {
  x <- data.frame(a = 1)
  y <- as_duckplyr_df_impl(x)

  expect_true(same_src(x, y))
  expect_true(same_src(y, x))
  expect_true(same_src(y, y))
})

test_that("collect() works", {
  x <- data.frame(a = 1)
  y <- as_duckplyr_df_impl(x)
  z <- select(y, a)

  n_calls <- 0
  local_options(duckdb.materialize_callback = function(...) {
    n_calls <<- n_calls + 1
  })

  collect(z)
  expect_equal(n_calls, 1)

  expect_snapshot({
    print(z)
  })
  expect_equal(n_calls, 1)
})

test_that("tbl_vars() works", {
  x <- data.frame(a = 1)
  y <- as_duckplyr_df_impl(x)
  z <- select(y, a)

  expect_identical(tbl_vars(z), tbl_vars(x))

  n_calls <- 0
  local_options(duckdb.materialize_callback = function(...) {
    n_calls <<- n_calls + 1
  })

  collect(z)
  expect_equal(n_calls, 1)
})
