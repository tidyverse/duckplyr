# https://github.com/tidyverse/duckplyr/issues/654
#
# FIXME: Remove when dplyr 1.1.5 is out

# Helpers -----------------------------------------------------------------

is_compatible <- function(x, y, ignore_col_order = TRUE, convert = TRUE) {
  if (!is.data.frame(y)) {
    return("`y` must be a data frame.")
  }

  nc <- df_n_col(x)
  if (nc != df_n_col(y)) {
    return(
      c(x = glue("Different number of columns: {nc} vs {df_n_col(y)}."))
    )
  }

  names_x <- names(x)
  names_y <- names(y)

  names_y_not_in_x <- setdiff(names_y, names_x)
  names_x_not_in_y <- setdiff(names_x, names_y)

  if (length(names_y_not_in_x) == 0L && length(names_x_not_in_y) == 0L) {
    # check if same order
    if (!isTRUE(ignore_col_order)) {
      if (!identical(names_x, names_y)) {
        return(c(x = "Same column names, but different order."))
      }
    }
  } else {
    # names are not the same, explain why

    msg <- c()
    if (length(names_y_not_in_x)) {
      wrong <- glue_collapse(glue('`{names_y_not_in_x}`'), sep = ", ")
      msg <- c(
        msg,
        x = glue("Cols in `y` but not `x`: {wrong}.")
      )
    }
    if (length(names_x_not_in_y)) {
      wrong <- glue_collapse(glue('`{names_x_not_in_y}`'), sep = ", ")
      msg <- c(
        msg,
        x = glue("Cols in `x` but not `y`: {wrong}.")
      )
    }
    return(msg)
  }

  msg <- c()
  for (name in names_x) {
    x_i <- x[[name]]
    y_i <- y[[name]]

    if (convert) {
      tryCatch(
        vec_ptype2(x_i, y_i),
        error = function(e) {
          msg <<- c(
            msg,
            x = glue(
              "Incompatible types for column `{name}`: {vec_ptype_full(x_i)} vs {vec_ptype_full(y_i)}."
            )
          )
        }
      )
    } else {
      if (!identical(vec_ptype(x_i), vec_ptype(y_i))) {
        msg <- c(
          msg,
          x = glue(
            "Different types for column `{name}`: {vec_ptype_full(x_i)} vs {vec_ptype_full(y_i)}."
          )
        )
      }
    }
  }
  if (length(msg)) {
    return(msg)
  }

  TRUE
}

check_compatible <- function(
  x,
  y,
  ignore_col_order = TRUE,
  convert = TRUE,
  error_call = caller_env()
) {
  compat <- is_compatible(
    x,
    y,
    ignore_col_order = ignore_col_order,
    convert = convert
  )
  if (isTRUE(compat)) {
    return()
  }

  abort(c("`x` and `y` are not compatible.", compat), call = error_call)
}
