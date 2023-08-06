exprs_from_loc <- function(.data, loc) {
  nexprs_from_loc(names(.data), loc)
}

nexprs_from_loc <- function(names, loc) {
  stopifnot(is.integer(loc))
  map2(names[loc], names(loc), ~ relexpr_reference(.x, alias = .y))
}

nexprs <- function(names) {
  map(names, ~ relexpr_reference(.x, alias = .x))
}

exprs_project <- function(rel, exprs, .data) {
  out_rel <- rel_project(rel, exprs)
  out <- rel_to_df(out_rel)
  dplyr_reconstruct(out, .data)
}
