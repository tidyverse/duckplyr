call_to_json <- function(cnd, call) {
  out <- list2(
    message = conditionMessage(cnd),
    name = call$name,
    x = df_to_json(call$x),
    y = df_to_json(call$y, names(call$x)),
    args = map(call$args, arg_to_json, unique(c(names(call$x), names(call$y))))
  )

  jsonlite::toJSON(compact(out), auto_unbox = TRUE)
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
  } else if (is_quosures(x)) {
    quos_to_json(x, known_names)
  } else if (is_quosure(x)) {
    quo_to_json(x, known_names)
  } else if (is_call(x)) {
    expr_to_json(x, known_names)
  } else {
    paste0("Can't translate object of class ", paste(class(x), collapse = "/"))
  }
}

quos_to_json <- function(x, known_names) {
  map(x, ~ quo_to_json(.x, known_names))
}

quo_to_json <- function(x, known_names) {
  expr_to_json(quo_get_expr(x), known_names)
}

expr_to_json <- function(x, known_names) {
  scrubbed <- expr_scrub(x, known_names)
  expr_deparse(scrubbed, width = 500L)
}

expr_scrub <- function(x, known_names) {
  do_scrub <- function(xx) {
    if (is_call(xx)) {
      args <- map(as.list(xx)[-1], do_scrub)
      call2(xx[[1]], !!!args)
    } else if (is_symbol(xx)) {
      match <- match(as.character(xx), known_names)
      if (is.na(match)) {
        xx
      } else {
        sym(paste0("...", match))
      }
    } else {
      paste0("Don't know how to scrub ", paste(class(xx), collapse = "/"))
    }
  }

  do_scrub(x)
}
