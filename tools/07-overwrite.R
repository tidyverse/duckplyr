source("tools/00-funs.R", echo = TRUE)

overwrite_body <-
  df_methods |>
  filter(!skip_impl) |>
  summarize(body = paste0(
    '  vctrs::s3_register("dplyr::', name, '", "data.frame", ', name, ".duckplyr_df)",
    collapse = "\n"
  )) |>
  pull()

overwrite_fun <- paste0("#' @export\nmethods_overwrite <- function() {\n", overwrite_body, "\n}\n")
brio::write_file(overwrite_fun, "R/overwrite.R")


restore_body <-
  df_methods |>
  filter(!skip_impl) |>
  summarize(body = paste0(
    '  vctrs::s3_register("dplyr::', name, '", "data.frame", dplyr:::', name, ".data.frame)",
    collapse = "\n"
  )) |>
  pull()

restore_fun <- paste0("#' @export\nmethods_restore <- function() {\n", restore_body, "\n}\n")
brio::write_file(restore_fun, "R/restore.R")
