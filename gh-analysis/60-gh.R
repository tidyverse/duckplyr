library(tidyverse)
library(DBI)
library(withr)
library(rlang)

con <- dbConnect(duckdb::duckdb())
DBI::dbExecute(con, "set memory_limit='8GB'")
DBI::dbExecute(con, paste0("pragma temp_directory='", tempdir(), "'"))

contents <- duckdb::tbl_query(con, "'gh-analysis/data/r_contents-*.parquet'")

local_db_result <- function(res, .local_envir = parent.frame()) {
  requireNamespace("DBI", quietly = TRUE)
  stopifnot(methods::is(res, "DBIResult"))
  defer(DBI::dbClearResult(res), envir = .local_envir)
  res
}

rowwise_map <- function(.data, .f, .progress = FALSE) {
  .f <- as_function(.f)
  sql <- dbplyr::sql_render(.data)
  con <- dbplyr::remote_con(.data)

  res <- local_db_result(dbSendQuery(con, sql))

  out <- list()

  if (.progress) {
    message("Processing", appendLF = FALSE)
  }

  while (!dbHasCompleted(res)) {
    if (.progress) {
      message(".", appendLF = FALSE)
    }
    chunk <- dbFetch(res, n = 1)
    if (nrow(chunk) == 0) break
    out <- c(out, list(.f(as_tibble(chunk))))
  }

  if (.progress) {
    message("")
  }

  out
}

rowwise_walk <- function(.data, .f, .progress = FALSE) {
  .f <- as_function(.f)
  walker <- function(.x) {
    .f(.x)
    NULL
  }
  rowwise_map(.data, walker, .progress)
  invisible(.data)
}

blob_decode <- function(content) {
  if (is.null(content)) return("")
  stopifnot(is.raw(content))
  # Substitute embedded NUL with newlines
  content[content == 0] <- as.raw(10)
  rawToChar(content)
}

write_parsed <- function(x) {
  path <- fs::path("gh-analysis/data/parsed", paste0(x$two, ".qs"))
  if (fs::file_exists(path)) {
    return()
  }

  packed <- x$packed[[1]] |>
    arrange(id) |>
    mutate(content = map_chr(content, blob_decode)) |>
    mutate(parsed = map(content, safely(rlang::parse_exprs))) |>
    select(id, parsed) |>
    as_tibble()

  qs::qsave(packed, path)
}

fs::dir_create("gh-analysis/data/parsed")

contents |>
  mutate(two = substr(id, 1, 2)) |>
  filter(!binary) |>
  mutate(content = ENCODE(content)) |>
  summarize(packed = LIST(STRUCT_PACK(id, content)), .by = two) |>
  arrange(two) |>
  rowwise_walk(write_parsed, .progress = TRUE)
