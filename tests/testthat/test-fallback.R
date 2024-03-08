test_that("fallback_sitrep() default", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "",
    "DUCKPLYR_FALLBACK_VERBOSE" = "",
    "DUCKPLYR_FALLBACK_AUTOUPLOAD" = "",
    "DUCKPLYR_FALLBACK_LOG_DIR" = "fallback/log/dir",
    "DUCKPLYR_TELEMETRY_FALLBACK_LOGS" = ""
  ))

  expect_snapshot({
    fallback_sitrep()
  })
})

test_that("fallback_sitrep() enabled", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "",
    "DUCKPLYR_FALLBACK_AUTOUPLOAD" = "1",
    "DUCKPLYR_FALLBACK_LOG_DIR" = "fallback/log/dir",
    "DUCKPLYR_TELEMETRY_FALLBACK_LOGS" = "1,2,3"
  ))

  expect_snapshot({
    fallback_sitrep()
  })
})

test_that("fallback_sitrep() enabled silent", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "FALSE",
    "DUCKPLYR_FALLBACK_AUTOUPLOAD" = "1",
    "DUCKPLYR_FALLBACK_LOG_DIR" = "fallback/log/dir",
    "DUCKPLYR_TELEMETRY_FALLBACK_LOGS" = "1,2,3"
  ))

  expect_snapshot({
    fallback_sitrep()
  })
})

test_that("fallback_sitrep() disabled", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "0",
    "DUCKPLYR_FALLBACK_AUTOUPLOAD" = "0",
    "DUCKPLYR_FALLBACK_LOG_DIR" = "fallback/log/dir",
    "DUCKPLYR_TELEMETRY_FALLBACK_LOGS" = "1,2,3"
  ))

  expect_snapshot({
    fallback_sitrep()
  })
})

test_that("fallback_nudge()", {
  expect_snapshot({
    fallback_nudge("{foo:1, bar:2}")
  })
})
