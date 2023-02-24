# pak::pak("cynkra/constructive")
library(tidyverse)
library(rlang)

dplyr <- asNamespace("dplyr")

s3_methods <- as_tibble(
  matrix(as.character(dplyr$.__NAMESPACE__.$S3methods), ncol = 4),
  .name_repair = ~ c("name", "class", "fun", "what")
)

df_methods <-
  s3_methods %>%
  filter(class == "data.frame") %>%
  # deprecated and lazyeval methods, won't implement
  filter(!grepl("_$|^as[.]tbl$", name)) %>%
  # special dplyr methods, won't implement
  filter(!(name %in% c(
    "dplyr_col_modify",
    "dplyr_row_slice",
    "group_by",
    "rowwise",
    "group_data", "group_indices", "group_keys", "group_map", "group_modify", "group_nest", "group_size", "group_split", "group_trim", "groups", "n_groups",
    "same_src", # data frames can be copied into duck-frames with zero cost
    NULL
  ))) %>%
  # methods we don't need to implement but can test
  mutate(skip_impl = name %in% c(
    "collapse", "tally",
    "slice_min", "slice_max", "slice_sample"
  )) %>%
  mutate(is_tbl_return = !(name %in% c(
    # Special case: forward to `NextMethod()`, don't change output
    "dplyr_reconstruct", "auto_copy", "pull", "setequal", "tbl_vars",
    "group_vars",
    NULL
  ))) %>%
  mutate(code = unname(mget(fun, dplyr)))

tests <- head(n = -1, list(
  "helper-s3.R" = c(
    NULL
  ),
  "helper-encoding.R" = c(
    NULL
  ),
  "test-arrange.R" = c(
    NULL
  ),
  "test-colwise-select.R" = c(
    NULL
  ),
  "test-count-tally.R" = c(
    NULL
  ),
  "test-deprec-funs.R" = c(
    "as_fun_list() auto names chr vectors (4307)",
    NULL
  ),
  "test-distinct.R" = c(
    NULL
  ),
  "test-filter.R" = c(
    "if_any() and if_all() work",
    NULL
  ),
  "test-generics.R" = c(
    NULL
  ),
  "test-groups-with.R" = c(
    NULL
  ),
  "test-join.R" = c(
    "mutating joins preserve row and column order of x",
    "when keep = TRUE, duckplyr_left_join() preserves both sets of keys",
    "when keep = TRUE, left_join() preserves both sets of keys",
    "when keep = TRUE, duckplyr_full_join() preserves both sets of keys",
    "when keep = TRUE, full_join() preserves both sets of keys",
    "mutating joins trigger multiple match warning",
    "mutating joins don't trigger multiple match warning when called indirectly",

    "mutating joins reference original column in `y` when there are type errors (#6465)",

    # https://github.com/duckdb/duckdb/issues/6356
    "keys are coerced to symmetric type",
    NULL
  ),
  "test-mutate.R" = c(
    "mutate disambiguates NA and NaN (#1448)",
    "duckplyr_mutate() handles symbol expressions",
    "transient grouping retains data frame attributes (#6100)",
    NULL
  ),
  "test-pull.R" = c(
    NULL
  ),
  "test-relocate.R" = c(
    NULL
  ),
  "test-rename.R" = c(
    NULL
  ),
  "test-select.R" = c(
    NULL
  ),
  "test-sets.R" = c(
    # https://github.com/duckdb/duckdb/issues/6368
    "x used as basis of output (#3839)",
    # https://github.com/duckdb/duckdb/issues/6369
    "set operations (apart from union_all) remove duplicates",
    NULL
  ),
  "test-slice.R" = c(
    NULL
  ),
  "test-summarise.R" = c(
    "works with unquoted values",
    NULL
  ),
  "test-transmute.R" = c(
    NULL
  ),
  NULL
))

dplyr_only_tests <- head(n = -1, list(
  "test-colwise-select.R" = c(
    "can select/rename with predicate", "can take list, but only containing single function", "can select/rename with vars()",
    NULL
  ),
  "test-count-tally.R" = c(
    "ouput preserves grouping",
    "output preserves class & attributes where possible",
    NULL
  ),
  "test-generics.R" = c(
    "dplyr_reconstruct() strips attributes before dispatch",
    NULL
  ),
  "test-groups-with.R" = c(
    "restores original class",
    NULL
  ),
  "test-join.R" = c(
    "joins preserve groups",
    NULL
  ),
  "test-join-rows.R" = c(
    "join_rows() gives meaningful error/warning message on multiple matches",
    NULL
  ),
  "test-mutate.R" = c(
    "no utf8 invasion (#722)",
    NULL
  ),
  "test-summarise.R" = c(
    "summarise(.groups=)",
    NULL
  ),
  NULL
))
