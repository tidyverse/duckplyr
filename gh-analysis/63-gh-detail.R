pkgload::load_all()
library(tidyverse)

file_info <- fs::dir_info("gh/analyzed")
files <-
  file_info |>
  filter(size > 0) |>
  pull(path)

data <- unlist(purrr::map(files, qs::qread, .progress = TRUE))

get_calls <- function(lang) {
  if (!is.call(lang)) {
    return(NULL)
  }

  out <- NULL
  for (arg in as.list(lang)[-1]) {
    if (!missing(arg)) {
      child <- get_calls(arg)
      if (!is.null(child)) {
        out <- c(out, child)
      }
    }
  }
  if (lang[[1]] == "$") {
    if (lang[[2]] == ".data") {
      out <- c(out, ".data$")
    } else if (lang[[2]] == ".env") {
      out <- c(out, ".env$")
    } else if (lang[[2]] == ".") {
      out <- c(out, ".$")
    } else {
      out <- c(out, "<other>$")
    }
  } else if (is.name(lang[[1]])) {
    out <- c(out, deparse(lang[[1]]))
  } else if (is.call(lang[[1]]) && lang[[1]][[1]] == "::") {
    out <- c(out, deparse(lang[[1]][[3]]))
  }
  out
}

expr_funs <- purrr::map(data, get_calls, .progress = TRUE)

expr_funs_sorted <- purrr::map_chr(expr_funs, ~ paste(sort(.x), collapse = " "))

tibble(expr_funs_sorted) |>
  count(expr_funs_sorted, sort = TRUE) |>
  mutate(prop = n / sum(n), cum_prop = cumsum(prop)) |>
  view()

calls <- unlist(expr_funs)

result <-
  tibble(calls) |>
  filter(!(calls %in% c("mutate", "filter", "summarise", "summarize", "dplyr::mutate", "dplyr::filter", "dplyr::summarise", "dplyr::summarize"))) |>
  count(calls, sort = TRUE) |>
  mutate(prop = n / sum(n), cum_prop = cumsum(prop))

result |>
  view()

expr_unnested <-
  tibble(expr = seq_along(expr_funs), funs = map(expr_funs, unique)) |>
  unnest(funs)

expr_result <-
  expr_unnested |>
  filter(!(funs %in% c("mutate", "filter", "summarise", "summarize", "dplyr::mutate", "dplyr::filter", "dplyr::summarise", "dplyr::summarize"))) |>
  mutate(n = n(), .by = funs) |>
  arrange(
    # funs %in% c("<other>$", "[", "factor", "replace", ":", "as.numeric", "as.character", "paste", "round", "group_by", "paste0", "length"),
    desc(n)
  ) |>
  mutate(funs = forcats::fct_inorder(funs)) |>
  mutate(idx_expr = n() - row_number(), .by = expr) |>
  mutate(has_all = (idx_expr == 0)) |>
  summarize(.by = funs, expr_done = sum(has_all)) |>
  mutate(pct_done = expr_done / sum(expr_done), cum_pct_done = cumsum(pct_done))

expr_result |>
  view()
