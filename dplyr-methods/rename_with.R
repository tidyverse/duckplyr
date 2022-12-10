rename_with.data.frame <- function(.data, .fn, .cols = everything(), ...) {
  .fn <- as_function(.fn)
  cols <- tidyselect::eval_select(enquo(.cols), .data, allow_rename = FALSE)

  names <- names(.data)

  sel <- vec_slice(names, cols)
  new <- .fn(sel, ...)

  if (!is_character(new)) {
    cli::cli_abort(
      "{.arg .fn} must return a character vector, not {.obj_type_friendly {new}}."
    )
  }
  if (length(new) != length(sel)) {
    cli::cli_abort(
      "{.arg .fn} must return a vector of length {length(sel)}, not {length(new)}."
    )
  }

  names <- vec_assign(names, cols, new)
  names <- vec_as_names(names, repair = "check_unique")

  set_names(.data, names)
}
