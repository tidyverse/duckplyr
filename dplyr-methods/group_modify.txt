group_modify.data.frame <- function(.data, .f, ..., .keep = FALSE, keep = deprecated()) {
  if (!missing(keep)) {
    lifecycle::deprecate_warn("1.0.0", "group_modify(keep = )", "group_modify(.keep = )", always = TRUE)
    .keep <- keep
  }
  .f <- as_group_map_function(.f)
  .f(.data, group_keys(.data), ...)
}
