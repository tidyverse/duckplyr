# can construct expressions

    Code
      relexpr_reference("column")
    Condition
      Warning in `normalizePath()`:
      path[1]="": No such file or directory
      Warning in `normalizePath()`:
      path[1]="": No such file or directory
      Warning in `normalizePath()`:
      path[1]="": No such file or directory
    Output
      list(name = "column", rel = NULL, alias = NULL) |>
        structure(class = c("relational_relexpr_reference", "relational_relexpr"))
    Code
      relexpr_constant(42)
    Output
      list(val = 42, alias = NULL) |>
        structure(class = c("relational_relexpr_constant", "relational_relexpr"))
    Code
      relexpr_function("+", list(relexpr_reference("column"), relexpr_constant(42,
        alias = "fortytwo")))
    Output
      list(
        name = "+",
        args = list(
          list(name = "column", rel = NULL, alias = NULL) |>
            structure(class = c("relational_relexpr_reference", "relational_relexpr")),
          list(val = 42, alias = "fortytwo") |>
            structure(class = c("relational_relexpr_constant", "relational_relexpr"))
        ),
        alias = NULL
      ) |>
        structure(class = c("relational_relexpr_function", "relational_relexpr"))

