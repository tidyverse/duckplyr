# https://github.com/tidyverse/dplyr/pull/7029

join_ptype_common <- function(x, y, vars, error_call = caller_env()) {
  # Explicit `x/y_arg = ""` to avoid auto naming in `cnd$x_arg`
  ptype <- try_fetch(
    vec_ptype2(x, y, x_arg = "", y_arg = "", call = error_call),
    vctrs_error_incompatible_type = function(cnd) {
      rethrow_error_join_incompatible_type(cnd, vars, error_call)
    }
  )
  # Finalize unspecified columns (#6804)
  ptype <- vec_ptype_finalise(ptype)

  ptype
}
