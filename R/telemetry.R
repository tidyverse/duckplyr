call_to_json <- function(call) {
  out <- list2(
    name = call$name,
    x = df_to_json(call$x),
    y = df_to_json(call$y, names(call$x)),
    args = map(compact(call$args), arg_to_json, unique(c(names(call$x), names(call$y))))
  )

  jsonlite::toJSON(compact(out), auto_unbox = TRUE, null = "null")
}

df_to_json <- function(df, known_names = NULL) {
  if (is.null(df)) {
    return(NULL)
  }
  if (length(df) == 0) {
    return(list())
  }
  new_names <- paste0("...", seq_along(df))
  known <- match(names(df), known_names)
  new_names[!is.na(known)] <- known_names[known[!is.na(known)]]

  out <- map(df, ~ paste0(class(.x), collapse = "/"))
  names(out) <- new_names
  out
}

arg_to_json <- function(x, known_names) {
  if (is.atomic(x)) {
    x
  } else {
    paste0("Can't translate object of class ", paste(class(x), collapse = "/"))
  }
}
