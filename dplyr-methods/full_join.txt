full_join.data.frame <- function(x,
         y,
         by = NULL,
         copy = FALSE,
         suffix = c(".x", ".y"),
         ...,
         keep = NULL,
         na_matches = c("na", "never"),
         multiple = NULL) {
  y <- auto_copy(x, y, copy = copy)
  join_mutate(
    x = x,
    y = y,
    by = by,
    type = "full",
    suffix = suffix,
    na_matches = na_matches,
    keep = keep,
    multiple = multiple,
    # All keys from both inputs are retained. Erroring never makes sense.
    unmatched = "drop",
    user_env = caller_env()
  )
}
