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

test_that("call with named argument", {
  expect_snapshot(error = TRUE, {
    rel_translate(quo(c(1, b = 2)))
  })
})
