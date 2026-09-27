test_that("rel_try() with reason", {
  withr::local_envvar(DUCKPLYR_FALLBACK_INFO = TRUE, DUCKPLYR_FORCE = FALSE)

  expect_snapshot({
    rel_try(
      NULL,
      "Not affected: {.code FALSE}" = FALSE,
      "Affected: {.code TRUE}" = TRUE,
      {}
    )
  })
})

test_that("rel_try() returns the reason in dplyr mode", {
  ns <- asNamespace("duckplyr")
  unlockBinding("dplyr_mode", ns)
  on.exit(lockBinding("dplyr_mode", ns), add = TRUE)
  assign("dplyr_mode", TRUE, envir = ns)

  out <- rel_try(NULL, "Affected: {.code TRUE}" = TRUE, {})
  expect_identical(out, "Affected: {.code TRUE}")
})
