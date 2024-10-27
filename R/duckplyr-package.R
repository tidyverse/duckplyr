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
#' @importFrom vctrs unspecified
#' @importFrom vctrs vec_as_names
#' @importFrom vctrs vec_assign
#' @importFrom vctrs vec_c
#' @importFrom vctrs vec_cast
#' @importFrom vctrs vec_cast_common
#' @importFrom vctrs vec_cbind
#' @importFrom vctrs vec_check_size
#' @importFrom vctrs vec_data
#' @importFrom vctrs vec_in
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

#' @importFrom dplyr %>%
#' @export
dplyr::"%>%"

#' @importFrom dplyr tibble
#' @export
dplyr::tibble

#' @importFrom dplyr across
#' @export
dplyr::across

#' @importFrom dplyr add_count
#' @export
dplyr::add_count

#' @importFrom dplyr add_tally
#' @export
dplyr::add_tally

#' @importFrom dplyr all_equal
#' @export
dplyr::all_equal

#' @importFrom dplyr anti_join
#' @export
dplyr::anti_join

#' @importFrom dplyr arrange
#' @export
dplyr::arrange

#' @importFrom dplyr between
#' @export
dplyr::between

#' @importFrom dplyr bind_cols
#' @export
dplyr::bind_cols

#' @importFrom dplyr bind_rows
#' @export
dplyr::bind_rows

#' @importFrom dplyr c_across
#' @export
dplyr::c_across

#' @importFrom dplyr case_match
#' @export
dplyr::case_match

#' @importFrom dplyr case_when
#' @export
dplyr::case_when

#' @importFrom dplyr coalesce
#' @export
dplyr::coalesce

#' @importFrom dplyr collapse
#' @export
dplyr::collapse

#' @importFrom dplyr collect
#' @export
dplyr::collect

#' @importFrom dplyr compute
#' @export
dplyr::compute

#' @importFrom dplyr consecutive_id
#' @export
dplyr::consecutive_id

#' @importFrom dplyr count
#' @export
dplyr::count

#' @importFrom dplyr cross_join
#' @export
dplyr::cross_join

#' @importFrom dplyr cumall
#' @export
dplyr::cumall

#' @importFrom dplyr cumany
#' @export
dplyr::cumany

#' @importFrom dplyr cume_dist
#' @export
dplyr::cume_dist

#' @importFrom dplyr cummean
#' @export
dplyr::cummean

#' @importFrom dplyr cur_column
#' @export
dplyr::cur_column

#' @importFrom dplyr cur_group
#' @export
dplyr::cur_group

#' @importFrom dplyr cur_group_id
#' @export
dplyr::cur_group_id

#' @importFrom dplyr cur_group_rows
#' @export
dplyr::cur_group_rows

#' @importFrom dplyr dense_rank
#' @export
dplyr::dense_rank

#' @importFrom dplyr desc
#' @export
dplyr::desc

#' @importFrom dplyr distinct
#' @export
dplyr::distinct

#' @importFrom dplyr explain
#' @export
dplyr::explain

#' @importFrom dplyr filter
#' @export
dplyr::filter

#' @importFrom dplyr first
#' @export
dplyr::first

#' @importFrom dplyr full_join
#' @export
dplyr::full_join
#' @importFrom dplyr if_all
#' @export
dplyr::if_all

#' @importFrom dplyr if_any
#' @export
dplyr::if_any

#' @importFrom dplyr if_else
#' @export
dplyr::if_else

#' @importFrom dplyr inner_join
#' @export
dplyr::inner_join

#' @importFrom dplyr intersect
#' @export
dplyr::intersect

#' @importFrom dplyr join_by
#' @export
dplyr::join_by

#' @importFrom dplyr lag
#' @export
dplyr::lag

#' @importFrom dplyr last
#' @export
dplyr::last

#' @importFrom dplyr lead
#' @export
dplyr::lead

#' @importFrom dplyr left_join
#' @export
dplyr::left_join

#' @importFrom dplyr min_rank
#' @export
dplyr::min_rank

#' @importFrom dplyr mutate
#' @export
dplyr::mutate

#' @importFrom dplyr n
#' @export
dplyr::n

#' @importFrom dplyr n_distinct
#' @export
dplyr::n_distinct

#' @importFrom dplyr na_if
#' @export
dplyr::na_if

#' @importFrom dplyr near
#' @export
dplyr::near

#' @importFrom dplyr nest_by
#' @export
dplyr::nest_by

#' @importFrom dplyr nest_join
#' @export
dplyr::nest_join

