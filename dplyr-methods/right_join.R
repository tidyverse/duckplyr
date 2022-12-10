right_join.data.frame <- function(x,
         y,
         by = NULL,
         copy = FALSE,
         suffix = c(".x", ".y"),
         ...,
         keep = NULL,
         na_matches = c("na", "never"),
         multiple = NULL,
         unmatched = "drop") {
  y <- auto_copy(x, y, copy = copy)
  join_mutate(
    x = x,
    y = y,
    by = by,
    type = "right",
    suffix = suffix,
    na_matches = na_matches,
    keep = keep,
    multiple = multiple,
    unmatched = unmatched,
    user_env = caller_env()
  )
}
