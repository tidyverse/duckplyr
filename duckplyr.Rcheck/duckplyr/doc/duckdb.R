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
  eval = identical(Sys.getenv("IN_PKGDOWN"), "true") || (getRversion() >= "4.1" && rlang::is_installed(c("conflicted", "dbplyr", "nycflights13", "callr")) && duckplyr:::can_load_extension("httpfs")),
  comment = "#>"
)

options(conflicts.policy = list(warn = FALSE))

Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 0)

## ----attach-------------------------------------------------------------------
# library(conflicted)
# library(duckplyr)
# conflict_prefer("filter", "dplyr")

## -----------------------------------------------------------------------------
# df <- duckdb_tibble(a = 2L)
# df
# 
# tbl <- as_tbl(df)
# tbl

## -----------------------------------------------------------------------------
# tbl %>%
#   mutate(b = sql("a + 1"), c = least_common_multiple(a, b)) %>%
#   show_query()

## ----error = TRUE-------------------------------------------------------------
try({
# least_common_multiple(2, 3)
})

## -----------------------------------------------------------------------------
# tbl %>%
#   mutate(b = sql("a + 1"), c = least_common_multiple(a, b))

## -----------------------------------------------------------------------------
# tbl %>%
#   mutate(b = sql("a + 1"), c = least_common_multiple(a, b)) %>%
#   as_duckdb_tibble()

## -----------------------------------------------------------------------------
# duckdb_tibble(a = 2L, b = 3L) %>%
#   mutate(c = dd$least_common_multiple(a, b))

## -----------------------------------------------------------------------------
# duckdb_tibble(a = "dbplyr", b = "duckplyr") %>%
#   mutate(c = dd$damerau_levenshtein(a, b))

