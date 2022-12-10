slice_sample.data.frame <- function(.data, ..., n, prop, by = NULL, weight_by = NULL, replace = FALSE) {
  size <- get_slice_size(n = n, prop = prop, allow_outsize = replace)

  dplyr_local_error_call()
  dplyr_local_slice_by_arg("by")

  slice(
    .data,
    .by = {{ by }},
    local({
      weight_by <- {{ weight_by }}

      n <- dplyr::n()
      if (!is.null(weight_by)) {
        weight_by <- vec_assert(weight_by, size = n, arg = "weight_by")
      }
      sample_int(n, size(n), replace = replace, wt = weight_by)
    })
  )
}
