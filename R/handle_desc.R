#' Used in arrange()
handle_desc <- function(dots) {
  # Handles calls to 'desc' function by
  # - extracting the sort order
  # - removing any desc-function calls from the expressions: desc(colname) -> colname
  ascending <- rep(TRUE, length(dots))

  for (i in seq_along(dots)) {
    expr <- quo_get_expr(dots[[i]])

    if (!is.call(expr))       next
    if (expr[[1]] != "desc")  next

    # Check that desc is called with a single argument
    # (dplyr::desc() accepts only one argument)
    if (length(expr) > 2) cli::cli_abort("`desc()` must be called with exactly one argument.")

    ascending[i] <- FALSE
    dots[[i]]    <- new_quosure(expr[[2]], env = quo_get_env(dots[[i]]))
  }

  list(dots = dots, ascending = ascending)
}
