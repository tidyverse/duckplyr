# Avoiding functions used only for internal tests
compute_groups <- function(...) {
  skip("dplyr:::compute_groups() is only needed to test dplyr internals")
}
err_locs <- function(...) {
  skip("dplyr:::err_locs() is only needed to test dplyr internals")
}
expand_pick <- function(...) {
  skip("dplyr:::expand_pick() is only needed to test dplyr internals")
}
group_labels_details <- function(...) {
  skip("dplyr:::group_labels_details() is only needed to test dplyr internals")
}
is_sel_vars <- function(...) {
  skip("dplyr:::is_sel_vars() is only needed to test dplyr internals")
}
reset_dplyr_warnings <- function(...) {
  skip("dplyr:::reset_dplyr_warnings() is only needed to test dplyr internals")
}
shift <- function(...) {
  skip("dplyr:::shift() is only needed to test dplyr internals")
}
