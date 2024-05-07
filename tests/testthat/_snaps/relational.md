# rel_try() with reason

    Code
      rel_try(`Not affected` = FALSE, Affected = TRUE, { })
    Message
      Requested fallback for relational:
      i Affected
    Output
      NULL

# call with named argument

    Code
      rel_translate(quo(c(1, b = 2)))
    Condition
      Error in `do_translate()`:
      ! Can't translate named argument `c(b = )`.

# a %in% b

    Code
      rel_translate(quo(a %in% b), data.frame(a = 1:3, b = 2:4))
    Condition
      Error:
      ! Can't access data in this context

