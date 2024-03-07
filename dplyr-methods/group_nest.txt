group_nest.data.frame <- function(.tbl, ..., .key = "data", keep = FALSE) {
  if (dots_n(...)) {
    group_nest_impl(group_by(.tbl, ...), .key = .key, keep = keep)
  } else {
    tibble(!!.key := list(.tbl))
  }
}
