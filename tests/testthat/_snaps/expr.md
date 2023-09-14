# can construct expressions

    Code
      relexpr_reference("column")
    Output
      List of 3
       $ name : chr "column"
       $ rel  : NULL
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
    Code
      relexpr_constant(42)
    Output
      List of 2
       $ val  : num 42
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_constant" "relational_relexpr"
    Code
      relexpr_function("+", list(relexpr_reference("column"), relexpr_constant(42,
        alias = "fortytwo")))
    Output
      List of 3
       $ name : chr "+"
       $ args :List of 2
        ..$ :List of 3
        .. ..$ name : chr "column"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ :List of 2
        .. ..$ val  : num 42
        .. ..$ alias: chr "fortytwo"
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_constant" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"

