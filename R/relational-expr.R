#' Relational expressions
#'
#' @description
#' These functions provide a backend-agnostic way to construct expression trees
#' built of column references, constants, and functions.
#' All subexpressions in an expression tree can have an alias.
#'
#' `new_relexpr()` constructs an object of class `"relational_relexpr"`.
#' It is used by the higher-level constructors,
#' users should rarely need to call it directly.
#'
#' @param x An object.
#' @param class Classes added in front of the `"relational_relexpr"` base class.
#'
#' @name new_relexpr
#' @return an object of class `"relational_relexpr"`
#' @export
#' @examples
#' relexpr_set_alias(
#'   alias = "my_predicate",
#'   relexpr_function(
#'     "<",
#'     list(
#'       relexpr_reference("my_number"),
#'       relexpr_constant(42)
#'     )
#'   )
#' )
new_relexpr <- function(x, class = NULL) {
  structure(x, class = unique(c(class, "relational_relexpr"), fromLast = TRUE))
}

#' relexpr_reference
#'
#' `relexpr_reference()` constructs a reference to a column.
#'
#' @param name The name of the column or function to reference.
#' @param rel The name of the relation to reference.
#' @param alias An alias for the new expression.
#' @rdname new_relexpr
#' @return an object of class `"relational_relexpr"`
#' @export
relexpr_reference <- function(name, rel = NULL, alias = NULL) {
  stopifnot(is_string(name))
  stopifnot(is.null(rel) || inherits(rel, "duckdb_relation"))
  stopifnot(is.null(alias) || is_string(alias))
  new_relexpr(list(name = name, rel = rel, alias = alias), class = "relational_relexpr_reference")
}

#' relexpr_constant
#'
#' `relexpr_constant()` wraps a constant value.
#'
#' @param val The value to use in the constant expression.
#' @rdname new_relexpr
#' @return an object of class `"relational_relexpr"`
#' @export
relexpr_constant <- function(val, alias = NULL) {
  stopifnot(length(val) == 1)
  stopifnot(is.null(alias) || is_string(alias))
  new_relexpr(list(val = val, alias = alias), class = "relational_relexpr_constant")
}

#' relexpr_function
#'
#' `relexpr_function()` applies a function.
#' The arguments to this function are a list of other expression objects.
#'
#' @param args Function arguments, a list of `expr` objects.
#' @rdname new_relexpr
#' @return an object of class `"relational_relexpr"`
#' @export
relexpr_function <- function(name, args, alias = NULL) {
  stopifnot(is_string(name))
  stopifnot(is.list(args))
  stopifnot(is.null(alias) || is_string(alias))
  new_relexpr(list(name = name, args = args, alias = alias), class = "relational_relexpr_function")
}

#' relexpr_comparison
#'
#' `relexpr_comparison()` wraps a comparison expression
#'
#' @param exprs Expressions to compare, a list of `expr` objects.
#' @param cmp_op Comparison operator, eg. "<" or "="
#' @rdname new_relexpr
#' @return an object of class `"relational_relexpr"`
#' @export
relexpr_comparison <- function(exprs, cmp_op) {
  stopifnot(is_string(cmp_op))
  stopifnot(is.list(exprs))
  new_relexpr(list(exprs = exprs, cmp_op = cmp_op), class = "relational_relexpr_comparison")
}


#' relexpr_window
#'
#' `relexpr_window()` applies a function over a window,
#' similarly to the SQL `OVER` clause.
#'
#' @param partitions Partitions, a list of `expr` objects.
#' @param order_bys which variables to order results by (list).
#' @param offset_expr offset relational expression.
#' @param default_expr default relational expression.
#' @rdname new_relexpr
#' @export
relexpr_window <- function(
    expr,
    partitions,
    order_bys = list(),
    offset_expr = NULL,
    default_expr = NULL,
    alias = NULL) {
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

#' relexpr_set_alias
#'
#' `relexpr_set_alias()` assigns an alias to an expression.
#'
#' @param expr An `expr` object.
#' @rdname new_relexpr
#' @return an object of class `"relational_relexpr"`
#' @export
relexpr_set_alias <- function(expr, alias = NULL) {
  stopifnot(inherits(expr, "relational_relexpr"))
  stopifnot(is.null(alias) || is_string(alias))
  expr$alias <- alias
  expr
}

#' @export
print.relational_relexpr <- function(x, ...) {
  utils::str(x)
  invisible(x)
}
