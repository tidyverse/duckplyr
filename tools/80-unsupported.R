check_r_script <- function(path) {
  lines <- readLines(path)

  not_implemented <- any(grepl("No relational implementation for ", lines))

  if (not_implemented) {
    return(tools::file_path_sans_ext(basename(path)))
  } else {
    return(NULL)
  }
}

r_scripts <- list.files("R", full.names = TRUE)

not_implemented <- unlist(lapply(r_scripts, check_r_script))

not_implemented_script <- file.path("R", "not-supported.R")

unlink(not_implemented_script, force = TRUE)

lines <- c(
  "#' Verbs not implemented in duckplyr",
  "#'",
  "#' The following dplyr generics have no counterpart method in duckplyr.",
  "#' If you want to help add a new verb, ",
  "#' please refer to our contributing guide <https://duckplyr.tidyverse.org/CONTRIBUTING.html#support-new-verbs>",
  "#' @rdname not-supported",
  "#' @name not-supported",
  "#' @section Unsupported verbs:",
  "#' For these verbs, duckplyr will fall back to dplyr.",
  paste(paste0("#' - [`", not_implemented, "()`]"), collapse = "\n"),
  "NULL"
)

writeLines(lines, not_implemented_script)
devtools::document()
