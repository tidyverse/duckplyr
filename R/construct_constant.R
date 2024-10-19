#' Constructive options for class 'relational_relexpr_constant'
#'
#' These options will be used on objects of class 'relational_relexpr_constant'.
#'
#' Depending on `constructor`, we construct the object as follows:
#' * `"relexpr_constant"` (default): We build the object using `relexpr_constant()`.
#' * `"next"` : Use the constructor for the next supported class.
#'
#' @param constructor String. Name of the function used to construct the object.
#' @param ... Additional options used by user defined constructors through the `opts` object
#' @return An object of class <constructive_options/constructive_options_relational_relexpr_constant>
#' @noRd
opts_relational_relexpr_constant <- function(constructor = c("relexpr_constant", "next"), ...) {
  constructive::.cstr_options("relational_relexpr_constant", constructor = constructor[[1]], ...)
}

.cstr_construct.relational_relexpr_constant <- function(x, ...) {
  opts <- list(...)$opts$relational_relexpr_constant %||% opts_relational_relexpr_constant()
  if (is_corrupted_relational_relexpr_constant(x) || opts$constructor == "next") {
    return(NextMethod())
  }
  UseMethod(".cstr_construct.relational_relexpr_constant", structure(NA, class = opts$constructor))
}

is_corrupted_relational_relexpr_constant <- function(x) {
  FALSE
}

#' @export
#' @method .cstr_construct.relational_relexpr_constant relexpr_constant
.cstr_construct.relational_relexpr_constant.relexpr_constant <- function(x, ...) {
  # opts <- list(...)$opts$relational_relexpr_constant %||% opts_relational_relexpr_constant()
  args <- compact(list(
    x$val,
    alias = x$alias
  ))
  code <- constructive::.cstr_apply(args, fun = "relexpr_constant", ...)
  constructive::.cstr_repair_attributes(
    x, code, ...,
    idiomatic_class = c("relational_relexpr_constant", "relational_relexpr")
  )
}

on_load({
  vctrs::s3_register("constructive::.cstr_construct", "relational_relexpr_constant")
})
