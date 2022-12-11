slice_head.data.frame <- function(.data, ..., n, prop, by = NULL) {
  size <- get_slice_size(n = n, prop = prop)
  idx <- function(n) {
    seq2(1, size(n))
  }

  dplyr_local_error_call()
  dplyr_local_slice_by_arg("by")

  slice(.data, idx(dplyr::n()), .by = {{ by }})
}
