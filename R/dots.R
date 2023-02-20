fix_auto_name <- function(dots) {
  if (is.null(names(dots))) {
    dots <- set_names(dots, "")
  }

  for (i in seq_along(dots)) {
    dot <- dots[[i]]
    if (names(dots)[[i]] == "") {
      quo_data <- attr(dot, "dplyr:::data")
      names(dots)[[i]] <- quo_data$name_auto
    }
  }

  dots
}
