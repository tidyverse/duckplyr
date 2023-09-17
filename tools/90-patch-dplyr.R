library(tidyverse)

source("tools/00-funs.R", echo = TRUE)

stopifnot(gert::git_branch(repo = ".sync/dplyr-revdep") == "f-revdep-duckplyr")

status <- gert::git_status(repo = ".sync/dplyr-revdep")
stopifnot(nrow(status) == 0)

gert::git_pull(repo = ".sync/dplyr-revdep")

names <- df_methods$name[!df_methods$skip_impl]
call_rx <- rex::rex(
  capture(or(names)) %if_prev_is% "\n",
  ".data.frame",
  capture(" <- function(")
)

dplyr_files <- fs::dir_ls(".sync/dplyr-revdep/R")

dplyr_texts <- map_chr(dplyr_files, brio::read_file)
dplyr_texts <- str_replace_all(dplyr_texts, call_rx, "\\1_data_frame\\2")
walk2(dplyr_texts, dplyr_files, brio::write_file)

forbidden <- fs::path("R", c(
  "dplyr.R",
  "zzz.R",
  "zzz-methods.R",
  "duckplyr-package.R",
  "head.R",
  "meta.R",
  "overwrite.R",
  "qs.R",
  "relational-altrep-wrap.R",
  "restore.R",
  "tpch.R",
  "tpch2.R",
  sprintf("tpch_raw_%.2d.R", 1:22),
  sprintf("tpch_raw_oo_%.2d.R", 1:22),
  NULL
))
duckplyr_files <- setdiff(fs::dir_ls("R"), forbidden)
duckplyr_texts <- map_chr(duckplyr_files, brio::read_file)
duckplyr_texts <- str_replace_all(duckplyr_texts, "dplyr:::([a-z_]+)[.]data[.]frame", "\\1_data_frame")
duckplyr_texts <- str_replace_all(duckplyr_texts, fixed(".duckplyr_df <- function("), ".data.frame <- function(")
# Write as single file
brio::write_lines(duckplyr_texts, ".sync/dplyr-revdep/R/zzz-duckplyr.R")

patch_dplyr_test <- function(file) {
  base <- basename(file)

  all_tests <- c(duckplyr_tests, dplyr_only_tests)

  if (!(base %in% names(all_tests))) {
    return()
  }

  skip_todo <- unlist(all_tests[names(all_tests) == base])

  text <- brio::read_lines(file)
  text <- text[grep('skip("TODO duckdb")', text, invert = TRUE, fixed = TRUE)]
  if (!is.null(skip_todo)) {
    skip_todo_lines <- unique(unlist(map(paste0('"', skip_todo, '"'), grep, text, fixed = TRUE)))
    text[skip_todo_lines] <- paste0(text[skip_todo_lines], '\n  skip("TODO duckdb")')
  }
  brio::write_lines(text, file)
}

dplyr_test_files <- fs::dir_ls(".sync/dplyr-revdep/tests/testthat/", type = "file", glob = "*.R")
walk(dplyr_test_files, patch_dplyr_test)

gert::git_add(".", repo = ".sync/dplyr-revdep")
gert::git_commit("Sync", repo = ".sync/dplyr-revdep")
gert::git_push(repo = ".sync/dplyr-revdep")
