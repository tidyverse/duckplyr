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
  df <- data.frame(a = 1L)
  expect_snapshot(
    error = FALSE,
    rel_translate(quo(a > 123L), df)
  )
})
