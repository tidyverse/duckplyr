test_that("no homonyms", {
  skip_if(identical(Sys.getenv("R_COVR"), "true"))

  dplyr <- asNamespace("dplyr")
  duckplyr <- asNamespace("duckplyr")

  names_dplyr <- ls(dplyr)
  names_duckplyr <- ls(duckplyr)

  purrr_names <- c(
    # https://github.com/tidyverse/dplyr/pull/7029
    "join_ptype_common",

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
