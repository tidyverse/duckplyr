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

test_that("summarize()", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    duck_tbl(a = 1, b = 2, c = 3) %>%
      summarize(
        .by = a,
        e = sum(b),
        f = sum(e)
      )
  })
})

test_that("wday()", {
  skip_if_not_installed("lubridate")

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    duck_tbl(a = as.Date("2024-03-08")) %>%
      mutate(
        b = lubridate::wday(a, label = TRUE)
      )
  })

  local_options(lubridate.week.start = 1)

  expect_snapshot({
    duck_tbl(a = as.Date("2024-03-08")) %>%
      mutate(
        b = lubridate::wday(a)
      )
  })
})

test_that("strftime()", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    duck_tbl(a = as.Date("2024-03-08")) %>%
      mutate(
        b = strftime(a, format = "%Y-%m-%d", tz = "CET")
      )
  })
})

test_that("$", {
  skip_if_not(getRversion() >= "4.3")

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot(error = TRUE, {
    duck_tbl(a = 1, b = 2) %>%
      mutate(c = .env$x)
  })
})

test_that("unknown function", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  foo <- function(...) 3

  expect_snapshot({
    duck_tbl(a = 1, b = 2) %>%
      mutate(c = foo(a, b))
  })
})

test_that("row names", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    mtcars[1:2, ] %>%
      as_duck_tbl() %>%
      select(mpg, cyl)
  })
})

test_that("named column", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    duck_tbl(a = c(x = 1)) %>%
      select(a)
  })
})

test_that("named column", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    duck_tbl(a = matrix(1:4, ncol = 2)) %>%
      select(a)
  })
})

test_that("list column", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    duck_tbl(a = 1, b = 2, c = list(3)) %>%
      select(a, b)
  })
})

test_that("__row_number", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir(),
    "DUCKPLYR_OUTPUT_ORDER" = "TRUE"
  ))

  expect_snapshot({
    duck_tbl(`___row_number` = 1, b = 2:3) %>%
      arrange(b)
  })
})

test_that("rel_try()", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir(),
    "DUCKPLYR_OUTPUT_ORDER" = "TRUE"
  ))

  expect_snapshot({
    duck_tbl(a = 1) %>%
      count(a, .drop = FALSE, name = "n")
  })
})
