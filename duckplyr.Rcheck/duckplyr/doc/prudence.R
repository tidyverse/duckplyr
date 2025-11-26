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
df <-
  duckplyr::duckdb_tibble(x = 1:3) |>
  mutate(y = x + 1)
df

class(df)

df$y

nrow(df)

## -----------------------------------------------------------------------------
flights <- duckplyr::flights_df()

flights_duckdb <-
  flights |>
  duckplyr::as_duckdb_tibble()

system.time(
  mean_arr_delay_ewr <-
    flights_duckdb |>
    filter(origin == "EWR", !is.na(arr_delay)) |>
    summarize(
      .by = month,
      mean_arr_delay = mean(arr_delay),
      min_arr_delay = min(arr_delay),
      max_arr_delay = max(arr_delay),
      median_arr_delay = median(arr_delay),
    )
)

## -----------------------------------------------------------------------------
mean_arr_delay_ewr |>
  explain()

## -----------------------------------------------------------------------------
system.time(mean_arr_delay_ewr$mean_arr_delay[[1]])

## -----------------------------------------------------------------------------
system.time(
  flights |>
    filter(origin == "EWR", !is.na(arr_delay)) |>
    summarize(
      .by = c(month, day),
      mean_arr_delay = mean(arr_delay),
      min_arr_delay = min(arr_delay),
      max_arr_delay = max(arr_delay),
      median_arr_delay = median(arr_delay),
    )
)

## -----------------------------------------------------------------------------
flights_stingy <-
  flights |>
  duckplyr::as_duckdb_tibble(prudence = "stingy")

## -----------------------------------------------------------------------------
flights_stingy

names(flights_stingy)[1:10]

class(flights_stingy)

class(flights_stingy[[1]])

## ----error = TRUE-------------------------------------------------------------
try({
nrow(flights_stingy)

flights_stingy[[1]]
})

## ----error = TRUE-------------------------------------------------------------
try({
flights_stingy |>
  group_by(origin) |>
  summarize(n = n()) |>
  ungroup()
})

## -----------------------------------------------------------------------------
flights_stingy |>
  duckplyr::as_duckdb_tibble(prudence = "lavish") |>
  group_by(origin) |>
  summarize(n = n()) |>
  ungroup()

## -----------------------------------------------------------------------------
flights_stingy |>
  duckplyr::as_duckdb_tibble(prudence = "lavish") |>
  class()

flights_stingy |>
  collect() |>
  class()

## -----------------------------------------------------------------------------
flights_stingy |>
  as_tibble() |>
  class()

flights_stingy |>
  as.data.frame() |>
  class()

## -----------------------------------------------------------------------------
nrow(flights)
flights_partial <-
  flights |>
  duckplyr::as_duckdb_tibble(prudence = "thrifty")

## ----error = TRUE-------------------------------------------------------------
try({
flights_partial |>
  select(origin, dest, dep_delay, arr_delay) |>
  nrow()
})

## -----------------------------------------------------------------------------
flights_partial |>
  count(origin) |>
  nrow()

