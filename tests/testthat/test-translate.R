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
