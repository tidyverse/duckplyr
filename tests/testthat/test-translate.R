test_that("inline parens (3)", {
  df <- data.frame(a = 1, b = 2)
  expect_identical(
    rel_translate(quo((a) * (b)), df),
    rel_translate(quo((a * b)), df),
  )
})

test_that("call with named argument", {
  expect_snapshot(error = TRUE, {
    rel_translate(quo(c(1, b = 2)))
  })
})

test_that("a %in% b", {
  expect_snapshot(error = TRUE, {
    rel_translate(quo(a %in% b), data.frame(a = 1:3, b = 2:4))
  })
})

test_that("comparison expression translated", {
  df <- data.frame(a = 1L, b = 2L, c = 3)
  expect_snapshot({
    rel_translate(quo(a > 123L), df)
  })

  expect_snapshot({
    rel_translate(quo(a > 123.0), df)
  })

  expect_snapshot({
    rel_translate(quo(a == b), df)
  })

  expect_snapshot({
    rel_translate(quo(a <= c), df)
  })
})

test_that("aggregation primitives", {
  df <- data.frame(a = 1L, b = TRUE)

  expect_snapshot({
    rel_translate(expr(sum(a)), df)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(sum(a, b)), df)
  })

  expect_snapshot({
    rel_translate(expr(sum(a, na.rm = TRUE)), df)
  })

  expect_snapshot({
    rel_translate(expr(sum(a, na.rm = FALSE)), df)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(sum(a, na.rm = b)), df)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(sum(a, na.rm = 1)), df)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(sum(a)), df, need_window = TRUE)
  })

  expect_snapshot({
    rel_translate(expr(min(a)), df)
  })

  expect_snapshot({
    rel_translate(expr(min(a, na.rm = TRUE)), df)
  })

  expect_snapshot({
    rel_translate(expr(max(a)), df)
  })

  expect_snapshot({
    rel_translate(expr(max(a, na.rm = TRUE)), df)
  })

  expect_snapshot({
    rel_translate(expr(any(a)), df)
  })

  expect_snapshot({
    rel_translate(expr(any(a, na.rm = TRUE)), df)
  })

  expect_snapshot({
    rel_translate(expr(all(a)), df)
  })

  expect_snapshot({
    rel_translate(expr(all(a, na.rm = TRUE)), df)
  })

  expect_snapshot({
    rel_translate(expr(mean(a)), df)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(mean(a, b)), df)
  })

  expect_snapshot({
    rel_translate(expr(mean(a, na.rm = TRUE)), df)
  })

  expect_snapshot({
    rel_translate(expr(mean(a, na.rm = FALSE)), df)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(mean(a, na.rm = b)), df)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(mean(a, na.rm = 1)), df)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(mean(a)), df, need_window = TRUE)
  })
})

test_that("aggregation primitives with na.rm and window functions", {
  df <- data.frame(a = 1L, b = TRUE)

  expect_snapshot({
    "Test aggregation primitives with na.rm = TRUE in window functions"
    rel_translate(expr(sum(a, na.rm = TRUE)), df, need_window = TRUE)
  })

  expect_snapshot({
    rel_translate(expr(min(a, na.rm = TRUE)), df, need_window = TRUE)
  })

  expect_snapshot({
    rel_translate(expr(max(a, na.rm = TRUE)), df, need_window = TRUE)
  })

  expect_snapshot({
    rel_translate(expr(mean(a, na.rm = TRUE)), df, need_window = TRUE)
  })

  expect_snapshot(error = TRUE, {
    "Test error when na.rm = FALSE in window functions"
    rel_translate(expr(sum(a, na.rm = FALSE)), df, need_window = TRUE)
  })

  expect_snapshot(error = TRUE, {
    rel_translate(expr(mean(a, na.rm = FALSE)), df, need_window = TRUE)
  })
})

