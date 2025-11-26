test_that("no homonyms", {
  skip_if(identical(Sys.getenv("R_COVR"), "true"))

  dplyr <- asNamespace("dplyr")
  duckplyr <- asNamespace("duckplyr")

  names_dplyr <- ls(dplyr)
  names_duckplyr <- ls(duckplyr)

  purrr_names <- c(
    # https://github.com/tidyverse/dplyr/pull/7029
    "join_ptype_common",

    # needs dplyr > 1.1.4
    "ncol", "df_n_col", "mat_n_col", "check_compatible", "is_compatible",

    # internal or deprecated functions
    "all_exprs", "any_exprs", "compute_groups", "dplyr_legacy_locale",
    "err_locs", "expand_pick", "group_labels_details", "is_sel_vars",
    "list_flatten", "quo_is_variable_reference", "shift", "vec_case_match",
    "vec_case_when", "add_rownames", "arrange_", "arrange_at", "arrange_if",
    "arrange_all", "combine", "compat_lazy_dots", "count_", "cur_data",
    "cur_data_all", "distinct_", "distinct_at", "distinct_if", "distinct_all",
    "do_", "filter_", "filter_at", "filter_if", "filter_all", "group_by_",
    "group_by_at", "group_by_if", "group_by_all", "mutate_", "mutate_at",
    "mutate_if", "mutate_all", "mutate_each", "mutate_each_", "recode",
    "recode_factor", "rename_", "rename_at", "rename_if", "rename_all",
    "select_", "select_at", "select_if", "select_all", "select_vars_",
    "slice_", "src_df", "summarise_", "summarize_", "summarise_at",
    "summarise_if", "summarise_all", "summarise_each", "tbl_at_vars",
    "top_frac", "transmute_", "transmute_at", "transmute_if", "transmute_all",

    "map", "walk", "map_lgl", "map_int", "map_dbl", "map_chr",
    ".rlang_purrr_map_mold", "map2", "map2_lgl", "map2_int",
    "map2_dbl", "map2_chr", "imap", "pmap", ".rlang_purrr_args_recycle",
    "keep", "discard", "map_if", ".rlang_purrr_probe", "compact",
    "transpose", "every", "some", "negate", "reduce", "reduce_right",
    "accumulate", "accumulate_right", "detect", "detect_index",
    ".rlang_purrr_index", "list_c"
  )

  names_common <- intersect(names_dplyr, names_duckplyr)
  names_common <- setdiff(names_common, c("DataMask", "the", purrr_names))

  objs_dplyr <- mget(names_common, dplyr)
  objs_duckplyr <- mget(names_common, duckplyr)

  expect_identical(objs_duckplyr, objs_dplyr[names(objs_duckplyr)])
})
