test_that("Can query ptype without triggering materialization", {
  n_calls <- 0
  local_options(duckdb.materialize_callback = function(...) {
    n_calls <<- n_calls + 1
  })

  x <- data.frame(a = 1) %>% duckplyr_mutate(b = 2)

  vctrs::vec_ptype(x)
  expect_equal(n_calls, 0)

  nrow(x)
  expect_equal(n_calls, 1)
})
