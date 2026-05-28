test_that("count(sort = TRUE) orders lazily by descending count", {
  out <-
    duckdb_tibble(x = c("a", "a", "b"), .prudence = "stingy") %>%
    count(x, sort = TRUE) %>%
    collect()

  expect_identical(out, tibble(x = c("a", "b"), n = c(2L, 1L)))
})

test_that("count(sort = TRUE) is supported with forced duckplyr execution", {
  withr::local_envvar(DUCKPLYR_FORCE = "TRUE")

  out <-
    duckdb_tibble(x = c("a", "a", "b")) %>%
    count(x, sort = TRUE) %>%
    collect()

  expect_identical(out, tibble(x = c("a", "b"), n = c(2L, 1L)))
})

test_that("count(sort = TRUE) orders ties by grouping columns", {
  out <-
    duckdb_tibble(x = c("b", "a"), .prudence = "stingy") %>%
    count(x, sort = TRUE) %>%
    collect()

  expect_identical(out, tibble(x = c("a", "b"), n = c(1L, 1L)))
})

test_that("count(sort = TRUE) supports multiple grouping columns", {
  out <-
    duckdb_tibble(
      g = c("g2", "g2", "g1", "g1", "g2", "g1"),
      x = c("b", "a", "a", "a", "a", "b"),
      .prudence = "stingy"
    ) %>%
    count(g, x, sort = TRUE) %>%
    collect()

  expect_identical(
    out,
    tibble(
      g = c("g1", "g2", "g1", "g2"),
      x = c("a", "a", "b", "b"),
      n = c(2L, 2L, 1L, 1L)
    )
  )
})

test_that("count(sort = TRUE) supports weighted counts", {
  out <-
    duckdb_tibble(
      x = c("a", "a", "b", "b"),
      w = c(1, 3, 10, NA),
      .prudence = "stingy"
    ) %>%
    count(x, wt = w, sort = TRUE) %>%
    collect()

  expect_equal(out, tibble(x = c("b", "a"), n = c(10, 4)))
})

test_that("count(sort = TRUE) supports custom count column names", {
  out <-
    duckdb_tibble(
      x = c("a", "a", "b"),
      w = c(1, 3, 10),
      .prudence = "stingy"
    ) %>%
    count(x, wt = w, sort = TRUE, name = "total") %>%
    collect()

  expect_equal(out, tibble(x = c("b", "a"), total = c(10, 4)))
})

test_that("count(sort = TRUE) matches dplyr for all-NA weighted counts", {
  df <- tibble(x = c("a", "a"), w = c(NA_real_, NA_real_))
  expected <- df %>% count(x, wt = w, sort = TRUE)

  out <-
    duckdb_tibble(
      x = df$x,
      w = df$w,
      .prudence = "stingy"
    ) %>%
    count(x, wt = w, sort = TRUE) %>%
    collect()

  expect_equal(out, expected)
})

test_that("count(sort = TRUE) supports empty inputs", {
  out <-
    duckdb_tibble(x = character(), .prudence = "stingy") %>%
    count(x, sort = TRUE) %>%
    collect()

  expect_identical(out, tibble(x = character(), n = integer()))
})

test_that("count(sort = TRUE) matches dplyr for grouped data", {
  df <- tibble(
    g = c("A", "A", "B", "B", "B"),
    x = c("a", "b", "a", "a", "b")
  )
  expected <- df %>% group_by(g) %>% count(x, sort = TRUE)

  out <-
    duckdb_tibble(
      g = df$g,
      x = df$x
    ) %>%
    group_by(g) %>%
    count(x, sort = TRUE)

  expect_equal(out, expected)
  expect_identical(group_vars(out), group_vars(expected))
})
