test_that("Can query ptype without triggering materialization", {
  local_options(duckdb.materialize_message = TRUE)

  x <- data.frame(a = 1) %>% duckplyr_mutate(b = 2)

  expect_silent(vctrs::vec_ptype(x))

  expect_output(nrow(x))
})
