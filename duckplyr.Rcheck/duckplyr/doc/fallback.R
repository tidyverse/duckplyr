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
  eval = identical(Sys.getenv("IN_PKGDOWN"), "true") || (getRversion() >= "4.1" && rlang::is_installed(c("conflicted", "dbplyr", "nycflights13"))),
  comment = "#>"
)

options(conflicts.policy = list(warn = FALSE))

Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 0)

## ----attach-------------------------------------------------------------------
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")

## -----------------------------------------------------------------------------
duckdb <-
  duckplyr::duckdb_tibble(a = 1:3) |>
  arrange(desc(a)) |>
  mutate(b = a + 1) |>
  select(-a)

## -----------------------------------------------------------------------------
duckdb |>
  explain()

## -----------------------------------------------------------------------------
duckplyr::last_rel()

## -----------------------------------------------------------------------------
duckdb |> collect()
duckplyr::last_rel()

## -----------------------------------------------------------------------------
verbose_plus_one <- function(x) {
  message("Adding one to ", paste(x, collapse = ", "))
  x + 1
}

fallback <-
  duckplyr::duckdb_tibble(a = 1:3) |>
  arrange(desc(a)) |>
  mutate(b = verbose_plus_one(a)) |>
  select(-a)

## -----------------------------------------------------------------------------
duckplyr::last_rel()

## -----------------------------------------------------------------------------
fallback |>
  explain()

## -----------------------------------------------------------------------------
fallback |> collect()

duckplyr::last_rel()

