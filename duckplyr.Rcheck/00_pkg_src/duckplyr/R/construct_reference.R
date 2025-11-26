#' Constructive options for class 'relational_relexpr_reference'
#'
#' These options will be used on objects of class 'relational_relexpr_reference'.
#'
#' Depending on `constructor`, we construct the object as follows:
#' * `"relexpr_reference"` (default): We build the object using `relexpr_reference()`.
#' * `"next"` : Use the constructor for the next supported class.
#'
#' @param constructor String. Name of the function used to construct the object.
#' @param ... Additional options used by user defined constructors through the `opts` object
#' @return An object of class <constructive_options/constructive_options_relational_relexpr_reference>
#' @noRd
opts_relational_relexpr_reference <- function(constructor = c("relexpr_reference", "next"), ...) {
  constructive::.cstr_options("relational_relexpr_reference", constructor = constructor[[1]], ...)
}

.cstr_construct.relational_relexpr_reference <- function(x, ...) {
  opts <- list(...)$opts$relational_relexpr_reference %||% opts_relational_relexpr_reference()
  if (is_corrupted_relational_relexpr_reference(x) || opts$constructor == "next") {
    return(NextMethod())
  }
  UseMethod(".cstr_construct.relational_relexpr_reference", structure(NA, class = opts$constructor))
}

is_corrupted_relational_relexpr_reference <- function(x) {
  FALSE
}

#' @export
#' @method .cstr_construct.relational_relexpr_reference relexpr_reference
.cstr_construct.relational_relexpr_reference.relexpr_reference <- function(x, ...) {
  # opts <- list(...)$opts$relational_relexpr_reference %||% opts_relational_relexpr_reference()
  args <- compact(list(
    x$name,
    rel = x$rel,
    alias = x$alias
  ))
  code <- constructive::.cstr_apply(args, fun = "relexpr_reference", ...)
  constructive::.cstr_repair_attributes(
    x, code, ...,
    idiomatic_class = c("relational_relexpr_reference", "relational_relexpr")
  )
}

on_load({
  vctrs::s3_register("constructive::.cstr_construct", "relational_relexpr_reference")
})
