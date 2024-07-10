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

