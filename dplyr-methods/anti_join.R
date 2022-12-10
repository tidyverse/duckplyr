anti_join.data.frame <- function(x, y, by = NULL, copy = FALSE, ..., na_matches = c("na", "never")) {
  y <- auto_copy(x, y, copy = copy)
  join_filter(x, y, by = by, type = "anti", na_matches = na_matches, user_env = caller_env())
}
