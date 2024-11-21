test_that("fallback_sitrep() default", {
  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = "fallback/log/dir",
    "DUCKPLYR_TELEMETRY_FALLBACK_LOGS" = ""
  ))

  expect_snapshot({
    fallback_sitrep()
  })
})

test_that("fallback_sitrep() enabled", {
  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) TRUE
  )
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = "fallback/log/dir",
    "DUCKPLYR_TELEMETRY_FALLBACK_LOGS" = "1,2,3"
  ))

  expect_snapshot({
    fallback_sitrep()
  })
})

test_that("fallback_sitrep() enabled silent", {
  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) FALSE,
    fallback_reporting_opted_in = function(...) TRUE
  )
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = "fallback/log/dir",
    "DUCKPLYR_TELEMETRY_FALLBACK_LOGS" = "1,2,3"
  ))

  expect_snapshot({
    fallback_sitrep()
  })
})

test_that("fallback_sitrep() disabled", {
  local_mocked_bindings(
    fallback_logging_opted_out = function(...) TRUE,
    fallback_verbose_opted_in = function(...) FALSE,
    fallback_reporting_opted_in = function(...) FALSE
  )
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = "fallback/log/dir",
    "DUCKPLYR_TELEMETRY_FALLBACK_LOGS" = "1,2,3"
  ))

  expect_snapshot({
    fallback_sitrep()
  })
})

test_that("summarize()", {
  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    tibble(a = 1, b = 2, c = 3) %>%
      as_duckplyr_df() %>%
      summarize(
        .by = a,
        e = sum(b),
        f = sum(e)
      )
  })
})

test_that("wday()", {
  skip_if_not_installed("lubridate")

  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    tibble(a = as.Date("2024-03-08")) %>%
      as_duckplyr_df() %>%
      mutate(
        b = lubridate::wday(a, label = TRUE)
      )
  })

  local_options(lubridate.week.start = 1)

  expect_snapshot({
    tibble(a = as.Date("2024-03-08")) %>%
      as_duckplyr_df() %>%
      mutate(
        b = lubridate::wday(a)
      )
  })
})

test_that("strftime()", {
  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    tibble(a = as.Date("2024-03-08")) %>%
      as_duckplyr_df() %>%
      mutate(
        b = strftime(a, format = "%Y-%m-%d", tz = "CET")
      )
  })
})

test_that("$", {
  skip_if_not(getRversion() >= "4.3")

  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot(error = TRUE, {
    tibble(a = 1, b = 2) %>%
      as_duckplyr_df() %>%
      mutate(c = .env$x)
  })
})

test_that("unknown function", {

  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  foo <- function(...) 3

  expect_snapshot({
    tibble(a = 1, b = 2) %>%
      as_duckplyr_df() %>%
      mutate(c = foo(a, b))
  })
})

test_that("row names", {

  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    mtcars[1:2, ] %>%
      as_duckplyr_df() %>%
      select(mpg, cyl)
  })
})

test_that("named column", {

  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    tibble(a = c(x = 1)) %>%
      as_duckplyr_df() %>%
      select(a)
  })
})

test_that("named column", {

  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    tibble(a = matrix(1:4, ncol = 2)) %>%
      as_duckplyr_df() %>%
      select(a)
  })
})

test_that("list column", {

  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    tibble(a = 1, b = 2, c = list(3)) %>%
      as_duckplyr_df() %>%
      select(a, b)
  })
})

test_that("__row_number", {

  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot({
    tibble(`___row_number` = 1, b = 2:3) %>%
      as_duckplyr_df() %>%
      arrange(b)
  })
})

test_that("rel_try()", {
  local_mocked_bindings(
    fallback_logging_opted_out = function(...) FALSE,
    fallback_verbose_opted_in = function(...) TRUE,
    fallback_reporting_opted_in = function(...) FALSE
  )

  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir(),
    "DUCKPLYR_OUTPUT_ORDER" = "TRUE"
  ))

  expect_snapshot({
    tibble(a = 1) %>%
      as_duckplyr_df() %>%
      count(a, .drop = FALSE, name = "n")
  })
})
