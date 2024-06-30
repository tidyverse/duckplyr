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
