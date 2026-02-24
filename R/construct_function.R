#' Constructive options for class 'relational_relexpr_function'
#'
#' These options will be used on objects of class 'relational_relexpr_function'.
#'
#' Depending on `constructor`, we construct the object as follows:
#' * `"relexpr_function"` (default): We build the object using `relexpr_function()`.
#' * `"next"` : Use the constructor for the next supported class.
#'
#' @param constructor String. Name of the function used to construct the object.
#' @param ... Additional options used by user defined constructors through the `opts` object
#' @return An object of class <constructive_options/constructive_options_relational_relexpr_function>
#' @noRd
opts_relational_relexpr_function <- function(
  constructor = c("relexpr_function", "next"),
  ...
) {
  # What's forwarded through `...`will be accessible through the `opts`
  # object in the methods.
  # You might add arguments to the function, to document those options,
  # don't forget to forward them below as well
  constructive::.cstr_options(
    "relational_relexpr_function",
    constructor = constructor[[1]],
    ...
  )
}

.cstr_construct.relational_relexpr_function <- function(x, ...) {
  # There is probably no need for you to modify this function at all
  opts <- list(...)$opts$relational_relexpr_function %||%
    opts_relational_relexpr_function()
  if (
    is_corrupted_relational_relexpr_function(x) || opts$constructor == "next"
  ) {
    return(NextMethod())
  }
  # This odd looking code dispatches to a method based on the name of
  # the constructor rather than the class
  UseMethod(
    ".cstr_construct.relational_relexpr_function",
    structure(NA, class = opts$constructor)
  )
}

is_corrupted_relational_relexpr_function <- function(x) {
  # check here if the object has the right structure to be constructed
  # leaving FALSE is fine but you'll be vulnerable to corrupted objects
  FALSE
}

#' @export
#' @method .cstr_construct.relational_relexpr_function relexpr_function
.cstr_construct.relational_relexpr_function.relexpr_function <- function(
  x,
  ...
) {
  # If needed, fetch additional options fed through opts_relational_relexpr_function()
  # opts <- list(...)$opts$relational_relexpr_function %||% opts_relational_relexpr_function()

  # Instead of the call below we need to fetch the args of the constructor in `x`.
  args <- Filter(
    function(.x) !is.null(.x),
    list(
      x$name,
      x$args,
      alias = x$alias
    )
  )

  # This creates a call relexpr_function(...) where ... is the constructed code
  # of the arguments stored in `args`
  # Sometimes we want to construct the code of the args separately, i.e. store
  # code rather than objects in `args`, and use `recurse = FALSE` below
  code <- constructive::.cstr_apply(args, fun = "relexpr_function", ...)

  # constructive::.cstr_repair_attributes() makes sure that attributes that are not built
  # by the idiomatic constructor are generated
  constructive::.cstr_repair_attributes(
    x,
    code,
    ...,
    # attributes built by the constructor
    # ignore =,

    # not necessarily just a string, but the whole class(x) vector
    idiomatic_class = c("relational_relexpr_function", "relational_relexpr")
  )
}

on_load({
  vctrs::s3_register(
    "constructive::.cstr_construct",
    "relational_relexpr_function"
  )
})
