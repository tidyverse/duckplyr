# call with named argument

    Code
      rel_translate(quo(c(1, b = 2)))
    Condition
      Error:
      ! No translation for function `c()`.

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
       $ cmp_op: chr ">"
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
       - attr(*, "class")= chr [1:2] "relational_relexpr_comparison" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(quo(a > 123), df)
    Output
      List of 2
       $ cmp_op: chr ">"
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
       - attr(*, "class")= chr [1:2] "relational_relexpr_comparison" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(quo(a == b), df)
    Output
      List of 2
       $ cmp_op: chr "=="
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
       - attr(*, "class")= chr [1:2] "relational_relexpr_comparison" "relational_relexpr"
       - attr(*, "used")= chr [1:2] "a" "b"

---

    Code
      rel_translate(quo(a <= c), df)
    Output
      List of 2
       $ cmp_op: chr "<="
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
       - attr(*, "class")= chr [1:2] "relational_relexpr_comparison" "relational_relexpr"
       - attr(*, "used")= chr [1:2] "a" "c"

# aggregation primitives

    Code
      rel_translate(expr(sum(a)), df)
    Output
      List of 3
       $ name : chr "___sum_na"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(sum(a, b)), df)
    Condition
      Error:
      ! `sum()` needs exactly one argument besides the optional `na.rm`

---

    Code
      rel_translate(expr(sum(a, na.rm = TRUE)), df)
    Output
      List of 3
       $ name : chr "sum"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(sum(a, na.rm = FALSE)), df)
    Output
      List of 3
       $ name : chr "___sum_na"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(sum(a, na.rm = b)), df)
    Condition
      Error:
      ! object 'b' not found

---

    Code
      rel_translate(expr(sum(a, na.rm = 1)), df)
    Condition
      Error:
      ! Invalid value for `na.rm` in call to `sum()`

---

    Code
      rel_translate(expr(sum(a)), df, need_window = TRUE)
    Condition
      Error:
      ! `sum(na.rm = FALSE)` not supported in window functions
      i Use `sum(na.rm = TRUE)` after checking for missing values

---

    Code
      rel_translate(expr(min(a)), df)
    Output
      List of 3
       $ name : chr "___min_na"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(min(a, na.rm = TRUE)), df)
    Output
      List of 3
       $ name : chr "min"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(max(a)), df)
    Output
      List of 3
       $ name : chr "___max_na"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(max(a, na.rm = TRUE)), df)
    Output
      List of 3
       $ name : chr "max"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(any(a)), df)
    Output
      List of 3
       $ name : chr "___any_na"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(any(a, na.rm = TRUE)), df)
    Output
      List of 3
       $ name : chr "any"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(all(a)), df)
    Output
      List of 3
       $ name : chr "___all_na"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(all(a, na.rm = TRUE)), df)
    Output
      List of 3
       $ name : chr "all"
       $ args :List of 1
        ..$ :List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(mean(a)), df)
    Output
      List of 3
       $ name : chr "___mean_na"
       $ args :List of 1
        ..$ x:List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(mean(a, b)), df)
    Condition
      Error:
      ! `mean()` needs exactly one argument besides the optional `na.rm`

---

    Code
      rel_translate(expr(mean(a, na.rm = TRUE)), df)
    Output
      List of 3
       $ name : chr "mean"
       $ args :List of 1
        ..$ x:List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(mean(a, na.rm = FALSE)), df)
    Output
      List of 3
       $ name : chr "___mean_na"
       $ args :List of 1
        ..$ x:List of 3
        .. ..$ name : chr "a"
        .. ..$ rel  : NULL
        .. ..$ alias: NULL
        .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
       $ alias: NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(mean(a, na.rm = b)), df)
    Condition
      Error:
      ! object 'b' not found

---

    Code
      rel_translate(expr(mean(a, na.rm = 1)), df)
    Condition
      Error:
      ! Invalid value for `na.rm` in call to `mean()`

---

    Code
      rel_translate(expr(mean(a)), df, need_window = TRUE)
    Condition
      Error:
      ! `mean(na.rm = FALSE)` not supported in window functions
      i Use `mean(na.rm = TRUE)` after checking for missing values

