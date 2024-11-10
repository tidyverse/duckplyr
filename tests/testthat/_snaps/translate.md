# call with named argument

    Code
      rel_translate(quo(c(1, b = 2)))
    Condition
      Error in `rel_find_call()`:
      ! No translation for function `c`.

# a %in% b

    Code
      rel_translate(quo(a %in% b), data.frame(a = 1:3, b = 2:4))
    Condition
      Error:
      ! Can't access data in this context

# comparison expression translated

    Code
      rel_translate(quo(a > 123L), df)
    Output
      List of 2
       $ exprs :List of 2
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ :List of 2
        .. ..$ val  : int 123
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_constant" "relational_relexpr"
       $ cmp_op: chr ">"
       - attr(*, "class")= chr [1:2] "relational_relexpr_comparison" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(quo(a > 123), df)
    Output
      List of 2
       $ exprs :List of 2
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ :List of 2
        .. ..$ val  : num 123
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_constant" "relational_relexpr"
       $ cmp_op: chr ">"
       - attr(*, "class")= chr [1:2] "relational_relexpr_comparison" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(quo(a == b), df)
    Output
      List of 2
       $ exprs :List of 2
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ :List of 3
        .. ..$ name : chr "b"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ cmp_op: chr "=="
       - attr(*, "class")= chr [1:2] "relational_relexpr_comparison" "relational_relexpr"
       - attr(*, "used")= chr [1:2] "a" "b"

---

    Code
      rel_translate(quo(a <= c), df)
    Output
      List of 2
       $ exprs :List of 2
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ :List of 3
        .. ..$ name : chr "c"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ cmp_op: chr "<="
       - attr(*, "class")= chr [1:2] "relational_relexpr_comparison" "relational_relexpr"
       - attr(*, "used")= chr [1:2] "a" "c"

