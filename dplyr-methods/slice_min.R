slice_min.data.frame <- function(.data, order_by, ..., n, prop, by = NULL, with_ties = TRUE, na_rm = FALSE) {
  size <- get_slice_size(n = n, prop = prop)

  dplyr_local_error_call()
  dplyr_local_slice_by_arg("by")

  slice(
    .data,
    .by = {{ by }},
    local({
      n <- dplyr::n()
      order_by <- {{ order_by }}
      vec_assert(order_by, size = n)

      slice_rank_idx(
        order_by,
        size(n),
        direction = "asc",
        with_ties = with_ties,
        na_rm = na_rm
      )
    })
  )
}
