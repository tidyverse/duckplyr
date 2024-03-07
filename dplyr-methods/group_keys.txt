group_keys.data.frame <- function(.tbl, ...) {
  if (dots_n(...) > 0) {
    lifecycle::deprecate_warn(
      "1.0.0", "group_keys(... = )",
      details = "Please `group_by()` first",
      always = TRUE
    )
    .tbl <- group_by(.tbl, ...)
  }
  out <- group_data(.tbl)
  group_keys0(out)
}
