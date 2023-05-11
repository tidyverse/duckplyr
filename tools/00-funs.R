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

    # For 03-tests.R
    "do", "reframe",

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
    NULL
  ),
  "test-distinct.R" = c(
    NULL
  ),
  "test-filter.R" = c(
    # FIXME: oo for filter?
    "if_any() and if_all() work",

    # FIXME: oo for %in%
    "filter handles $ correctly (#278)",
    NULL
  ),
  "test-generics.R" = c(
    NULL
  ),
  "test-groups-with.R" = c(
    NULL
  ),
  "test-join.R" = c(
    "mutating joins trigger multiple match warning",
    "mutating joins don't trigger multiple match warning when called indirectly",

    "mutating joins reference original column in `y` when there are type errors (#6465)",
    "filtering joins reference original column in `y` when there are type errors (#6465)",

    "mutating joins trigger many-to-many warning",
    "mutating joins compute common columns",

    # https://github.com/duckdb/duckdb/issues/7451
    # https://github.com/tidyverse/dplyr/pull/6846
    "keys are coerced to symmetric type",
    NULL
  ),
  "test-mutate.R" = c(
    # FIXME: vector class?
    "duckplyr_mutate() handles symbol expressions",
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
    # FIXME: oo
    "set operations (apart from union_all) remove duplicates",

    NULL
  ),
  "test-slice.R" = c(
    NULL
  ),
  "test-summarise.R" = c(
    # Removed sum() macro for now
    "works with empty data frames",

    # sum(1:3) returns HUGEINT in duckdb
    "duckplyr_summarise() correctly auto-names expressions (#6741)",
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

test_extra_arg_map <- list(
  anti_join = "join_by(a)",
  arrange = c(
    "",
    "a",
    "g",
    "g, a",
    "a, g",
    # "desc(g)"
    NULL
  ),
  count = c(
    "",
    "a",
    "b",
    "g",
    "g, a",
    "b, g",
    NULL
  ),
  distinct = c(
    "",
    "a",
    "a, b",
    "b, b",
    "g",

    # https://github.com/duckdb/duckdb/issues/6369, needs several repetitions
    "union_all(data.frame(a = 1L, b = 3, g = 2L))" = "g",
    "union_all(data.frame(a = 1L, b = 4, g = 2L))" = "g",
    "union_all(data.frame(a = 1L, b = 5, g = 2L))" = "g",
    "union_all(data.frame(a = 1L, b = 6, g = 2L))" = "g",
    "union_all(data.frame(a = 1L, b = 7, g = 2L))" = "g",

    "g, .keep_all = TRUE",
    NULL
  ),
  do = "data.frame(c = 1)",
  dplyr_reconstruct = "test_df",
  filter = c(
    "a == 1",
    "a %in% 2:3, g == 2",
    "a %in% 2:3 & g == 2",
    # "lag(a) == 1, .by = g",
    NULL
  ),
  full_join = "join_by(a)",
  group_map = "~ .x",
  group_modify = "~ .x",
  inner_join = "join_by(a)",
  left_join = "join_by(a)",
  mutate = c(
    "",
    "a + 1",
    "a + 1, .by = g",
    "c = a + 1",
    "`if` = a + 1",
    "sum(a)",
    "sum(a), .by = g",
    "mean(a)",
    "mean(a), .by = g",

    "sd(a)",
    "sd(a), .by = g",

    # prod() doesn't exist
    # "prod(a)",
    # "prod(a), .by = g",

    "lag(a)",
    "lag(a), .by = g",
    "lead(a)",
    "lead(a), .by = g",
    "lag(a, 2)",
    "lag(a, 2), .by = g",
    "lead(a, 2)",
    "lead(a, 2), .by = g",
    "lag(a, 4)",
    "lag(a, 4), .by = g",
    "lead(a, 4)",
    "lead(a, 4), .by = g",
    "lag(a, default = 0)",
    "lag(a, default = 0), .by = g",
    "lead(a, default = 1000)",
    "lead(a, default = 1000), .by = g",

    # Need to fix implementation, wrong output order
    # "lag(a, order_by = -a)",
    # "lag(a, order_by = -a), .by = g",
    # "lead(a, order_by = -a)",
    # "lead(a, order_by = -a), .by = g",

    "min(a)",
    "min(a), .by = g",
    "max(a)",
    "max(a), .by = g",

    "first(a)",
    "first(a), .by = g",
    "last(a)",
    "last(a), .by = g",
    "nth(a, 2)",
    "nth(a, 2), .by = g",

    # Different results
    # "nth(a, -2)",
    # "nth(a, -2), .by = g",

    NULL
  ),
  nest_join = "join_by(a)",
  relocate = c(
    "g",
    "a",
    "g, .before = b",
    "a:b, .after = g",
    NULL
  ),
  rename = c(
    "",
    "c = a",
    NULL
  ),
  rename_with = "identity",
  right_join = "join_by(a)",
  rows_delete = 'by = c("a", "b"), unmatched = "ignore"',
  rows_insert = 'by = "a", conflict = "ignore"',
  rows_patch = 'by = "a", unmatched = "ignore"',
  rows_update = 'by = "a", unmatched = "ignore"',
  rows_upsert = 'by = "a"',
  sample_n = "size = 1",
  select = c(
    "a",
    "-g",
    "everything()",
    NULL
  ),
  semi_join = "join_by(a)",
  slice_max = 'a',
  slice_min = 'a',
  summarise = c(
    "c = mean(a)",
    "c = mean(a), .by = b",
    "c = mean(a), .by = g",
    "c = 1",
    "c = 1, .by = g",
    # "sum(a < 3)",
    # "sum(a < 3, .by = g)",
    NULL
  ),
  tally = c(
    "",
    # "a",
    # "b",
    # "g",
    # "g, a",
    # "b, g",
    NULL
  ),
  transmute = c(
    "c = a + 1",
    NULL
  ),
  NULL
)

test_skip_map <- c(
  # FIXME: Fail with group_by()
  dplyr_reconstruct = "Hack",
  group_by = "Grouped",
  group_map = "WAT",
  group_modify = "Grouped",
  group_nest = "Always returns tibble",
  group_split = "WAT",
  group_trim = "Grouped",
  nest_by = "WAT",
  # FIXME: Fail with rowwise()
  rowwise = "Stack overflow",
  sample_frac = "Random seed",
  sample_n = "Random seed",
  slice_head = "External vector?",
  slice_max = "External vector?",
  slice_min = "External vector?",
  slice_sample = "External vector?",
  slice_tail = "External vector?",
  ungroup = "Grouped",
  NULL
)

test_force_override <- c(
  auto_copy = FALSE,
  collect = FALSE,
  dplyr_reconstruct = FALSE,
  group_vars = FALSE,
  nest_join = FALSE,
  tally = TRUE,
  NULL
)

test_df_code <- "  test_df <- data.frame(a = 1:6 + 0, b = 2, g = rep(1:3, 1:3))"
test_df_op_code <- "{{{pre_step}}}{{{name}}}({{{extra_arg}}})"

test_df_xy_code <- c(
  "  test_df_x <- data.frame(a = 1:4, b = 2)",
  "  test_df_y <- data.frame(a = 2:5, b = 2)"
)
test_df_xy_op_code <- "{{{name}}}(test_df_y{{{extra_arg}}})"
