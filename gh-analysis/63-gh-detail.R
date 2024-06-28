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

# Understand weird operators

result_base |>
  filter(expr_funs == "<other>$") |>
  count(id, sort = TRUE)

# # A tibble: 2,209 × 2
#    id                                           n
#    <chr>                                    <int>
#  1 73f21f2f970b64d2d11295c06028409a2058da17   151
#  2 812dcbe47f7d01b8ebaca8a9d7d9749649c40de9   137
#  3 b85cfb474698c3b99e05bcbedbefb7234ee7bbee   122
#  4 bdb638ebd6801755090ab43511f7c435d2ac71ed   108
#  5 94bd75ed00dbc023404095264eebe84800585eb4    83
#  6 d7c83f16df6fb8263260315b8c5e0f4f0eac3e43    78
#  7 e2b14bcbbf10d2067604aafb95634be2d307ca47    78
#  8 2cbb0d964a27676a704a80962fdf2b4928824e8d    70
#  9 203c1f04cbb676698d72ca71f0fee73715734651    69
# 10 a8849b4ffec4deca987d0a437c2e5aff08919a64    56
