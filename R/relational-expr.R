#' Relational expressions
#'
#' TBD.
#'
#' @param x An object.
#' @param class Classes added in front of the `"relational_relexpr"` base class.
#'
#' @name expr
#' @export
new_relexpr <- function(x, class = NULL) {
  structure(x, class = unique(c(class, "relational_relexpr")))
}

#' @param name The name of the column or function to reference.
#' @param rel The name of the relation to reference.
#' @param alias An alias for the new expression.
#' @rdname expr
#' @export
relexpr_reference <- function(name, rel = NULL, alias = NULL) {
  stopifnot(is_string(name))
  stopifnot(is.null(rel) || inherits(rel, "duckdb_relation"))
  stopifnot(is.null(alias) || is_string(alias))
  new_relexpr(list(name = name, rel = rel, alias = alias), class = "relational_relexpr_reference")
}

#' @param val The value to use in the constant expression.
#' @rdname expr
#' @export
relexpr_constant <- function(val, alias = NULL) {
  stopifnot(length(val) == 1)
  stopifnot(is.null(alias) || is_string(alias))
  new_relexpr(list(val = val, alias = alias), class = "relational_relexpr_constant")
}

#' @param args Function arguments, a list of `expr` objects.
#' @rdname expr
#' @export
relexpr_function <- function(name, args, alias = NULL) {
  stopifnot(is_string(name))
  stopifnot(is.list(args))
  stopifnot(is.null(alias) || is_string(alias))
  new_relexpr(list(name = name, args = args, alias = alias), class = "relational_relexpr_function")
}

#' @param partitions Partitions, a list of `expr` objects.
#' @param order_bys which variables to order results by (list).
#' @param offset_expr offset relational expression.
#' @param default_expr default relational expression.
#' @rdname expr
#' @export
relexpr_window <- function(
    expr,
    partitions,
    order_bys = list(),
    offset_expr = NULL,
    default_expr = NULL,
    alias = NULL
) {
  stopifnot(inherits(expr, "relational_relexpr"))
  stopifnot(is.list(partitions))
  stopifnot(is.list(order_bys))
  stopifnot(is.null(offset_expr) || inherits(offset_expr, "relational_relexpr"))
  stopifnot(is.null(default_expr) || inherits(default_expr, "relational_relexpr"))
  stopifnot(is.null(alias) || is_string(alias))
  new_relexpr(
    list(
      expr = expr,
      partitions = partitions,
      order_bys = order_bys,
      offset_expr = offset_expr,
      default_expr = default_expr,
      alias = alias
    ),
    class = "relational_relexpr_window"
  )
}

#' @param expr An `expr` object.
#' @rdname expr
#' @export
relexpr_set_alias <- function(expr, alias = NULL) {
  stopifnot(inherits(expr, "relational_relexpr"))
  stopifnot(is.null(alias) || is_string(alias))
  expr$alias <- alias
  expr
}

#' @export
print.relational_relexpr <- function(x, ...) {
  writeLines(format(x, ...))
}

#' @export
format.relational_relexpr <- function(x, ...) {
  # FIXME: Use home-grown code
  utils::capture.output(print(constructive::construct(x)))
}
