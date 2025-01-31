test_that("desc() is handled without qualification", {
  out <-
    duckdb_tibble(a = 1:3, .prudence = "frugal") %>%
    arrange(desc(a)) %>%
    pull()

  expect_identical(out, 3:1)
})

test_that("desc() is handled with qualification", {
  out <-
    duckdb_tibble(a = 1:3, .prudence = "frugal") %>%
    arrange(dplyr::desc(a)) %>%
    pull()

  expect_identical(out, 3:1)
})

test_that("desc() fails if it points elsewhere", {
  desc <- function(...) {}

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, .prudence = "frugal") %>%
      arrange(desc(a))
  })
})
