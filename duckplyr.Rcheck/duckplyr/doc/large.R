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
# df <- duckdb_tibble(x = 1:3, y = letters[1:3])
# df

## -----------------------------------------------------------------------------
# flights_df() |>
#   as_duckdb_tibble()

## -----------------------------------------------------------------------------
# path_duckdb <- tempfile(fileext = ".duckdb")
# con <- DBI::dbConnect(duckdb::duckdb(path_duckdb))
# DBI::dbWriteTable(con, "data", data.frame(x = 1:3, y = letters[1:3]))
# 
# dbplyr_data <- tbl(con, "data")
# dbplyr_data
# 
# dbplyr_data |>
#   explain()

## -----------------------------------------------------------------------------
# dbplyr_data |>
#   as_duckdb_tibble()
# 
# dbplyr_data |>
#   as_duckdb_tibble() |>
#   explain()

## -----------------------------------------------------------------------------
# DBI::dbDisconnect(con)

## ----error = TRUE-------------------------------------------------------------
try({
# duckdb_tibble(a = 1) |>
#   group_by(a) |>
#   as_duckdb_tibble()
})

## ----error = TRUE-------------------------------------------------------------
try({
# duckdb_tibble(a = 1) |>
#   rowwise() |>
#   as_duckdb_tibble()
})

## ----error = TRUE-------------------------------------------------------------
try({
# readr::read_csv("a\n1", show_col_types = FALSE) |>
#   as_duckdb_tibble()
})

## -----------------------------------------------------------------------------
# path_csv_1 <- tempfile(fileext = ".csv")
# writeLines("x,y\n1,a\n2,b\n3,c", path_csv_1)
# read_csv_duckdb(path_csv_1)

## -----------------------------------------------------------------------------
# path_csv_2 <- tempfile(fileext = ".csv")
# writeLines("x,y\n4,d\n5,e\n6,f", path_csv_2)
# read_csv_duckdb(c(path_csv_1, path_csv_2))

## -----------------------------------------------------------------------------
# db_exec("INSTALL httpfs")
# db_exec("LOAD httpfs")

## -----------------------------------------------------------------------------
# url <- "https://blobs.duckdb.org/flight-data-partitioned/Year=2024/data_0.parquet"
# flights_parquet <- read_parquet_duckdb(url)
# flights_parquet

## -----------------------------------------------------------------------------
# sql_attach <- paste0(
#   "ATTACH DATABASE '",
#   path_duckdb,
#   "' AS external (READ_ONLY)"
# )
# db_exec(sql_attach)

## -----------------------------------------------------------------------------
# read_sql_duckdb("SELECT * FROM external.data")

## -----------------------------------------------------------------------------
# simple_data <-
#   duckdb_tibble(a = 1) |>
#   mutate(b = 2)
# 
# simple_data |>
#   explain()
# 
# simple_data_computed <-
#   simple_data |>
#   compute()

## -----------------------------------------------------------------------------
# simple_data_computed |>
#   explain()

## -----------------------------------------------------------------------------
# duckdb_tibble(a = 1) |>
#   mutate(b = 2) |>
#   collect()

## -----------------------------------------------------------------------------
# path_csv_out <- tempfile(fileext = ".csv")
# duckdb_tibble(a = 1) |>
#   mutate(b = 2) |>
#   compute_csv(path_csv_out)
# 
# writeLines(readLines(path_csv_out))

## -----------------------------------------------------------------------------
# path_parquet_out <- tempfile(fileext = ".parquet")
# duckdb_tibble(a = 1) |>
#   mutate(b = 2) |>
#   compute_parquet(path_parquet_out) |>
#   explain()

## -----------------------------------------------------------------------------
# read_sql_duckdb("SELECT current_setting('memory_limit') AS memlimit")
# 
# db_exec("PRAGMA memory_limit = '1GB'")
# 
# read_sql_duckdb("SELECT current_setting('memory_limit') AS memlimit")

## ----error = TRUE-------------------------------------------------------------
try({
# flights_parquet |>
#   group_by(Month)
})

## -----------------------------------------------------------------------------
# flights_parquet |>
#   count(Month, DayofMonth) |>
#   group_by(Month)

