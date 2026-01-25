library(tidyverse)

file_info <- fs::dir_info("gh-analysis/data/analyzed")
files <-
  file_info |>
  pull(path)

data <- bind_rows(purrr::map(files, qs2::qs_read, .progress = TRUE))

get_calls <- function(lang, ignore = NULL) {
  if (!is.call(lang)) {
    return(NULL)
  }

  out <- NULL

  if (identical(lang, quote(1:n()))) {
    # FIXME: Need to implement
    return("1:n()")
  }

  arg_list <- as.list(lang)[-1]
  if (lang[[1]] == "%in%") {
    # RHS of %in% is evaluated and does not need to be translated
    arg_list <- arg_list[1]
  }

  child_ignore <- ignore
  if (lang[[1]] == "case_when") {
    # Special semantics of ~ inside case_when()
    child_ignore <- c(child_ignore, "~")
  }

  for (arg in arg_list) {
    if (!missing(arg)) {
      child <- get_calls(arg, child_ignore)
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

  unique(setdiff(out, ignore))
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
  select(id, call, expr_funs) |>
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
  transmute(expr = row_number(), funs = expr_funs) |>
  unnest(funs)

expr_result <-
  expr_unnested |>
  filter(!(funs %in% c("mutate", "filter", "summarise", "summarize", "dplyr::mutate", "dplyr::filter", "dplyr::summarise", "dplyr::summarize"))) |>
  mutate(n = n(), .by = funs) |>
  arrange(desc(n)) |>
  mutate(funs = forcats::fct_inorder(funs)) |>
  mutate(idx_expr = n() - row_number(), .by = expr) |>
  mutate(has_all = (idx_expr == 0)) |>
  summarize(.by = funs, expr_done = sum(has_all)) |>
  mutate(pct_done = expr_done / sum(expr_done), cum_pct_done = cumsum(pct_done))

expr_result |>
  view()

expr_result_without_bad <-
  expr_unnested |>
  filter(!(funs %in% c("mutate", "filter", "summarise", "summarize", "dplyr::mutate", "dplyr::filter", "dplyr::summarise", "dplyr::summarize"))) |>
  mutate(n = n(), .by = funs) |>
  arrange(
    funs %in% c("<other>$", "[", "[[", ":", "~"),
    desc(n)
  ) |>
  mutate(funs = forcats::fct_inorder(funs)) |>
  mutate(idx_expr = n() - row_number(), .by = expr) |>
  mutate(has_all = (idx_expr == 0)) |>
  summarize(.by = funs, expr_done = sum(has_all)) |>
  mutate(pct_done = expr_done / sum(expr_done), cum_pct_done = cumsum(pct_done))

expr_result_without_bad |>
  view()

# Understand weird operators

result_base |>
  filter(expr_funs == "<other>$") |>
  count(id, sort = TRUE)

# # A tibble: 1,809 × 2
#    id                                           n
#    <chr>                                    <int>
#  1 b85cfb474698c3b99e05bcbedbefb7234ee7bbee   122
#  2 812dcbe47f7d01b8ebaca8a9d7d9749649c40de9    93
#  3 73f21f2f970b64d2d11295c06028409a2058da17    83
#  4 94bd75ed00dbc023404095264eebe84800585eb4    83
#  5 e2b14bcbbf10d2067604aafb95634be2d307ca47    74
#  6 2cbb0d964a27676a704a80962fdf2b4928824e8d    70
#  7 203c1f04cbb676698d72ca71f0fee73715734651    69
#  8 a8849b4ffec4deca987d0a437c2e5aff08919a64    56
#  9 43484fcbf304ba29a8ae15a30908cbdf43f06027    54
# 10 98ec37bfb2e4ed8e830328e98a61d075faf8eec7    53
# # ℹ 1,799 more rows
# # ℹ Use `print(n = ...)` to see more rows

# constant folding?

result_base |>
  filter(expr_funs == "<other>$") |>
  filter(row_number() == 1, .by = id) |>
  add_count(id) |>
  arrange(desc(n)) |>
  filter(id == first(id)) |>
  pull(call)

result_base |>
  filter(any(expr_funs == "<other>$"), .by = id) |>
  count(expr_funs, sort = TRUE)

# constant folding?

result_base |>
  filter(expr_funs == "[") |>
  filter(row_number() == 1, .by = id) |>
  add_count(id) |>
  arrange(desc(n)) |>
  filter(id == first(id)) |>
  pull(call)

result_base |>
  filter(any(expr_funs == "["), .by = id) |>
  count(expr_funs, sort = TRUE)

# constant folding?

result_base |>
  filter(expr_funs == "[[") |>
  filter(row_number() == 1, .by = id) |>
  add_count(id) |>
  arrange(desc(n)) |>
  filter(id == first(id)) |>
  pull(call)

result_base |>
  filter(any(expr_funs == "[["), .by = id) |>
  count(expr_funs, sort = TRUE)

# constant folding?

result_base |>
  filter(expr_funs == "c") |>
  filter(row_number() == 1, .by = id) |>
  add_count(id) |>
  arrange(desc(n)) |>
  filter(id == first(id)) |>
  pull(call)

result_base |>
  filter(any(expr_funs == "c"), .by = id) |>
  count(expr_funs, sort = TRUE)

# replace(.x, .y, .z) === case_when(.y, .z, .x)

result_base |>
  filter(expr_funs == "replace") |>
  add_count(id) |>
  arrange(desc(n)) |>
  pull(call) |>
  map_chr(deparse1) |>
  writeLines()

result_base |>
  filter(any(expr_funs == "replace"), .by = id) |>
  count(expr_funs, sort = TRUE)

# factor
# as.numeric
# as.character


# Often `1:n()`, sometimes `1:nrow(...)`

result_base |>
  filter(expr_funs == ":") |>
  add_count(id) |>
  arrange(desc(n)) |>
  pull(call) |>
  map_chr(deparse1) |>
  writeLines()

result_base |>
  filter(any(expr_funs == ":"), .by = id) |>
  count(expr_funs, sort = TRUE)

# ~ often in case_when() and in purrr functions

result_base |>
  filter(expr_funs == "~") |>
  add_count(id) |>
  arrange(desc(n)) |>
  pull(call) |>
  map_chr(deparse1) |>
  writeLines()

result_base |>
  filter(any(expr_funs == ":"), .by = id) |>
  count(expr_funs, sort = TRUE)
