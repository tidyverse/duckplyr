# requires at least one condition

    Code
      case_match(1)
    Condition
      Warning:
      `case_match()` was deprecated in dplyr 1.2.0.
      i Please use `recode_values()` instead.
      Error in `case_match()`:
      ! `...` can't be empty.

---

    Code
      case_match(1, NULL)
    Condition
      Warning:
      `case_match()` was deprecated in dplyr 1.2.0.
      i Please use `recode_values()` instead.
      Error in `case_match()`:
      ! `...` can't be empty.

# `.default` is part of common type computation

    Code
      case_match(1, 1 ~ 1L, .default = "x")
    Condition
      Warning:
      `case_match()` was deprecated in dplyr 1.2.0.
      i Please use `recode_values()` instead.
      Error in `case_match()`:
      ! Can't combine <integer> and `.default` <character>.

# `NULL` formula element throws meaningful error

    Code
      case_match(1, 1 ~ NULL)
    Condition
      Warning:
      `case_match()` was deprecated in dplyr 1.2.0.
      i Please use `recode_values()` instead.
      Error in `case_match()`:
      ! `..1 (right)` must be a vector, not `NULL`.
      i Read our FAQ about scalar types (`?vctrs::faq_error_scalar_type`) to learn more.

---

    Code
      case_match(1, NULL ~ 1)
    Condition
      Warning:
      `case_match()` was deprecated in dplyr 1.2.0.
      i Please use `recode_values()` instead.
      Error in `case_match()`:
      ! `..1 (left)` must be a vector, not `NULL`.
      i Read our FAQ about scalar types (`?vctrs::faq_error_scalar_type`) to learn more.

# throws chained errors when formula evaluation fails

    Code
      case_match(1, 1 ~ 2, 3 ~ stop("oh no!"))
    Condition
      Warning:
      `case_match()` was deprecated in dplyr 1.2.0.
      i Please use `recode_values()` instead.
      Error in `case_match()`:
      ! Failed to evaluate the right-hand side of formula 2.
      Caused by error:
      ! oh no!

---

    Code
      case_match(1, 1 ~ 2, stop("oh no!") ~ 4)
    Condition
      Warning:
      `case_match()` was deprecated in dplyr 1.2.0.
      i Please use `recode_values()` instead.
      Error in `case_match()`:
      ! Failed to evaluate the left-hand side of formula 2.
      Caused by error:
      ! oh no!

