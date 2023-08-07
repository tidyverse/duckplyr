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
    "slice_min", "slice_max", "slice_sample",
    "tbl_vars",
    NULL
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

duckdb_tests <- head(n = -1, list(
  "helper-s3.R" = c(
    NULL
  ),
  "helper-encoding.R" = c(
    NULL
  ),
  "test-across.R" = c(
    # Sort order
    "if_any() and if_all() respect filter()-like NA handling",
    "expanded if_any() finds local data",
    NULL
  ),
  "test-all-equal.R" = c(
    # No idea
    "count() give meaningful errors",
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
  "test-deprec-do.R" = c(
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
  "test-group-map.R" = c(
    "group_modify() works on ungrouped data frames (#4067)",
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
    "mutating joins don't trigger many-to-many warning when called indirectly",

    # https://github.com/duckdb/duckdb/issues/7451
    # https://github.com/tidyverse/dplyr/pull/6846
    "factor keys are coerced to the union factor type",

    "filtering joins finalize unspecified columns (#6804)",
    NULL
  ),
  "test-mutate.R" = c(
    # FIXME: vector class?
    "mutate() handles symbol expressions",
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
    "setequal tibbles must have same rows and columns",

    NULL
  ),
  "test-slice.R" = c(
    NULL
  ),
  "test-summarise.R" = c(
    # Removed sum() macro for now
    "works with empty data frames",

    # sum(1:3) returns HUGEINT in duckdb
    "summarise() correctly auto-names expressions (#6741)",

    # Fails in R CMD check
    "summarise() gives meaningful errors",

    # Fails in R CMD check, also https://github.com/tidyverse/dplyr/pull/6883
    "summarise(.groups=) in global environment",

    NULL
  ),
  "test-transmute.R" = c(
    NULL
  ),
  NULL
))

# dplyr_only_tests --------------------------------------------------------------------

dplyr_only_tests <- head(n = -1, list(
  "test-count-tally.R" = c(
    "ouput preserves grouping",
    NULL
  ),
  "test-deprec-do.R" = c(
    "ungrouped data frame with unnamed argument returns data frame",
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

# non_force_only_tests --------------------------------------------------------------------

non_force_only_tests <- head(n = -1, list(
  `test-across.R` = c(
    "across() works on one column data.frame",
    "across(.unpack =) can unpack data frame columns",
    "across(.unpack =) allows a glue specification for `.unpack`",
    "across(.unpack =) skips unpacking non-df-cols",
    "across(.unpack =) uses the result of `.names` as `{outer}`",
    "across(.unpack =) errors if the unpacked data frame has non-unique names",
    "`.unpack` is validated",
    "across() result locations are aligned with column names (#4967)",
    "across() works sequentially (#4907)", "across() retains original ordering",
    "across() throws meaningful error with failure during expansion (#6534)",
    "across() gives meaningful messages",
    "monitoring cache - across() can be used twice in the same expression",
    "monitoring cache - across() can be used in separate expressions",
    "across() uses tidy recycling rules",
    "across(<empty set>) returns a data frame with 1 row (#5204)",
    "across(.names=) can use local variables in addition to {col} and {fn}",
    "across(.unpack=) can use local variables in addition to {outer} and {inner}",
    "across() uses environment from the current quosure (#5460)",
    "across() sees columns in the recursive case (#5498)",
    "across() works with empty data frames (#5523)",
    "lambdas in mutate() + across() can use columns",
    "lambdas in summarise() + across() can use columns",
    "lambdas in mutate() + across() can use columns in follow up expressions (#5717)",
    "lambdas in summarise() + across() can use columns in follow up expressions (#5717)",
    "if_any() and if_all() do not enforce logical",
    "if_any() and if_all() can be used in mutate() (#5709)",
    "across() caching not confused when used from if_any() and if_all() (#5782)",
    "if_any() and if_all() aborts when predicate mistakingly used in .cols= (#5732)",
    "across() correctly reset column", "across() can omit dots",
    "inlined and non inlined lambdas work", "list of lambdas work",
    "anonymous function `.fns` can access the `.data` pronoun even when not inlined",
    "across() uses local formula environment (#5881)",
    "across() can access lexical scope (#5862)",
    "if_any() and if_all() expansions deal with no inputs or single inputs",
    "if_any() and if_all() wrapped deal with no inputs or single inputs",
    "across() can use named selections",
    "across() predicates operate on whole data", "selects and combines columns",
    "can't rename during selection (#6522)",
    "`all_of()` is evaluated in the correct environment (#6522)",
    "across() applies old `.cols = everything()` default with a warning",
    "if_any() and if_all() apply old `.cols = everything()` default with a warning",
    "across() applies old `.fns = NULL` default",
    "if_any() and if_all() apply old `.fns = NULL` default",
    "across errors with non-empty dots and no `.fns` supplied (#6638)",
    "across(...) is deprecated", "across() passes ... to functions",
    "across() passes unnamed arguments following .fns as ... (#4965)",
    "across() evaluates ... with promise semantics (#5813)",
    "symbols are looked up as list or functions (#6545)",
    "non-inlinable but maskable lambdas give precedence to function arguments",
    "maskable lambdas can refer to their lexical environment",
    NULL
  ),
  `test-arrange.R` = c(
    "arrange() gives meaningful errors",
    "arrange handles list columns (#282)", "arrange handles raw columns (#1803)",
    "arrange handles matrix columns",
    "arrange handles data.frame columns (#3153)",
    "arrange handles complex columns",
    "arrange handles S4 classes (#1105)",
    "arrange works with two columns when the first has a data frame proxy (#6268)",
    "arrange ignores NULLs (#6193)",
    "`arrange()` works with `numeric_version` (#6680)",
    "arrange defaults to the C locale",
    "locale can be set to an English locale",
    "non-English locales can be used",
    "arrange validates `.locale`",
    "arrange validates that `.locale` must be one from stringi",
    "arrange() supports across() and pick() (#4679)",
    "arrange() works with across() and pick() cols that return multiple columns (#6490)",
    "arrange() evaluates each pick() call on the original data (#6495)",
    "desc() inside arrange() checks the number of arguments (#5921)",
    "legacy - using the global option `dplyr.legacy_locale` forces the system locale",
    "legacy - usage of `.locale` overrides `dplyr.legacy_locale`",
    "legacy - empty arrange() returns input",
    "legacy - can sort empty data frame",
    "legacy - arrange handles list columns (#282)",
    "legacy - arrange handles raw columns (#1803)",
    "legacy - arrange handles matrix columns",
    "legacy - arrange handles data.frame columns (#3153)",
    "legacy - arrange handles complex columns",
    "legacy - arrange handles S4 classes (#1105)",
    "legacy - `arrange()` works with `numeric_version` (#6680)",
    "legacy - arrange works with two columns when the first has a data frame proxy (#6268)",
    "legacy - arrange() supports across() and pick() (#4679)",
    "legacy - arrange() works with across() and pick() cols that return multiple columns (#6490)",
    "legacy - arrange sorts missings in df-cols correctly",
    "legacy - arrange with duplicates in a df-col uses a stable sort",
    "legacy - arrange with doubly nested df-col doesn't infloop",
    NULL
  ),
  `test-count-tally.R` = c(
    "count can sort output",
    "informs if n column already present, unless overridden",
    "name must be string",
    "output includes empty levels with .drop = FALSE",
    "weighted tally drops NAs (#1145)",
    "output preserves grouping",
    ".drop is deprecated",
    NULL
  ),
  `test-deprec-do.R` = c(
    "multiple outputs can access data (#2998)",
    NULL
  ),
  `test-distinct.R` = c(
    "distinct works for 0-sized columns (#1437)",
    "distinct on a dataframe or tibble with columns of type list throws an error",
    "distinct handles 0 columns edge case (#2954)",
    "distinct() handles auto splicing",
    "distinct errors when selecting an unknown column (#3140)",
    NULL
  ),
  `test-filter.R` = c(
    "filter handles passing ...",
    "filter propagates attributes",
    "$ does not end call traversing. #502",
    "filter handles POSIXlt",
    "filter handles complex vectors (#436)",
    "row_number does not segfault with example from #781",
    "row_number works on 0 length columns (#3454)",
    "filter correctly handles empty data frames (#782)",
    "filter, slice and arrange preserves attributes (#1064)",
    "filter handles S4 objects (#1366)",
    "filter handles raw vectors (#1803)",
    "filter() handles matrix and data frame columns (#3630)",
    "filter() handles named logical (#4638)",
    "filter() allows 1 dimension arrays",
    "filter() allows matrices with 1 column with a deprecation warning (#6091)",
    "filter() disallows matrices with >1 column",
    "filter() disallows arrays with >2 dimensions",
    "can group transiently using `.by`",
    "transient grouping retains bare data.frame class",
    "transient grouping retains data frame attributes",
    NULL
  ),
  `test-join.R` = c(
    "can't use `keep = FALSE` with non-equi conditions (#6499)",
    "joins don't match NA when na_matches = 'never' (#2033)",
    "mutating joins finalize unspecified columns (#6804)",
    "error if passed additional arguments",
    "nest_join returns list of tibbles (#3570)",
    "nest_join preserves data frame attributes on `x` and `y` (#6295)",
    "nest_join computes common columns",
    "nest_join finalizes unspecified columns (#6804)",
    "nest_join references original column in `y` when there are type errors (#6465)",
    "nest_join handles multiple matches in x (#3642)",
    "nest_join forces `multiple = 'all'` internally (#6392)",
    "y keys dropped by default for equi conditions",
    "y keys kept by default for non-equi conditions",
    "validates inputs",
    "by = character() generates cross (#4206)",
    "`by = character()` technically respects `unmatched`",
    "`by = character()` technically respects `relationship`",
    "`by = character()` for a cross join is deprecated (#6604)",
    "`by = named character()` for a cross join works",
    "`by = list(x = character(), y = character())` for a cross join is deprecated (#6604)",
    NULL
  ),
  `test-mutate.R` = c(
    "setting a new column to `NULL` works with `.before` and `.after` (#6563)",
    "can remove variables with NULL (#462)",
    "mutate() names pronouns correctly (#2686)",
    "mutate() supports unquoted values",
    "assignments don't overwrite variables (#315)",
    "can mutate a data frame with zero columns",
    "can't overwrite column active bindings (#6666)",
    "assigning with `<-` doesn't affect the mask (#6666)",
    "`across()` inline expansions that use `<-` don't affect the mask (#6666)",
    "can't share local variables across expressions (#6666)",
    "glue() is supported",
    "mutate preserves names (#1689, #2675)",
    "mutate handles matrix columns",
    "mutate handles data frame columns",
    "unnamed data frames are automatically unspliced  (#2326, #3630)",
    "named data frames are packed (#2326, #3630)",
    "unchop only called for when multiple groups",
    "mutate works on empty data frames (#1142)",
    "DataMask uses fresh copies of group id / size variables (#6762)",
    "can `NULL` out the `.by` column",
    ".keep = 'used' not affected by across() or pick()",
    NULL
  ),
  `test-relational.R` = c(
    "rel_try() with reason",
    NULL
  ),
  `test-rename.R` = c(
    "can rename with duplicate columns",
    "can select columns",
    "passes ... along",
    "can't create duplicated names",
    "`.fn` result type is checked (#6561)",
    "`.fn` result size is checked (#6561)",
    "can't rename in `.cols`",
    NULL
  ),
  `test-select.R` = c(
    "can select with duplicate columns",
    "select succeeds in presence of raw columns (#1803)",
    NULL
  ),
  `test-sets.R` = c(
    "incompatible data frames error (#903)",
    "setequal ignores column and row order",
    "setequal ignores duplicated rows (#6057)",
    "setequal uses coercion rules (#6114)",
    NULL
  ),
  `test-slice.R` = c(
    "empty slice drops all rows (#6573)",
    "slicing data.frame yields data.frame",
    "slice errors if positive and negative indices mixed",
    "slicing with one-column matrix is deprecated",
    "slice errors if index is not numeric",
    "slice handles zero-row and zero-column inputs (#1219, #2490)",
    "`...` can't be named (#6554)",
    "can group transiently using `.by`",
    "transient grouping retains bare data.frame class",
    "transient grouping retains data frame attributes",
    "transient grouping orders by first appearance",
    "slice_helpers() call get_slice_size()",
    "n must be an integer",
    "functions silently truncate results",
    "slice helpers with n = 0 return no rows",
    "slice_*() doesn't look for `n` in data (#6089)",
    "slice_*() checks that `n=` is explicitly named and ... is empty",
    "min and max return ties by default",
    "min and max reorder results",
    "min and max include NAs when appropriate",
    "min and max ignore NA's when requested (#4826)",
    "slice_min/max() count from back with negative n/prop",
    "slice_min/max() can order by multiple variables (#6176)",
    "slice_min/max() work with `by`",
    "slice_min/max() inject `with_ties` and `na_rm` (#6725)",
    "slice_min/max() check size of `order_by=` (#5922)",
    "slice_sample() respects weight_by and replaces",
    "slice_sample() can increase rows iff replace = TRUE",
    "slice_sample() checks size of `weight_by=` (#5922)",
    "slice_sample() works with zero-row data frame (#5729)",
    "slice_sample() injects `replace` (#6725)",
    "slice_sample() handles negative n= and prop= (#6402)",
    "slice_sample() works with `by`",
    "slice_head/tail() count from back with negative n/prop",
    "slice_head/slice_tail handle infinite n/prop",
    "slice_head/slice_tail work with `by`",
    NULL
  ),
  `test-summarise.R` = c(
    "can use freshly create variables (#138)",
    "inputs are recycled (deprecated in 1.1.0)",
    "no expressions yields grouping data",
    "named data frame results with 0 columns participate in recycling (#6509)",
    "can't overwrite column active bindings (#6666)",
    "assigning with `<-` doesn't affect the mask (#6666)",
    "summarise allows names (#2675)",
    "unnamed tibbles are unpacked (#2326)",
    "named tibbles are packed (#2326)",
    "summarise(.groups=)",
    "non-summary results are deprecated in favor of `reframe()` (#6382)",
    NULL
  ),
  `test-transmute.R` = c(
    "transmute with no args returns grouping vars",
    "transmute succeeds in presence of raw columns (#1803)",
    "transmute() does not warn when a variable is removed with = NULL (#4609)",
    "transmute() can handle auto splicing",
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
  rows_upsert = FALSE,
  sample_n = FALSE,
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
