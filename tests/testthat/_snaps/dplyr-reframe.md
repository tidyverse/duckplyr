# `duckplyr_reframe()` throws intelligent recycling errors

    Code
      duckplyr_reframe(df, x = 1:2, y = 3:5)
    Condition
      Error in `reframe()`:
      ! Can't recycle `y = 3:5`.
      Caused by error:
      ! `y` must be size 2 or 1, not 3.
      i An earlier column had size 2.

---

    Code
      duckplyr_reframe(df, x = 1:2, y = 3:5, .by = g)
    Condition
      Error in `reframe()`:
      ! Can't recycle `y = 3:5`.
      i In group 1: `g = 1`.
      Caused by error:
      ! `y` must be size 2 or 1, not 3.
      i An earlier column had size 2.

# `duckplyr_reframe()` doesn't message about regrouping when multiple group columns are supplied

    Code
      out <- duckplyr_reframe(df, x = mean(x), .by = c(a, b))

# `duckplyr_reframe()` doesn't message about regrouping when >1 rows are returned per group

    Code
      out <- duckplyr_reframe(df, x = vec_rep_each(x, x), .by = g)

