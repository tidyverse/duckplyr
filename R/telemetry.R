call_to_json <- function(cnd, call) {
  name_map <- get_name_map(c(names(call$x), names(call$y), names(call$args$dots)))
  if (!is.null(names(call$args$dots))) {
    names(call$args$dots) <- name_map[names2(call$args$dots)]
  }

  out <- list2(
    message = conditionMessage(cnd),
    name = call$name,
    x = df_to_json(call$x, name_map),
    y = df_to_json(call$y, name_map),
    args = map(compact(call$args), arg_to_json, name_map)
  )

  jsonlite::toJSON(compact(out), auto_unbox = TRUE, null = "null")
}

get_name_map <- function(x) {
  unique <- unique(x)
  new_names <- paste0("...", seq_along(unique))
  names(new_names) <- unique
  new_names
}

df_to_json <- function(df, name_map) {
  if (is.null(df)) {
    return(NULL)
  }
  if (length(df) == 0) {
    return(list())
  }

  out <- map(df, ~ paste0(class(.x), collapse = "/"))
  names(out) <- name_map[names(df)]
  out
}

arg_to_json <- function(x, name_map) {
  if (is.atomic(x)) {
    x
  } else if (is_quosures(x)) {
    quos_to_json(x, name_map)
  } else if (is_quosure(x)) {
    quo_to_json(x, name_map)
  } else if (is_call(x)) {
    expr_to_json(x, name_map)
  } else {
    paste0("Can't translate object of class ", paste(class(x), collapse = "/"))
  }
}

quos_to_json <- function(x, name_map) {
  map(x, ~ quo_to_json(.x, name_map))
}

quo_to_json <- function(x, name_map) {
  expr_to_json(quo_get_expr(x), name_map)
}

expr_to_json <- function(x, name_map) {
  scrubbed <- expr_scrub(x, name_map)
  expr_deparse(scrubbed, width = 500L)
}

expr_scrub <- function(x, name_map) {
  do_scrub <- function(xx, callee = FALSE) {
    if (is_symbol(xx)) {
      match <- name_map[as.character(xx)]
      if (is.na(match)) {
        xx
      } else {
        sym(unname(match))
      }
    } else if (is_call(xx)) {
      args <- map(as.list(xx)[-1], do_scrub)
      call2(do_scrub(xx[[1]], callee = TRUE), !!!args)
    } else {
      paste0("Don't know how to scrub ", paste(class(xx), collapse = "/"))
    }
  }

  do_scrub(x)
}
