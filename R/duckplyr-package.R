#' @keywords internal
"_PACKAGE"

## usethis namespace: start
# @rawNamespace import(vctrs, except = data_frame)
# an alternative for importing nearly everything from vctrs
# https://github.com/tidyverse/dplyr/blob/16b472fb2afc50a87502c2b4ed803e2f5f82b9d6/R/dplyr.R#L7
#' @import rlang
#' @importFrom collections dict
#' @importFrom collections queue
#' @importFrom dplyr across
#' @importFrom dplyr add_count
#' @importFrom dplyr add_tally
#' @importFrom dplyr all_equal
#' @importFrom dplyr anti_join
#' @importFrom dplyr arrange
#' @importFrom dplyr auto_copy
#' @importFrom dplyr c_across
#' @importFrom dplyr case_when
#' @importFrom dplyr collapse
#' @importFrom dplyr collect
#' @importFrom dplyr compute
#' @importFrom dplyr count
#' @importFrom dplyr cross_join
#' @importFrom dplyr desc
#' @importFrom dplyr distinct
#' @importFrom dplyr do
#' @importFrom dplyr dplyr_col_modify
#' @importFrom dplyr dplyr_reconstruct
#' @importFrom dplyr dplyr_row_slice
#' @importFrom dplyr filter
#' @importFrom dplyr first
#' @importFrom dplyr full_join
#' @importFrom dplyr funs
#' @importFrom dplyr funs_
#' @importFrom dplyr group_by
#' @importFrom dplyr group_data
#' @importFrom dplyr group_keys
#' @importFrom dplyr group_map
#' @importFrom dplyr group_modify
#' @importFrom dplyr group_rows
#' @importFrom dplyr group_size
#' @importFrom dplyr group_vars
#' @importFrom dplyr group_walk
#' @importFrom dplyr if_all
#' @importFrom dplyr if_any
#' @importFrom dplyr inner_join
#' @importFrom dplyr intersect
#' @importFrom dplyr is_grouped_df
#' @importFrom dplyr join_by
#' @importFrom dplyr lag
#' @importFrom dplyr last
#' @importFrom dplyr lead
#' @importFrom dplyr left_join
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_all
#' @importFrom dplyr n
#' @importFrom dplyr n_distinct
#' @importFrom dplyr nest_by
#' @importFrom dplyr nest_join
#' @importFrom dplyr nth
#' @importFrom dplyr pull
#' @importFrom dplyr reframe
#' @importFrom dplyr relocate
#' @importFrom dplyr rename
#' @importFrom dplyr rename_all
#' @importFrom dplyr rename_at
#' @importFrom dplyr rename_if
#' @importFrom dplyr rename_with
#' @importFrom dplyr right_join
#' @importFrom dplyr row_number
#' @importFrom dplyr rows_append
#' @importFrom dplyr rows_delete
#' @importFrom dplyr rows_insert
#' @importFrom dplyr rows_patch
#' @importFrom dplyr rows_update
#' @importFrom dplyr rows_upsert
#' @importFrom dplyr rowwise
#' @importFrom dplyr same_src
#' @importFrom dplyr sample_frac
#' @importFrom dplyr sample_n
#' @importFrom dplyr select
#' @importFrom dplyr select_all
#' @importFrom dplyr select_at
#' @importFrom dplyr select_if
#' @importFrom dplyr semi_join
#' @importFrom dplyr setdiff
#' @importFrom dplyr setequal
#' @importFrom dplyr slice
#' @importFrom dplyr slice_head
#' @importFrom dplyr slice_max
#' @importFrom dplyr slice_min
#' @importFrom dplyr slice_sample
#' @importFrom dplyr slice_tail
#' @importFrom dplyr summarise
#' @importFrom dplyr summarise_all
#' @importFrom dplyr summarise_at
#' @importFrom dplyr summarize
#' @importFrom dplyr symdiff
#' @importFrom dplyr tally
#' @importFrom dplyr tbl_vars
#' @importFrom dplyr transmute
#' @importFrom dplyr ungroup
#' @importFrom dplyr union
#' @importFrom dplyr union_all
#' @importFrom dplyr vars
#' @importFrom dplyr with_groups
#' @importFrom glue glue
#' @importFrom lifecycle deprecated
#' @importFrom purrr imap
#' @importFrom purrr map
#' @importFrom purrr map_chr
#' @importFrom purrr map_lgl
#' @importFrom purrr map2
#' @importFrom purrr pmap
#' @importFrom purrr reduce
#' @importFrom purrr walk
#' @importFrom tibble as_tibble
#' @importFrom tibble deframe
#' @importFrom tibble is_tibble
#' @importFrom tibble new_tibble
#' @importFrom tibble tibble
#' @importFrom tidyselect everything
#' @importFrom utils head
# an alternative for importing nearly everything from vctrs
# https://github.com/tidyverse/dplyr/blob/16b472fb2afc50a87502c2b4ed803e2f5f82b9d6/R/dplyr.R#L7
# @rawNamespace import(vctrs, except = data_frame)
#' @importFrom vctrs new_data_frame
#' @importFrom vctrs new_rcrd
#' @importFrom vctrs unspecified
#' @importFrom vctrs vec_as_names
#' @importFrom vctrs vec_assign
#' @importFrom vctrs vec_c
#' @importFrom vctrs vec_cast
#' @importFrom vctrs vec_cast_common
#' @importFrom vctrs vec_cbind
#' @importFrom vctrs vec_in
#' @importFrom vctrs vec_match
#' @importFrom vctrs vec_rbind
#' @importFrom vctrs vec_rep
#' @importFrom vctrs vec_rep_each
#' @importFrom vctrs vec_set_difference
#' @importFrom vctrs vec_set_intersect
#' @importFrom vctrs vec_set_symmetric_difference
#' @importFrom vctrs vec_set_union
#' @importFrom vctrs vec_size
#' @importFrom vctrs vec_slice
#' @importFrom vctrs vec_split
#' @importFrom vctrs vec_unique_loc
#' @useDynLib duckplyr, .registration = TRUE
## usethis namespace: end
NULL

# Only in this package
dplyr_mode <- FALSE

on_load({
  if (!identical(Sys.getenv("TESTTHAT"), "true")) {
    options(duckdb.materialize_message = TRUE)
  }
})
