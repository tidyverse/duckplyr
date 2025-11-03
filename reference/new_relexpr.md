# Relational expressions

These functions provide a backend-agnostic way to construct expression
trees built of column references, constants, and functions. All
subexpressions in an expression tree can have an alias.

`new_relexpr()` constructs an object of class `"relational_relexpr"`. It
is used by the higher-level constructors, users should rarely need to
call it directly.

`relexpr_reference()` constructs a reference to a column.

`relexpr_constant()` wraps a constant value.

`relexpr_function()` applies a function. The arguments to this function
are a list of other expression objects.

`relexpr_comparison()` wraps a comparison expression.

`relexpr_window()` applies a function over a window, similarly to the
SQL `OVER` clause.

`relexpr_set_alias()` assigns an alias to an expression.

## Usage

``` r
new_relexpr(x, class = NULL)

relexpr_reference(name, rel = NULL, alias = NULL)

relexpr_constant(val, alias = NULL)

relexpr_function(name, args, alias = NULL)

relexpr_comparison(cmp_op, exprs)

relexpr_window(
  expr,
  partitions,
  order_bys = list(),
  offset_expr = NULL,
  default_expr = NULL,
  alias = NULL
)

relexpr_set_alias(expr, alias = NULL)
```

## Arguments

- x:

  An object.

- class:

  Classes added in front of the `"relational_relexpr"` base class.

- name:

  The name of the column or function to reference.

- rel:

  The name of the relation to reference.

- alias:

  An alias for the new expression.

- val:

  The value to use in the constant expression.

- args:

  Function arguments, a list of `expr` objects.

- cmp_op:

  Comparison operator, e.g., `"<"` or `"=="`.

- exprs:

  Expressions to compare, a list of `expr` objects.

- expr:

  An `expr` object.

- partitions:

  Partitions, a list of `expr` objects.

- order_bys:

  which variables to order results by (list).

- offset_expr:

  offset relational expression.

- default_expr:

  default relational expression.

## Value

an object of class `"relational_relexpr"`

an object of class `"relational_relexpr"`

an object of class `"relational_relexpr"`

an object of class `"relational_relexpr"`

an object of class `"relational_relexpr"`

an object of class `"relational_relexpr"`

## Examples

``` r
relexpr_set_alias(
  alias = "my_predicate",
  relexpr_function(
    "<",
    list(
      relexpr_reference("my_number"),
      relexpr_constant(42)
    )
  )
)
#> List of 3
#>  $ name : chr "<"
#>  $ args :List of 2
#>   ..$ :List of 3
#>   .. ..$ name : chr "my_number"
#>   .. ..$ rel  : NULL
#>   .. ..$ alias: NULL
#>   .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
#>   ..$ :List of 2
#>   .. ..$ val  : num 42
#>   .. ..$ alias: NULL
#>   .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_constant" "relational_relexpr"
#>  $ alias: chr "my_predicate"
#>  - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
```
