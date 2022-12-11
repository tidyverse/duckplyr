#' Relational expressions
#'
#' TBD.
#'
#' @param x An object.
#' @param class Classes added in front of the `"relational_expr"` base class.
#'
#' @name expr
#' @export
new_relexpr <- function(x, class = NULL) {
  structure(x, class = unique(c(class, "relational_expr")))
}

#' @param name The name of the column or function to reference.
#' @param rel The name of the relation to reference.
#' @param alias An alias for the new expression.
#' @rdname expr
#' @export
relexpr_reference <- function(name, rel = NULL, alias = NULL) {
  new_relexpr(list(name = name, rel = rel, alias = alias), class = "relational_relexpr_reference")
}

#' @param val The value to use in the constant expression.
#' @rdname expr
#' @export
relexpr_constant <- function(val, alias = NULL) {
  new_relexpr(list(val = val, alias = alias), class = "relational_relexpr_constant")
}

#' @param args Function arguments, a list of `expr` objects.
#' @rdname expr
#' @export
relexpr_function <- function(name, args, alias = NULL) {
  new_relexpr(list(name = name, args = args, alias = alias), class = "relational_relexpr_function")
}

#' @param expr An `expr` object.
#' @rdname expr
#' @export
relexpr_set_alias <- function(expr, alias = NULL) {
  expr$alias <- alias
  expr
}

#' @export
print.relational_expr <- function(x, ...) {
  writeLines(format(x, ...))
}

#' @export
format.relational_expr <- function(x, ...) {
  # FIXME: Use home-grown code
  utils::capture.output(print(constructive::construct(x)))
}
