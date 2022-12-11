group_split.data.frame <- function(.tbl, ..., .keep = TRUE, keep = deprecated()) {
  if (!missing(keep)) {
    lifecycle::deprecate_warn("1.0.0", "group_split(keep = )", "group_split(.keep = )", always = TRUE)
    .keep <- keep
  }
  data <- group_by(.tbl, ...)
  group_split_impl(data, .keep = .keep)
}
