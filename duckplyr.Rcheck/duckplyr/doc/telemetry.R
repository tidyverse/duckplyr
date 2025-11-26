## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = identical(Sys.getenv("IN_PKGDOWN"), "true") || (getRversion() >= "4.1" && rlang::is_installed(c("conflicted", "nycflights13"))),
  comment = "#>"
)

Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 0)

options(conflicts.policy = list(warn = FALSE))

## ----attach-------------------------------------------------------------------
library(conflicted)
library(duckplyr)
conflict_prefer("filter", "dplyr")

## ----include = FALSE----------------------------------------------------------
Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = "")
Sys.setenv(DUCKPLYR_FALLBACK_AUTOUPLOAD = "")
fallback_purge()

## -----------------------------------------------------------------------------
Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)
out <-
  flights_df() |>
  summarize(.by = origin, paste(dest, collapse = " "))

## ----echo = FALSE-------------------------------------------------------------
duckplyr:::fallback_autoupload()

