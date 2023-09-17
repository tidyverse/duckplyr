#' @keywords internal
"_PACKAGE"

## usethis namespace: start
# @rawNamespace import(vctrs, except = data_frame)
# an alternative for importing nearly everything from vctrs
# https://github.com/tidyverse/dplyr/blob/16b472fb2afc50a87502c2b4ed803e2f5f82b9d6/R/dplyr.R#L7
#' @import rlang
#' @importFrom collections dict
#' @importFrom collections queue
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

#' @importFrom dplyr auto_copy
#' @export
dplyr::auto_copy

#' @importFrom dplyr c_across
#' @export
dplyr::c_across

#' @importFrom dplyr case_when
#' @export
dplyr::case_when

#' @importFrom dplyr collapse
#' @export
dplyr::collapse

#' @importFrom dplyr collect
#' @export
dplyr::collect

#' @importFrom dplyr compute
#' @export
dplyr::compute

#' @importFrom dplyr count
#' @export
dplyr::count

#' @importFrom dplyr cross_join
#' @export
dplyr::cross_join

#' @importFrom dplyr desc
#' @export
dplyr::desc

#' @importFrom dplyr distinct
#' @export
dplyr::distinct

#' @importFrom dplyr do
#' @export
dplyr::do

#' @importFrom dplyr dplyr_col_modify
#' @export
dplyr::dplyr_col_modify

#' @importFrom dplyr dplyr_reconstruct
#' @export
dplyr::dplyr_reconstruct

#' @importFrom dplyr dplyr_row_slice
#' @export
dplyr::dplyr_row_slice

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

#' @importFrom dplyr funs
#' @export
dplyr::funs

#' @importFrom dplyr funs_
#' @export
dplyr::funs_

#' @importFrom dplyr group_by
#' @export
dplyr::group_by

#' @importFrom dplyr group_data
#' @export
dplyr::group_data

#' @importFrom dplyr group_keys
#' @export
dplyr::group_keys

#' @importFrom dplyr group_map
#' @export
dplyr::group_map

#' @importFrom dplyr group_modify
#' @export
dplyr::group_modify

#' @importFrom dplyr group_rows
#' @export
dplyr::group_rows

#' @importFrom dplyr group_size
#' @export
dplyr::group_size

#' @importFrom dplyr group_vars
#' @export
dplyr::group_vars

#' @importFrom dplyr group_walk
#' @export
dplyr::group_walk

#' @importFrom dplyr if_all
#' @export
dplyr::if_all

#' @importFrom dplyr if_any
#' @export
dplyr::if_any

#' @importFrom dplyr inner_join
#' @export
dplyr::inner_join

#' @importFrom dplyr intersect
#' @export
dplyr::intersect

#' @importFrom dplyr is_grouped_df
#' @export
dplyr::is_grouped_df

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

#' @importFrom dplyr mutate
#' @export
dplyr::mutate

#' @importFrom dplyr mutate_all
#' @export
dplyr::mutate_all

#' @importFrom dplyr n
#' @export
dplyr::n

#' @importFrom dplyr n_distinct
#' @export
dplyr::n_distinct

#' @importFrom dplyr nest_by
#' @export
dplyr::nest_by

#' @importFrom dplyr nest_join
#' @export
dplyr::nest_join

#' @importFrom dplyr nth
#' @export
dplyr::nth

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

#' @importFrom dplyr rename_all
#' @export
dplyr::rename_all

#' @importFrom dplyr rename_at
#' @export
dplyr::rename_at

#' @importFrom dplyr rename_if
#' @export
dplyr::rename_if

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

#' @importFrom dplyr rowwise
#' @export
dplyr::rowwise

#' @importFrom dplyr same_src
#' @export
dplyr::same_src

#' @importFrom dplyr sample_frac
#' @export
dplyr::sample_frac

#' @importFrom dplyr sample_n
#' @export
dplyr::sample_n

#' @importFrom dplyr select
#' @export
dplyr::select

#' @importFrom dplyr select_all
#' @export
dplyr::select_all

#' @importFrom dplyr select_at
#' @export
dplyr::select_at

#' @importFrom dplyr select_if
#' @export
dplyr::select_if

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

#' @importFrom dplyr summarise_all
#' @export
dplyr::summarise_all

#' @importFrom dplyr summarise_at
#' @export
dplyr::summarise_at

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

#' @importFrom dplyr vars
#' @export
dplyr::vars

#' @importFrom dplyr with_groups
#' @export
dplyr::with_groups

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
