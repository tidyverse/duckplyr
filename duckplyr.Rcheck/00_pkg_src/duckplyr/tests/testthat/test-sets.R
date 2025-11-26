test_that("stingy union_all()", {
  data <- duckdb_tibble(x = 1, .prudence = "stingy")
  out <- collect(union_all(data, tibble(x = 2)))
  expect_equal(out, tibble(x = c(1, 2)))
})
