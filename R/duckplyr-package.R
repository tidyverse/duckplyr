#' @keywords internal
"_PACKAGE"

# @rawNamespace import(vctrs, except = data_frame)
# an alternative for importing nearly everything from vctrs
# https://github.com/tidyverse/dplyr/blob/16b472fb2afc50a87502c2b4ed803e2f5f82b9d6/R/dplyr.R#L7
#
# Can't use blanket cli import, imports must align with dplyr's imports
# (except we can import all of dplyr)
#
#' @import rlang
## usethis namespace: start
#' @importFrom collections dict
#' @importFrom collections queue
#' @importFrom dplyr auto_copy
#' @importFrom dplyr do
#' @importFrom dplyr dplyr_col_modify
#' @importFrom dplyr dplyr_reconstruct
#' @importFrom dplyr dplyr_row_slice
#' @importFrom dplyr funs
#' @importFrom dplyr funs_
#' @importFrom dplyr group_by
#' @importFrom dplyr group_by_prepare
#' @importFrom dplyr group_cols
#' @importFrom dplyr group_data
#' @importFrom dplyr group_indices
#' @importFrom dplyr group_keys
#' @importFrom dplyr group_map
#' @importFrom dplyr group_modify
#' @importFrom dplyr group_nest
#' @importFrom dplyr group_rows
#' @importFrom dplyr group_size
#' @importFrom dplyr group_split
#' @importFrom dplyr group_trim
#' @importFrom dplyr group_vars
#' @importFrom dplyr group_walk
#' @importFrom dplyr grouped_df
#' @importFrom dplyr groups
#' @importFrom dplyr if_else
#' @importFrom dplyr is_grouped_df
#' @importFrom dplyr mutate_all
#' @importFrom dplyr n_groups
#' @importFrom dplyr new_grouped_df
#' @importFrom dplyr new_rowwise_df
#' @importFrom dplyr rename_all
#' @importFrom dplyr rename_at
#' @importFrom dplyr rename_if
#' @importFrom dplyr rowwise
#' @importFrom dplyr same_src
#' @importFrom dplyr select_all
#' @importFrom dplyr select_at
#' @importFrom dplyr select_if
#' @importFrom dplyr summarise_all
#' @importFrom dplyr summarise_at
#' @importFrom dplyr vars
#' @importFrom glue glue
#' @importFrom lifecycle deprecated
#' @importFrom tibble as_tibble
#' @importFrom tibble deframe
#' @importFrom tibble is_tibble
#' @importFrom tibble new_tibble
#' @importFrom tibble tibble
#' @importFrom tidyselect everything
#' @importFrom utils head
#' @importFrom vctrs new_data_frame
#' @importFrom vctrs new_date
#' @importFrom vctrs new_list_of
#' @importFrom vctrs new_rcrd
#' @importFrom vctrs new_vctr
#' @importFrom vctrs obj_check_list
#' @importFrom vctrs unspecified
#' @importFrom vctrs vec_as_names
#' @importFrom vctrs vec_assign
#' @importFrom vctrs vec_c
#' @importFrom vctrs vec_cast
#' @importFrom vctrs vec_cast_common
#' @importFrom vctrs vec_cbind
#' @importFrom vctrs vec_check_size
#' @importFrom vctrs vec_count
#' @importFrom vctrs vec_data
#' @importFrom vctrs vec_detect_complete
#' @importFrom vctrs vec_in
#' @importFrom vctrs vec_init
#' @importFrom vctrs vec_match
#' @importFrom vctrs vec_ptype
#' @importFrom vctrs vec_ptype_finalise
#' @importFrom vctrs vec_ptype2
#' @importFrom vctrs vec_rbind
#' @importFrom vctrs vec_recycle_common
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
## usethis namespace: end
NULL

# Enable to use compiled code again
# @useDynLib duckplyr, .registration = TRUE
NULL

