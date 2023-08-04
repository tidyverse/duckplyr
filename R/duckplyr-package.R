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
#' @importFrom dplyr add_tally
#' @importFrom dplyr all_equal
#' @importFrom dplyr c_across
#' @importFrom dplyr case_when
#' @importFrom dplyr collapse
#' @importFrom dplyr collect
#' @importFrom dplyr compute
#' @importFrom dplyr count
#' @importFrom dplyr desc
#' @importFrom dplyr dplyr_col_modify
#' @importFrom dplyr dplyr_row_slice
#' @importFrom dplyr first
#' @importFrom dplyr funs
#' @importFrom dplyr funs_
#' @importFrom dplyr group_by
#' @importFrom dplyr group_data
#' @importFrom dplyr group_keys
#' @importFrom dplyr group_map
#' @importFrom dplyr group_modify
#' @importFrom dplyr group_rows
#' @importFrom dplyr group_size
#' @importFrom dplyr group_walk
#' @importFrom dplyr if_all
#' @importFrom dplyr if_any
#' @importFrom dplyr is_grouped_df
#' @importFrom dplyr join_by
#' @importFrom dplyr lag
#' @importFrom dplyr last
#' @importFrom dplyr lead
#' @importFrom dplyr mutate_all
#' @importFrom dplyr n
#' @importFrom dplyr n_distinct
#' @importFrom dplyr nth
#' @importFrom dplyr rename_all
#' @importFrom dplyr rename_at
#' @importFrom dplyr rename_if
#' @importFrom dplyr row_number
#' @importFrom dplyr rowwise
#' @importFrom dplyr same_src
#' @importFrom dplyr select_all
#' @importFrom dplyr select_at
#' @importFrom dplyr select_if
#' @importFrom dplyr slice_head
#' @importFrom dplyr slice_max
#' @importFrom dplyr slice_min
#' @importFrom dplyr slice_sample
#' @importFrom dplyr slice_tail
#' @importFrom dplyr summarise_all
#' @importFrom dplyr summarise_at
#' @importFrom dplyr summarize
#' @importFrom dplyr tally
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
