# must supply at least one selector to `pick()`

    Code
      duckplyr_mutate(df, y = pick())
    Condition
      Error in `mutate()`:
      i In argument: `y = pick()`.
      Caused by error in `pick()`:
      ! Must supply at least one input to `pick()`.

---

    Code
      duckplyr_mutate(df, y = pick_wrapper())
    Condition
      Error in `mutate()`:
      i In argument: `y = pick_wrapper()`.
      Caused by error in `pick()`:
      ! Must supply at least one input to `pick()`.

# errors correctly outside mutate context

    Code
      pick()
    Condition
      Error in `pick()`:
      ! Must only be used inside data-masking verbs like `mutate()`, `filter()`, and `group_by()`.

---

    Code
      pick(a, b)
    Condition
      Error in `pick()`:
      ! Must only be used inside data-masking verbs like `mutate()`, `filter()`, and `group_by()`.

# when expansion occurs, error labels use the pre-expansion quosure

    Code
      duckplyr_mutate(df, if (cur_group_id() == 1L) pick(x) else "x", .by = g)
    Condition
      Error in `mutate()`:
      i In argument: `if (cur_group_id() == 1L) pick(x) else "x"`.
      Caused by error:
      ! `if (cur_group_id() == 1L) pick(x) else "x"` must return compatible vectors across groups.
      i Result of type <tbl_df<x:double>> for group 1: `g = 1`.
      i Result of type <character> for group 2: `g = 2`.

# doesn't allow renaming

    Code
      duckplyr_mutate(data.frame(x = 1), pick(y = x))
    Condition
      Error in `mutate()`:
      i In argument: `pick(y = x)`.
      Caused by error in `pick()`:
      ! Can't rename variables in this context.

---

    Code
      duckplyr_mutate(data.frame(x = 1), pick_wrapper(y = x))
    Condition
      Error in `mutate()`:
      i In argument: `pick_wrapper(y = x)`.
      Caused by error in `pick()`:
      ! Can't rename variables in this context.

# `pick()` errors in `duckplyr_arrange()` are useful

    Code
      duckplyr_arrange(df, pick(y))
    Condition
      Error in `arrange()`:
      i In argument: `..1 = pick(y)`.
      Caused by error in `pick()`:
      ! Can't select columns that don't exist.
      x Column `y` doesn't exist.

---

    Code
      duckplyr_arrange(df, foo(pick(x)))
    Condition
      Error in `arrange()`:
      i In argument: `..1 = foo(pick(x))`.
      Caused by error in `foo()`:
      ! could not find function "foo"

# `duckplyr_filter()` / `duckplyr_filter_out()` with `pick()` that uses invalid tidy-selection errors

    Code
      duckplyr_filter(df, pick(x, a))
    Condition
      Error in `filter()`:
      i In argument: `pick(x, a)`.
      Caused by error in `pick()`:
      ! Can't select columns that don't exist.
      x Column `a` doesn't exist.

---

    Code
      duckplyr_filter(df, pick_wrapper(x, a))
    Condition
      Error in `filter()`:
      i In argument: `pick_wrapper(x, a)`.
      Caused by error in `pick()`:
      ! Can't select columns that don't exist.
      x Column `a` doesn't exist.

---

    Code
      duckplyr_filter_out(df, pick(x, a))
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(.by)
      
        # Now:
        data %>% select(all_of(.by))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Error in `filter_out()`:
      i In argument: `pick(x, a)`.
      Caused by error in `pick()`:
      ! Can't select columns that don't exist.
      x Column `a` doesn't exist.

---

    Code
      duckplyr_filter_out(df, pick_wrapper(x, a))
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(.by)
      
        # Now:
        data %>% select(all_of(.by))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Error in `filter_out()`:
      i In argument: `pick_wrapper(x, a)`.
      Caused by error in `pick()`:
      ! Can't select columns that don't exist.
      x Column `a` doesn't exist.

# `duckplyr_filter()` / `duckplyr_filter_out()` that doesn't use `pick()` result correctly errors

    Code
      duckplyr_filter(df, pick(x, y)$x)
    Condition
      Error in `filter()`:
      i In argument: `pick(x, y)$x`.
      Caused by error:
      ! `..1` must be a logical vector, not a double vector.

---

    Code
      duckplyr_filter(df, pick_wrapper(x, y)$x)
    Condition
      Error in `filter()`:
      i In argument: `pick_wrapper(x, y)$x`.
      Caused by error:
      ! `..1` must be a logical vector, not a double vector.

---

    Code
      duckplyr_filter_out(df, pick(x, y)$x)
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(.by)
      
        # Now:
        data %>% select(all_of(.by))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Error in `filter_out()`:
      i In argument: `pick(x, y)$x`.
      Caused by error:
      ! `..1` must be a logical vector, not a double vector.

---

    Code
      duckplyr_filter_out(df, pick_wrapper(x, y)$x)
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(.by)
      
        # Now:
        data %>% select(all_of(.by))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
      Error in `filter_out()`:
      i In argument: `pick_wrapper(x, y)$x`.
      Caused by error:
      ! `..1` must be a logical vector, not a double vector.

