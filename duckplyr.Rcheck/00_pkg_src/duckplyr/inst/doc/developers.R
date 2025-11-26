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
  eval = identical(Sys.getenv("IN_PKGDOWN"), "true") || (getRversion() >= "4.1" && rlang::is_installed(c("conflicted", "nycflights13"))),
  comment = "#>"
)

Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 0)

## ----attach-------------------------------------------------------------------
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")

## -----------------------------------------------------------------------------
lazy <-
  duckplyr::flights_df() |>
  duckplyr::as_duckdb_tibble() |>
  mutate(inflight_delay = arr_delay - dep_delay) |>
  summarize(
    .by = c(year, month),
    mean_inflight_delay = mean(inflight_delay, na.rm = TRUE),
    median_inflight_delay = median(inflight_delay, na.rm = TRUE),
  ) |>
  filter(month <= 6)

## -----------------------------------------------------------------------------
class(lazy)

names(lazy)

## -----------------------------------------------------------------------------
lazy |>
  explain()

## -----------------------------------------------------------------------------
lazy$mean_inflight_delay

## -----------------------------------------------------------------------------
lazy

## -----------------------------------------------------------------------------
library(duckplyr)

methods_restore()

## ----error = TRUE-------------------------------------------------------------
try({
flights_df() |>
  mutate(inflight_delay = arr_delay - dep_delay) |>
  explain()
})

## -----------------------------------------------------------------------------
data <- duckdb_tibble(
  x = 1:3,
  y = 5,
  z = letters[1:3]
)
data

