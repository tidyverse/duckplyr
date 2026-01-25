library(tidyverse)

files <- fs::dir_ls("gh-analysis/data/parsed")

fs::dir_create("gh-analysis/data/analyzed")

funs <- c("mutate", "filter", "summarise", "summarize")

get_dplyr_calls <- function(lang) {
  if (!is.call(lang)) {
    return(NULL)
  }

  out <- NULL
  for (arg in as.list(lang)[-1]) {
    if (!missing(arg)) {
      child <- get_dplyr_calls(arg)
      if (!is.null(child)) {
        out <- c(out, child)
      }
    }
  }
  if ((is.name(lang[[1]]) && as.character(lang[[1]]) %in% funs) ||
      (is.call(lang[[1]]) && lang[[1]][[1]] == "::" && lang[[1]][[2]] == "dplyr" && as.character(lang[[1]][[3]]) %in% funs)) {
    out <- c(out, list(lang))
  }
  out
}

get_dplyr_calls_exprs <- function(parsed) {
  parsed |>
    mutate(as_tibble(transpose(parsed))) |>
    select(id, result) |>
    unnest(result) |>
    mutate(calls = map(result, get_dplyr_calls)) |>
    select(-result) |>
    unnest(calls) |>
    rename(call = calls)
}

fs::dir_create("gh-analysis/data/analyzed")

for (file in files) {
  analyzed_file <- fs::path("gh-analysis/data/analyzed", fs::path_ext_set(fs::path_file(file), ".qs"))
  if (!fs::file_exists(analyzed_file)) {
    message(file)
    try({
      parsed <- qs2::qs_read(file)
      exprs <- get_dplyr_calls_exprs(parsed)
      print(nrow(exprs))
      qs2::qs_save(exprs, analyzed_file)
    })
  }
}
