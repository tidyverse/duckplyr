test_that("rel_try() with reason", {
  withr::local_envvar(DUCKPLYR_FALLBACK_INFO = TRUE, DUCKPLYR_FORCE = FALSE)

  expect_snapshot({
    rel_try(
      "Not affected" = FALSE,
      "Affected" = TRUE,
      {
      }
    )
  })
})

test_that("inline parens (3)", {
  df <- data.frame(a = 1, b = 2)
  expect_identical(
    rel_translate(quo((a) * (b)), df),
    rel_translate(quo((a * b)), df),
  )
})

test_that("division by zero", {
  df <- data.frame(a = 0, b = 0)
  expect_identical(
    duckplyr_mutate(df, c = a / b),
    mutate(df, c = a / b),
  )
})

test_that("transmute() with special column names", {
  df <- data.frame(row = 1)
  expect_identical(
    duckplyr_transmute(df, row),
    transmute(df, row),
  )
})
