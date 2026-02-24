test_that("duckdb n_distinct() basic", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  df <- duckdb_tibble(
    a = c(1, 1, 2, 2, 2),
    b = c(3, 3, NA, 3, 3)
  )

  out <- df %>%
    summarise(
      n_distinct_a = n_distinct(a),
      n_distinct_a_na_rm = n_distinct(a, na.rm = TRUE),
      n_distinct_b = n_distinct(b, na.rm = FALSE),
      n_distinct_b_na_rm = n_distinct(b, na.rm = TRUE)
    )

  expect_equal(out$n_distinct_a, 2)
  expect_equal(out$n_distinct_a_na_rm, 2)
  expect_equal(out$n_distinct_b, 2)
  expect_equal(out$n_distinct_b_na_rm, 1)
})


test_that("duckdb n_distinct() counts empty inputs", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  df <- duckdb_tibble(
    a = integer(),
    b = double(),
    c = logical(),
    d = character()
  )

  out <- df %>%
    summarise(
      n_distinct_a = n_distinct(a),
      n_distinct_b = n_distinct(b),
      n_distinct_c = n_distinct(c),
      n_distinct_d = n_distinct(d),
    )

  expect_equal(out$n_distinct_a, 0)
  expect_equal(out$n_distinct_b, 0)
  expect_equal(out$n_distinct_c, 0)
  expect_equal(out$n_distinct_d, 0)
})


test_that("duckdb n_distinct() counts unique values in simple vectors", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  df <- duckdb_tibble(
    a = c(TRUE, FALSE, NA),
    b = c(1, 2, NA),
    c = c(1L, 2L, NA),
    d = c("x", "y", NA)
  )

  out <- df %>%
    summarise(
      n_distinct_a = n_distinct(a),
      n_distinct_b = n_distinct(b),
      n_distinct_c = n_distinct(c),
      n_distinct_d = n_distinct(d),
    )

  expect_equal(out$n_distinct_a, 3)
  expect_equal(out$n_distinct_b, 3)
  expect_equal(out$n_distinct_c, 3)
  expect_equal(out$n_distinct_d, 3)
})


test_that("duckdb n_distinct() can drop missing values", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  df <- duckdb_tibble(
    a = c(NA),
    b = c(NA, 0),
  )

  out <- df %>%
    summarise(
      n_distinct_a = n_distinct(a, na.rm = TRUE),
      n_distinct_b = n_distinct(b, na.rm = TRUE),
    )

  expect_equal(out$n_distinct_a, 0)
  expect_equal(out$n_distinct_b, 1)
})


test_that("duckdb n_distinct() counts NA correctly", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  df <- duckdb_tibble(
    a = c(1, NA, 1, NA, 2, NA, 2),
    b = c(3, 3, NA, 3, NA, 4, 5)
  )

  out <- df %>%
    summarise(
      n_distinct_a = n_distinct(a),
      n_distinct_a_na_rm = n_distinct(a, na.rm = TRUE),
      n_distinct_b = n_distinct(b, na.rm = FALSE),
      n_distinct_b_na_rm = n_distinct(b, na.rm = TRUE)
    )

  expect_equal(out$n_distinct_a, 3)
  expect_equal(out$n_distinct_a_na_rm, 2)
  expect_equal(out$n_distinct_b, 4)
  expect_equal(out$n_distinct_b_na_rm, 3)
})


test_that("duckdb n_distinct() error with more than one argument", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  df <- duckdb_tibble(
    a = c(1, 1, 2, 2, 2),
    b = c(3, 3, NA, 3, 3)
  )

  expect_snapshot(error = TRUE, {
    df %>% summarise(dummy = n_distinct(a, b))
  })
})


test_that("duckdb n_distinct() error with na.rm not being TRUE/FALSE", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  df <- duckdb_tibble(
    a = c(1, 2),
  )

  expect_snapshot(error = TRUE, {
    df %>% summarise(dummy = n_distinct(a, na.rm = "b"))
  })
})


test_that("duckdb n_distinct() error with mutate", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  df <- duckdb_tibble(
    a = c(1, 1, 2, 2, 2),
    b = c(3, 3, NA, 3, 3)
  )

  expect_snapshot(error = TRUE, {
    df %>% mutate(dummy = n_distinct(a))
  })
})
