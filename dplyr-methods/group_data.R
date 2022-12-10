group_data.data.frame <- function(.data) {
  rows <- new_list_of(list(seq_len(nrow(.data))), ptype = integer())
  new_data_frame(list(.rows = rows), n = 1L)
}
