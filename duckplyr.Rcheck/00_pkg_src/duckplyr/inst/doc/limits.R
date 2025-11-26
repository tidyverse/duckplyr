## ----include = FALSE----------------------------------------------------------
clean_output <- function(x, options) {
  x <- gsub("0x[0-9a-f]+", "0xdeadbeef", x)
  x <- gsub("dataframe_[0-9]*_[0-9]*", "      dataframe_42_42      ", x)
  x <- gsub("[0-9]*\\.___row_number ASC", "42.___row_number ASC", x)
  x <- gsub("─", "-", x)
  x
}

local({
  hook_source <- knitr::knit_hooks$get("document")
  knitr::knit_hooks$set(document = clean_output)
})

knitr::opts_chunk$set(
  collapse = TRUE,
  eval = identical(Sys.getenv("IN_PKGDOWN"), "true") || (getRversion() >= "4.1" && rlang::is_installed(c("conflicted", "nycflights13", "lubridate"))),
  comment = "#>"
)

Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 0)

## ----attach-------------------------------------------------------------------
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(
  logical = TRUE,
  integer = 1L,
  numeric = 1.1,
  character = "a",
  Date = as.Date("2025-01-11"),
  POSIXct = as.POSIXct("2025-01-11 19:23:00", tz = "UTC"),
  difftime = as.difftime(1, units = "secs"),
) |>
  compute()

## ----error = TRUE-------------------------------------------------------------
try({
duckplyr::duckdb_tibble()
duckplyr::duckdb_tibble(a = 1, .prudence = "stingy") |>
  select(-a)
})

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1, b = 2, c = 3, .prudence = "stingy") |>
  mutate((a + b) * c)

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(
  a = c(1, 2, NA),
  b = c(2, NA, 3),
  c = c(NA, 3, 4),
  .prudence = "stingy"
) |>
  mutate(a > b, b != c, c < a, a >= b, b <= c)

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1, b = 2, c = 3, .prudence = "stingy") |>
  mutate(a + b, a / b, a - b, a * b)

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1, b = 2, c = -3, .prudence = "stingy") |>
  mutate(log10(a), log(b), abs(c))

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = FALSE, b = TRUE, c = NA, .prudence = "stingy") |>
  mutate(!a, a & b, b | c)

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1, b = NA, .prudence = "stingy") |>
  mutate(is.na(b), if_else(is.na(b), 0, 1), as.integer(b))

duckplyr::duckdb_tibble(
  a = as.POSIXct("2025-01-11 19:23:46", tz = "UTC"),
  .prudence = "stingy") |>
  mutate(strftime(a, "%H:%M:%S"))

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = "abbc", .prudence = "stingy") |>
  mutate(grepl("b", a), substr(a, 2L, 3L), sub("b", "B", a), gsub("b", "B", a))

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(
  a = as.POSIXct("2025-01-11 19:23:46", tz = "UTC"),
  .prudence = "stingy"
) |>
  mutate(
    hour = lubridate::hour(a),
    minute = lubridate::minute(a),
    second = lubridate::second(a),
    wday = lubridate::wday(a)
  )

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1:3, b = c(1, 2, 2), .prudence = "stingy") |>
  summarize(
    sum(a),
    n(),
    n_distinct(b),
  )

duckplyr::duckdb_tibble(a = 1:3, b = c(1, 2, NA), .prudence = "stingy") |>
  summarize(
    mean(b, na.rm = TRUE),
    median(a),
    sd(b),
  )

duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  summarize(
    min(a),
    max(a),
    any(a > 1),
    all(a > 1),
  )

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  mutate(lag(a), lead(a))
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  mutate(lag(a, 2), lead(a, n = 2))
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  mutate(lag(a, default = 0), lead(a, default = 4))
duckplyr::duckdb_tibble(a = 1:3, b = c(2, 3, 1), .prudence = "stingy") |>
  mutate(lag(a, order_by = b), lead(a, order_by = b))

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = c(1, 2, 2, 3), .prudence = "stingy") |>
  mutate(row_number())

## -----------------------------------------------------------------------------
b <- 4
duckplyr::duckdb_tibble(a = 1, b = 2, .prudence = "stingy") |>
  mutate(.data$a + .data$b, .env$b)

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  mutate(a %in% c(1, 3)) |>
  collect()
duckplyr::last_rel()

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  arrange(desc(a)) |>
  explain()

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1, .prudence = "stingy") |>
  mutate(suppressWarnings(a + 1))

## -----------------------------------------------------------------------------
duckplyr::flights_df() |>
  duckplyr::as_duckdb_tibble() |>
  distinct(day) |>
  summarize(paste(day, collapse = " ")) # fallback

duckplyr::flights_df() |>
  distinct(day) |>
  summarize(paste(day, collapse = " "))

## -----------------------------------------------------------------------------
duckplyr::flights_df() |>
  duckplyr::as_duckdb_tibble() |>
  distinct(day) |>
  explain()

withr::with_envvar(
  c(DUCKPLYR_OUTPUT_ORDER = "TRUE"),
  duckplyr::flights_df() |>
    duckplyr::as_duckdb_tibble() |>
    distinct(day) |>
    explain()
)

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = 1:100) |>
  summarize(sum(a))

duckplyr::duckdb_tibble(a = 1:1000000) |>
  summarize(sum(a))

tibble(a = 1:100) |>
  summarize(sum(a))

tibble(a = 1:1000000) |>
  summarize(sum(a))

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = integer(), b = logical()) |>
  summarize(sum(a), any(b), all(b), min(a), max(a))
tibble(a = integer(), b = logical()) |>
  summarize(sum(a), any(b), all(b), min(a), max(a))

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = c(TRUE, FALSE)) |>
  summarize(min(a), max(a))

tibble(a = c(TRUE, FALSE)) |>
  summarize(min(a), max(a))

## -----------------------------------------------------------------------------
duckplyr::duckdb_tibble(a = c(NA, NaN)) |>
  mutate(is.na(a))

tibble(a = c(NA, NaN)) |>
  mutate(is.na(a))