test_that("rel_find_call() success paths", {
  env <- baseenv()

  expect_snapshot({
    "Success: Translate base function"
    rel_find_call(quote(mean), env)
  })

  expect_snapshot({
    "Success: Translate dplyr::n() function"
    "https://github.com/tidyverse/dplyr/pull/7046"
    rel_find_call(quote(n), env)
  })

  expect_snapshot({
    "Success: Translate DuckDB function with 'dd$' prefix"
    rel_find_call(quote(dd$ROW), env)
  })

  expect_snapshot({
    "Success: Translate stats function when stats is available"
    rel_find_call(quote(sd), new_environment(parent = asNamespace("stats")))
  })

  skip_if_not_installed("lubridate")

  expect_snapshot({
    "Success: Translate lubridate function"
    rel_find_call(quote(lubridate::wday), env)
  })

  expect_snapshot({
    "Success: Translate lubridate function when exported"
    rel_find_call(quote(wday), new_environment(list(wday = lubridate::wday)))
  })
})

test_that("rel_find_call() error paths", {
  env <- baseenv()

  expect_snapshot(error = TRUE, {
    "Error: Can't translate function with invalid '::' structure"
    rel_find_call(quote(pkg::""), env)
  })

  expect_snapshot(error = TRUE, {
    "Error: Can't translate function with invalid '::' components"
    rel_find_call(call("::", "pkg", 123), env, env)
  })

  expect_snapshot(error = TRUE, {
    "Error: No translation for unknown function"
    rel_find_call(quote(unknown_function), env)
  })

  expect_snapshot(error = TRUE, {
    "Error: No translation for unknown function from some package"
    rel_find_call(quote(somepkg::unknown_function), env)
  })

  expect_snapshot(error = TRUE, {
    "Error: Function not found in the environment"
    rel_find_call(quote(mean), new_environment())
  })

  expect_snapshot(error = TRUE, {
    "Error: Function does not map to the corresponding package"
    rel_find_call(quote(mean), new_environment(list(mean = stats::sd)))
  })
})

test_that("dd$ prefix", {
  out <- duckdb_tibble(a = "duckdb") |>
    mutate(b = dd$ascii(a))
  expect_equal(out, duckdb_tibble(a = "duckdb", b = 100L))
})

test_that("if_else with named arguments", {
  df <- data.frame(a = c(TRUE, FALSE, NA), b = 1:3, c = 4:6)

  # Named arguments should be normalized and work
  expect_identical(
    rel_translate(quo(if_else(a, true = b, false = c)), df),
    rel_translate(quo(if_else(a, b, c)), df)
  )

  # Arguments can be reordered using names
  expect_identical(
    rel_translate(quo(if_else(a, false = c, true = b)), df),
    rel_translate(quo(if_else(a, b, c)), df)
  )

  # condition argument can be named
  expect_identical(
    rel_translate(quo(if_else(condition = a, true = b, false = c)), df),
    rel_translate(quo(if_else(a, b, c)), df)
  )

  # missing= argument is not supported
  expect_snapshot(error = TRUE, {
    rel_translate(quo(if_else(a, true = b, false = c, missing = NA)), df)
  })

  # ptype= argument is not supported
  expect_snapshot(error = TRUE, {
    rel_translate(quo(if_else(a, true = b, false = c, ptype = integer())), df)
  })
})

