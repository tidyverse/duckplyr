#' Verbs not implemented in duckplyr
#'
#' The following dplyr generics have no counterpart method in duckplyr.
#' If you want to help add a new verb, 
#' please refer to our contributing guide <https://duckplyr.tidyverse.org/CONTRIBUTING.html#support-new-verbs>
#' @rdname not-supported
#' @name not-supported
#' @section Unsupported verbs:
#' For these verbs, duckplyr will fall back to dplyr.
#' - [`add_count()`]
#' - [`compute()`]
#' - [`cross_join()`]
#' - [`do()`]
#' - [`group_by()`]
#' - [`group_indices()`]
#' - [`group_keys()`]
#' - [`group_map()`]
#' - [`group_modify()`]
#' - [`group_nest()`]
#' - [`group_size()`]
#' - [`group_split()`]
#' - [`group_trim()`]
#' - [`groups()`]
#' - [`n_groups()`]
#' - [`nest_by()`]
#' - [`nest_join()`]
#' - [`reframe()`]
#' - [`rename_with()`]
#' - [`rows_append()`]
#' - [`rows_delete()`]
#' - [`rows_insert()`]
#' - [`rows_patch()`]
#' - [`rows_update()`]
#' - [`rows_upsert()`]
#' - [`rowwise()`]
#' - [`setequal()`]
#' - [`slice_head()`]
#' - [`slice_sample()`]
#' - [`slice_tail()`]
#' - [`slice()`]
#' - [`ungroup()`]
NULL
