# `lag()` gives informative error for <ts> objects

    Code
      lag(ts(1:10))
    Condition
      Error in `lag()`:
      ! `x` must be a vector, not a <ts>, do you want `stats::lag()`?

# `lead()` / `lag()` validate `n`

    Code
      lead(1:5, n = 1:2)
    Condition
      Error in `lead()`:
      ! `n` must be a whole number, not an integer vector.
    Code
      lead(1:5, -1)
    Condition
      Error in `lead()`:
      ! `n` must be positive.

---

    Code
      lag(1:5, n = 1:2)
    Condition
      Error in `lag()`:
      ! `n` must be a whole number, not an integer vector.
    Code
      lag(1:5, -1)
    Condition
      Error in `lag()`:
      ! `n` must be positive.

# `lead()` / `lag()` check for empty dots

    Code
      lead(1:5, deault = 1)
    Condition
      Error in `lead()`:
      ! `...` must be empty.
      x Problematic argument:
      * deault = 1

---

    Code
      lag(1:5, deault = 1)
    Condition
      Error in `lag()`:
      ! `...` must be empty.
      x Problematic argument:
      * deault = 1

# `lead()` / `lag()` require that `x` is a vector

    Code
      lead(environment())
    Condition
      Error in `lead()`:
      ! `x` must be a vector, not an environment.

---

    Code
      lag(environment())
    Condition
      Error in `lag()`:
      ! `x` must be a vector, not an environment.

# `default` must be size 1 (#5641)

    Code
      shift(1:5, default = 1:2)
    Condition
      Error in `shift()`:
      ! could not find function "shift"

---

    Code
      shift(1:5, default = integer())
    Condition
      Error in `shift()`:
      ! could not find function "shift"

# `n` is validated

    Code
      shift(1, n = 1:2)
    Condition
      Error in `shift()`:
      ! could not find function "shift"

# `order_by` must be the same size as `x`

    Code
      shift(1:5, order_by = 1:4)
    Condition
      Error in `shift()`:
      ! could not find function "shift"

