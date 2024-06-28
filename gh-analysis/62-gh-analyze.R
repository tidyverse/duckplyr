library(tidyverse)
pkgload::load_all()

files <- fs::dir_ls("gh/parsed")

fs::dir_create("gh/analyzed")

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

get_dplyr_calls_exprs <- function(exprs) {
  exprs |>
    as.list() |>
    map(get_dplyr_calls) |>
    compact() |>
    unlist()
}

fs::dir_create("gh/analyzed")

for (file in files) {
  analyzed_file <- fs::path("gh/analyzed", fs::path_ext_set(fs::path_file(file), ".qs"))
  if (!fs::file_exists(analyzed_file)) {
    message(file)
    try({
      parsed <- qs::qread(file)
      exprs <- get_dplyr_calls_exprs(parsed)
      if (length(exprs) == 0) {
        writeLines(character(), analyzed_file)
      } else {
        print(length(exprs))
        qs::qsave(exprs, analyzed_file)
      }
    })
  }
}