test_that("aggregation functions with named arguments", {
  df <- data.frame(a = 1:3, b = c(TRUE, FALSE, TRUE))

  # sum with named na.rm reordered
  expect_identical(
    rel_translate(expr(sum(na.rm = TRUE, a)), df),
    rel_translate(expr(sum(a, na.rm = TRUE)), df)
  )

  # mean with named x
  expect_identical(
    rel_translate(expr(mean(x = a)), df),
    rel_translate(expr(mean(a)), df)
  )

  # mean with reordered named arguments
  expect_identical(
    rel_translate(expr(mean(na.rm = TRUE, x = a)), df),
    rel_translate(expr(mean(a, na.rm = TRUE)), df)
  )

  # sd with named arguments
  expect_identical(
    rel_translate(quo(sd(x = a, na.rm = TRUE)), df),
    rel_translate(quo(sd(a, na.rm = TRUE)), df)
  )

  # sd with reordered named arguments
  expect_identical(
    rel_translate(quo(sd(na.rm = TRUE, x = a)), df),
    rel_translate(quo(sd(a, na.rm = TRUE)), df)
  )

  # median with named arguments
  expect_identical(
    rel_translate(quo(median(x = a, na.rm = TRUE)), df),
    rel_translate(quo(median(a, na.rm = TRUE)), df)
  )

  # min/max with named na.rm reordered
  expect_identical(
    rel_translate(expr(min(na.rm = TRUE, a)), df),
    rel_translate(expr(min(a, na.rm = TRUE)), df)
  )

  expect_identical(
    rel_translate(expr(max(na.rm = TRUE, a)), df),
    rel_translate(expr(max(a, na.rm = TRUE)), df)
  )

  # any/all with named na.rm reordered
  expect_identical(
    rel_translate(expr(any(na.rm = TRUE, b)), df),
    rel_translate(expr(any(b, na.rm = TRUE)), df)
  )

  expect_identical(
    rel_translate(expr(all(na.rm = TRUE, b)), df),
    rel_translate(expr(all(b, na.rm = TRUE)), df)
  )

  # n_distinct with named na.rm
  expect_identical(
    rel_translate(quo(n_distinct(na.rm = TRUE, a)), df),
    rel_translate(quo(n_distinct(a, na.rm = TRUE)), df)
  )
})

test_that("grepl/sub/gsub with named arguments", {
  df <- data.frame(a = "hello world")

  # grepl with named arguments
  expect_identical(
    rel_translate(quo(grepl(pattern = "hello", x = a)), df),
    rel_translate(quo(grepl("hello", a)), df)
  )

  # grepl with reordered named arguments
  expect_identical(
    rel_translate(quo(grepl(x = a, pattern = "hello")), df),
    rel_translate(quo(grepl("hello", a)), df)
  )

  # sub with named arguments
  expect_identical(
    rel_translate(quo(sub(pattern = "hello", replacement = "bye", x = a)), df),
    rel_translate(quo(sub("hello", "bye", a)), df)
  )

  # sub with reordered named arguments
  expect_identical(
    rel_translate(quo(sub(x = a, replacement = "bye", pattern = "hello")), df),
    rel_translate(quo(sub("hello", "bye", a)), df)
  )

  # gsub with named arguments
  expect_identical(
    rel_translate(quo(gsub(pattern = "l", replacement = "r", x = a)), df),
    rel_translate(quo(gsub("l", "r", a)), df)
  )

  # gsub with reordered named arguments
  expect_identical(
    rel_translate(quo(gsub(x = a, pattern = "l", replacement = "r")), df),
    rel_translate(quo(gsub("l", "r", a)), df)
  )
})

test_that("lag/lead with named arguments", {
  df <- data.frame(a = 1:5)

  # lag with named x
  expect_identical(
    rel_translate(quo(lag(x = a)), df, need_window = TRUE),
    rel_translate(quo(lag(a)), df, need_window = TRUE)
  )

  # lag with named n
  expect_identical(
    rel_translate(quo(lag(a, n = 2L)), df, need_window = TRUE),
    rel_translate(quo(lag(a, 2L)), df, need_window = TRUE)
  )

  # lead with named x
  expect_identical(
    rel_translate(quo(lead(x = a)), df, need_window = TRUE),
    rel_translate(quo(lead(a)), df, need_window = TRUE)
  )

  # lead with named n
  expect_identical(
    rel_translate(quo(lead(a, n = 3L)), df, need_window = TRUE),
    rel_translate(quo(lead(a, 3L)), df, need_window = TRUE)
  )
})

test_that("strftime with named arguments", {
  df <- data.frame(a = as.Date("2024-01-01"))

  # strftime with reordered named arguments
  expect_identical(
    rel_translate(quo(strftime(format = "%Y", x = a)), df),
    rel_translate(quo(strftime(a, "%Y")), df)
  )
})

test_that("coalesce with two arguments works", {
  df <- data.frame(a = c(1, NA), b = c(NA, 2))

  # coalesce uses positional args (via ...) and translates correctly
  expect_snapshot({
    rel_translate(quo(coalesce(a, b)), df)
  })
})