# aggregation primitives with na.rm and window functions

    Code
      rel_translate(expr(sum(a, na.rm = TRUE)), df, need_window = TRUE)
    Output
      List of 6
       $ expr        :List of 3
        ..$ name : chr "sum"
        ..$ args :List of 1
        .. ..$ :List of 3
        .. .. ..$ name : chr "a"
        .. .. ..$ rel  : NULL
        .. .. ..$ alias: NULL
        .. .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ alias: NULL
        ..- attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       $ partitions  : list()
       $ order_bys   : list()
       $ offset_expr : NULL
       $ default_expr: NULL
       $ alias       : NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_window" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(min(a, na.rm = TRUE)), df, need_window = TRUE)
    Output
      List of 6
       $ expr        :List of 3
        ..$ name : chr "min"
        ..$ args :List of 1
        .. ..$ :List of 3
        .. .. ..$ name : chr "a"
        .. .. ..$ rel  : NULL
        .. .. ..$ alias: NULL
        .. .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ alias: NULL
        ..- attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       $ partitions  : list()
       $ order_bys   : list()
       $ offset_expr : NULL
       $ default_expr: NULL
       $ alias       : NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_window" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(max(a, na.rm = TRUE)), df, need_window = TRUE)
    Output
      List of 6
       $ expr        :List of 3
        ..$ name : chr "max"
        ..$ args :List of 1
        .. ..$ :List of 3
        .. .. ..$ name : chr "a"
        .. .. ..$ rel  : NULL
        .. .. ..$ alias: NULL
        .. .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ alias: NULL
        ..- attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       $ partitions  : list()
       $ order_bys   : list()
       $ offset_expr : NULL
       $ default_expr: NULL
       $ alias       : NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_window" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(mean(a, na.rm = TRUE)), df, need_window = TRUE)
    Output
      List of 6
       $ expr        :List of 3
        ..$ name : chr "mean"
        ..$ args :List of 1
        .. ..$ x:List of 3
        .. .. ..$ name : chr "a"
        .. .. ..$ rel  : NULL
        .. .. ..$ alias: NULL
        .. .. ..- attr(*, "class")= chr [1:2] "relational_relexpr_reference" "relational_relexpr"
        ..$ alias: NULL
        ..- attr(*, "class")= chr [1:2] "relational_relexpr_function" "relational_relexpr"
       $ partitions  : list()
       $ order_bys   : list()
       $ offset_expr : NULL
       $ default_expr: NULL
       $ alias       : NULL
       - attr(*, "class")= chr [1:2] "relational_relexpr_window" "relational_relexpr"
       - attr(*, "used")= chr "a"

---

    Code
      rel_translate(expr(sum(a, na.rm = FALSE)), df, need_window = TRUE)
    Condition
      Error:
      ! `sum(na.rm = FALSE)` not supported in window functions
      i Use `sum(na.rm = TRUE)` after checking for missing values

---

    Code
      rel_translate(expr(mean(a, na.rm = FALSE)), df, need_window = TRUE)
    Condition
      Error:
      ! `mean(na.rm = FALSE)` not supported in window functions
      i Use `mean(na.rm = TRUE)` after checking for missing values

# rel_find_call() error paths

    Code
      rel_find_call(quote(pkg::""), env)
    Condition
      Error:
      ! No translation for function `pkg::()`.

---

    Code
      rel_find_call(call("::", "pkg", 123), env, env)
    Condition
      Error:
      ! No translation for function `pkg::123()`.

---

    Code
      rel_find_call(quote(c(1, 2)), env)
    Condition
      Error:
      ! Can't translate function `c(1, 2)`.

---

    Code
      rel_find_call(quote(unknown_function), env)
    Condition
      Error:
      ! No translation for function `unknown_function()`.

---

    Code
      rel_find_call(quote(somepkg::unknown_function), env)
    Condition
      Error:
      ! No translation for function `somepkg::unknown_function()`.

---

    Code
      rel_find_call(quote(mean), new_environment())
    Condition
      Error:
      ! Function `mean()` not found.

---

    Code
      rel_find_call(quote(mean), new_environment(list(mean = stats::sd)))
    Condition
      Error:
      ! Function `mean()` does not map to `base::mean()`.

