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