#' @importFrom magrittr %>%
#' @export
magrittr::"%>%"

#' @importFrom dplyr tibble
#' @importFrom dplyr across
#' @importFrom dplyr add_count
#' @importFrom dplyr add_tally
#' @importFrom dplyr all_equal
#' @importFrom dplyr anti_join
#' @importFrom dplyr arrange
#' @importFrom dplyr between
#' @importFrom dplyr bind_cols
#' @importFrom dplyr bind_rows
#' @importFrom dplyr c_across
#' @importFrom dplyr case_match
#' @importFrom dplyr case_when
#' @importFrom dplyr coalesce
#' @importFrom dplyr collapse
#' @importFrom dplyr collect
#' @importFrom dplyr compute
#' @importFrom dplyr consecutive_id
#' @importFrom dplyr count
#' @importFrom dplyr cross_join
#' @importFrom dplyr cumall
#' @importFrom dplyr cumany
#' @importFrom dplyr cume_dist
#' @importFrom dplyr cummean
#' @importFrom dplyr cur_column
#' @importFrom dplyr cur_group
#' @importFrom dplyr cur_group_id
#' @importFrom dplyr cur_group_rows
#' @importFrom dplyr dense_rank
#' @importFrom dplyr desc
#' @importFrom dplyr distinct
#' @importFrom dplyr explain
#' @importFrom dplyr filter
#' @importFrom dplyr first
#' @importFrom dplyr full_join
#' @importFrom dplyr if_any
#' @importFrom dplyr if_else
#' @importFrom dplyr inner_join
#' @importFrom dplyr intersect
#' @importFrom dplyr join_by
#' @importFrom dplyr lag
#' @importFrom dplyr last
#' @importFrom dplyr lead
#' @importFrom dplyr left_join
#' @importFrom dplyr min_rank
#' @importFrom dplyr mutate
#' @importFrom dplyr n
#' @importFrom dplyr n_distinct
#' @importFrom dplyr na_if
#' @importFrom dplyr near
#' @importFrom dplyr nest_by
#' @importFrom dplyr nest_join
#' @importFrom dplyr nth
#' @importFrom dplyr ntile
#' @importFrom dplyr order_by
#' @importFrom dplyr percent_rank
#' @importFrom dplyr pick
#' @importFrom dplyr pull
#' @importFrom dplyr reframe
#' @importFrom dplyr relocate
#' @importFrom dplyr rename
#' @importFrom dplyr rename_with
#' @importFrom dplyr right_join
#' @importFrom dplyr row_number
#' @importFrom dplyr rows_append
#' @importFrom dplyr rows_delete
#' @importFrom dplyr rows_insert
#' @importFrom dplyr rows_patch
#' @importFrom dplyr rows_update
#' @importFrom dplyr rows_upsert
#' @importFrom dplyr sample_frac
#' @importFrom dplyr sample_n
#' @importFrom dplyr select
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
#' @importFrom dplyr summarize
#' @importFrom dplyr symdiff
#' @importFrom dplyr tally
#' @importFrom dplyr tbl_vars
#' @importFrom dplyr top_n
#' @importFrom dplyr transmute
#' @importFrom dplyr ungroup
#' @importFrom dplyr union
#' @importFrom dplyr union_all
#' @importFrom dplyr with_groups
#' @importFrom dplyr with_order
#' @importFrom rlang .data
#' @importFrom tibble add_row
#' @importFrom tibble as_tibble
#' @importFrom tibble tribble
#' @importFrom tidyselect all_of
#' @importFrom tidyselect any_of
#' @importFrom tidyselect contains
#' @importFrom tidyselect everything
#' @importFrom tidyselect last_col
#' @importFrom tidyselect matches
#' @importFrom tidyselect num_range
#' @importFrom tidyselect one_of
#' @importFrom tidyselect starts_with
#' @importFrom tidyselect where
NULL

# Only in this package
dplyr_mode <- FALSE
