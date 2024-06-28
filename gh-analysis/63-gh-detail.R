library(tidyverse)

file_info <- fs::dir_info("gh-analysis/data/analyzed")
files <-
  file_info |>
  pull(path)

data <- bind_rows(purrr::map(files, qs::qread, .progress = TRUE))

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

data_expr_funs <-
  data |>
  mutate(expr_funs = map(call, get_calls, .progress = TRUE)) |>
  mutate(expr_funs_sorted = map_chr(expr_funs, ~ paste(sort(.x), collapse = " ")))

# Check variability of expression functions
data_expr_funs |>
  count(expr_funs_sorted, sort = TRUE) |>
  mutate(prop = n / sum(n), cum_prop = cumsum(prop)) |>
  view()

result_base <-
  data_expr_funs |>
  select(id, expr_funs) |>
  unnest(expr_funs) |>
  filter(!(expr_funs %in% c("mutate", "filter", "summarise", "summarize", "dplyr::mutate", "dplyr::filter", "dplyr::summarise", "dplyr::summarize")))

result <-
  result_base |>
  count(expr_funs, sort = TRUE) |>
  mutate(prop = n / sum(n), cum_prop = cumsum(prop))

result |>
  view()

expr_unnested <-
  data_expr_funs |>
  transmute(expr = row_number(), funs = map(expr_funs, unique)) |>
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
