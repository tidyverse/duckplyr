#' Constructive options for class 'relational_relexpr_window'
#'
#' These options will be used on objects of class 'relational_relexpr_window'.
#'
#' Depending on `constructor`, we construct the object as follows:
#' * `"relexpr_window"` (default): We build the object using `relexpr_window()`.
#' * `"next"` : Use the constructor for the next supported class.
#'
#' @param constructor String. Name of the function used to construct the object.
#' @param ... Additional options used by user defined constructors through the `opts` object
#' @return An object of class <constructive_options/constructive_options_relational_relexpr_window>
#' @noRd
opts_relational_relexpr_window <- function(constructor = c("relexpr_window", "next"), ...) {
  constructive::.cstr_options("relational_relexpr_window", constructor = constructor[[1]], ...)
}

.cstr_construct.relational_relexpr_window <- function(x, ...) {
  opts <- list(...)$opts$relational_relexpr_window %||% opts_relational_relexpr_window()
  if (is_corrupted_relational_relexpr_window(x) || opts$constructor == "next") {
    return(NextMethod())
  }
  UseMethod(".cstr_construct.relational_relexpr_window", structure(NA, class = opts$constructor))
}

is_corrupted_relational_relexpr_window <- function(x) {
  FALSE
}

#' @export
#' @method .cstr_construct.relational_relexpr_window relexpr_window
.cstr_construct.relational_relexpr_window.relexpr_window <- function(x, ...) {
  # opts <- list(...)$opts$relational_relexpr_window %||% opts_relational_relexpr_window()
  args <- Filter(function(.x) !is.null(.x), list(
    x$expr,
    x$partitions,
    order_bys = if (length(x$order_bys) > 0) x$order_bys,
    offset_expr = x$offset_expr,
    default_expr = x$default_expr,
    alias = x$alias
  ))
  code <- constructive::.cstr_apply(args, fun = "relexpr_window", ...)
  constructive::.cstr_repair_attributes(
    x, code, ...,
    idiomatic_class = c("relational_relexpr_window", "relational_relexpr")
  )
}

on_load({
  vctrs::s3_register("constructive::.cstr_construct", "relational_relexpr_window")
})
