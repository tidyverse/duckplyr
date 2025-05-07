test_that("fallback_sitrep() default", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "",
    "DUCKPLYR_FALLBACK_INFO" = "",
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
    "DUCKPLYR_FALLBACK_INFO" = "",
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
    "DUCKPLYR_FALLBACK_INFO" = "TRUE",
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
    duckdb_tibble(a = 1, b = 2, c = 3) %>%
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
    duckdb_tibble(a = as.Date("2024-03-08")) %>%
      mutate(
        b = lubridate::wday(a, label = TRUE)
      )
  })

  local_options(lubridate.week.start = 1)

  expect_snapshot({
    duckdb_tibble(a = as.Date("2024-03-08")) %>%
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
    duckdb_tibble(a = as.Date("2024-03-08")) %>%
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
    duckdb_tibble(a = 1, b = 2) %>%
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
    duckdb_tibble(a = 1, b = 2) %>%
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
      as_duckdb_tibble() %>%
      select(mpg, cyl)
  })
})

test_that("named column", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = c(x = 1))
  })
})

test_that("named column", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = "1",
    "DUCKPLYR_FALLBACK_VERBOSE" = "TRUE",
    "DUCKPLYR_FALLBACK_LOG_DIR" = tempdir()
  ))

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = matrix(1:4, ncol = 2))
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
    duckdb_tibble(`___row_number` = 1, b = 2:3) %>%
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
    duckdb_tibble(a = 1) %>%
      count(a, .drop = FALSE, name = "n")
  })
})

test_that("fallback_config()", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = NA_character_,
    "DUCKPLYR_FALLBACK_INFO" = NA_character_,
    "DUCKPLYR_FALLBACK_LOGGING" = NA_character_,
    "DUCKPLYR_FALLBACK_AUTOUPLOAD" = NA_character_,
    "DUCKPLYR_FALLBACK_LOG_DIR" = NA_character_,
    "DUCKPLYR_FALLBACK_VERBOSE" = NA_character_
  ))

  config_path <- "fallback.dcf"
  local_mocked_bindings(fallback_config_path = function() config_path)

  expect_identical(fallback_config_read(), list())

  fallback_config(info = TRUE, logging = TRUE, autoupload = TRUE, log_dir = "/", verbose = TRUE)
  expect_snapshot_file(config_path, "fallback.dcf")

  expect_snapshot({
    "No conflicts"
    fallback_config_load()
  })

  expect_snapshot({
    "Reset and set config"
    fallback_config(reset_all = TRUE, logging = FALSE)
  })
  expect_snapshot_file(config_path, "fallback-2.dcf")

  withr::local_envvar(c(
    DUCKPLYR_FALLBACK_LOGGING = 1
  ))
  expect_snapshot({
    "Conflicts with environment variable and setting"
    fallback_config_load()
  })

  expect_snapshot({
    "Reset config"
    fallback_config(reset_all = TRUE)
  })
  expect_false(file.exists(config_path))

  expect_snapshot(error = TRUE, {
    fallback_config(boo = FALSE)
  })
})

test_that("fallback_config() failure", {
  withr::local_envvar(c(
    "DUCKPLYR_FALLBACK_COLLECT" = NA_character_,
    "DUCKPLYR_FALLBACK_INFO" = NA_character_,
    "DUCKPLYR_FALLBACK_AUTOUPLOAD" = NA_character_,
    "DUCKPLYR_FALLBACK_LOG_DIR" = NA_character_,
    "DUCKPLYR_FALLBACK_VERBOSE" = NA_character_
  ))

  config_path <- withr::local_tempfile(lines = "boo")
  local_mocked_bindings(fallback_config_path = function() config_path)

  writeLines("boo", config_path)

  expect_snapshot({
    fallback_config_load()
  })

  expect_false(file.exists(config_path))

  expect_snapshot({
    fallback_config_load()
  })
})
