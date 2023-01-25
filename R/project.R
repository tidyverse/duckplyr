exprs_from_loc <- function(.data, loc) {
  stopifnot(is.integer(loc))
  map2(names(.data)[loc], names(loc), ~ relexpr_reference(.x, alias = .y))
}

exprs_project <- function(rel, exprs, .data) {
  out_rel <- rel_project(rel, exprs)
  out <- rel_to_df(out_rel)
  dplyr_reconstruct(out, .data)
}