#' @importFrom dplyr nth
#' @export
dplyr::nth

#' @importFrom dplyr ntile
#' @export
dplyr::ntile

#' @importFrom dplyr order_by
#' @export
dplyr::order_by

#' @importFrom dplyr percent_rank
#' @export
dplyr::percent_rank

#' @importFrom dplyr pick
#' @export
dplyr::pick

#' @importFrom dplyr pull
#' @export
dplyr::pull

#' @importFrom dplyr reframe
#' @export
dplyr::reframe

#' @importFrom dplyr relocate
#' @export
dplyr::relocate

#' @importFrom dplyr rename
#' @export
dplyr::rename

#' @importFrom dplyr rename_with
#' @export
dplyr::rename_with

#' @importFrom dplyr right_join
#' @export
dplyr::right_join

#' @importFrom dplyr row_number
#' @export
dplyr::row_number

#' @importFrom dplyr rows_append
#' @export
dplyr::rows_append

#' @importFrom dplyr rows_delete
#' @export
dplyr::rows_delete

#' @importFrom dplyr rows_insert
#' @export
dplyr::rows_insert

#' @importFrom dplyr rows_patch
#' @export
dplyr::rows_patch

#' @importFrom dplyr rows_update
#' @export
dplyr::rows_update

#' @importFrom dplyr rows_upsert
#' @export
dplyr::rows_upsert

#' @importFrom dplyr sample_frac
#' @export
dplyr::sample_frac

#' @importFrom dplyr sample_n
#' @export
dplyr::sample_n

#' @importFrom dplyr select
#' @export
dplyr::select

#' @importFrom dplyr semi_join
#' @export
dplyr::semi_join

#' @importFrom dplyr setdiff
#' @export
dplyr::setdiff

#' @importFrom dplyr setequal
#' @export
dplyr::setequal

#' @importFrom dplyr slice
#' @export
dplyr::slice

#' @importFrom dplyr slice_head
#' @export
dplyr::slice_head

#' @importFrom dplyr slice_max
#' @export
dplyr::slice_max

#' @importFrom dplyr slice_min
#' @export
dplyr::slice_min

#' @importFrom dplyr slice_sample
#' @export
dplyr::slice_sample

#' @importFrom dplyr slice_tail
#' @export
dplyr::slice_tail

#' @importFrom dplyr summarise
#' @export
dplyr::summarise

#' @importFrom dplyr summarize
#' @export
dplyr::summarize

#' @importFrom dplyr symdiff
#' @export
dplyr::symdiff

#' @importFrom dplyr tally
#' @export
dplyr::tally

#' @importFrom dplyr tbl_vars
#' @export
dplyr::tbl_vars

#' @importFrom dplyr top_n
#' @export
dplyr::top_n

#' @importFrom dplyr transmute
#' @export
dplyr::transmute

#' @importFrom dplyr ungroup
#' @export
dplyr::ungroup

#' @importFrom dplyr union
#' @export
dplyr::union

#' @importFrom dplyr union_all
#' @export
dplyr::union_all

#' @importFrom dplyr with_groups
#' @export
dplyr::with_groups

#' @importFrom dplyr with_order
#' @export
dplyr::with_order


#' @importFrom rlang .data
#' @export
rlang::.data


#' @importFrom tibble add_row
#' @export
tibble::add_row

#' @importFrom tibble as_tibble
#' @export
tibble::as_tibble

#' @importFrom tibble tribble
#' @export
tibble::tribble


#' @importFrom tidyselect all_of
#' @export
tidyselect::all_of

#' @importFrom tidyselect any_of
#' @export
tidyselect::any_of

#' @importFrom tidyselect contains
#' @export
tidyselect::contains

#' @importFrom tidyselect everything
#' @export
tidyselect::everything

#' @importFrom tidyselect last_col
#' @export
tidyselect::last_col

#' @importFrom tidyselect matches
#' @export
tidyselect::matches

#' @importFrom tidyselect num_range
#' @export
tidyselect::num_range

#' @importFrom tidyselect one_of
#' @export
tidyselect::one_of

#' @importFrom tidyselect starts_with
#' @export
tidyselect::starts_with

#' @importFrom tidyselect where
#' @export
tidyselect::where


# Only in this package
dplyr_mode <- FALSE

on_load({
  if (!identical(Sys.getenv("TESTTHAT"), "true") && is.null(getOption("duckdb.materialize_message"))) {
    options(duckdb.materialize_message = TRUE)
  }
})
