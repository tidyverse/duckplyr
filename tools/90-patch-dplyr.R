library(tidyverse)

source("tools/00-funs.R", echo = TRUE)

status <- gert::git_status(repo = "../dplyr")
stopifnot(nrow(status) == 0)

names <- df_methods$name[!df_methods$skip_impl]
call_rx <- rex::rex(
  capture(or(names)) %if_prev_is% "\n",
  ".data.frame",
  capture(" <- function(")
)

dplyr_files <- fs::dir_ls("../dplyr/R")

dplyr_texts <- map_chr(dplyr_files, brio::read_file)
dplyr_texts <- str_replace_all(dplyr_texts, call_rx, "\\1_data_frame\\2")
walk2(dplyr_texts, dplyr_files, brio::write_file)

forbidden <- fs::path("R", c("dplyr.R", "zzz.R", "duckplyr-package.R"))
duckplyr_files <- setdiff(fs::dir_ls("R"), forbidden)
duckplyr_texts <- map_chr(duckplyr_files, brio::read_file)
duckplyr_texts <- str_replace_all(duckplyr_texts, "dplyr:::([a-z_]+)[.]data[.]frame", "\\1_data_frame")
duckplyr_texts <- str_replace_all(duckplyr_texts, fixed(".duckplyr_df <- function("), ".data.frame <- function(")
# Write as single file
brio::write_lines(duckplyr_texts, "../dplyr/R/zzz-duckplyr.R")
