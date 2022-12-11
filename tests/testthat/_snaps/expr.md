# can construct expressions

    Code
      relexpr_reference("column")
    Output
      list(name = "column", rel = NULL, alias = NULL) |>
        structure(class = c("relational_relexpr_reference", "relational_expr"))
    Code
      relexpr_constant(42)
    Output
      list(val = 42, alias = NULL) |>
        structure(class = c("relational_relexpr_constant", "relational_expr"))
    Code
      relexpr_function("+", list(relexpr_reference("column"), relexpr_constant(42,
        alias = "fortytwo")))
    Output
      list(
        name = "+",
        args = list(
          list(name = "column", rel = NULL, alias = NULL) |>
            structure(class = c("relational_relexpr_reference", "relational_expr")),
          list(val = 42, alias = "fortytwo") |>
            structure(class = c("relational_relexpr_constant", "relational_expr"))
        ),
        alias = NULL
      ) |>
        structure(class = c("relational_relexpr_function", "relational_expr"))

