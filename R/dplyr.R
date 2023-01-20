check_filter <- dplyr:::check_filter
check_keep <- dplyr:::check_keep
check_name <- dplyr:::check_name
check_na_matches <- dplyr:::check_na_matches
check_string <- dplyr:::check_string
check_transmute_args <- dplyr:::check_transmute_args
count_regroups <- dplyr:::count_regroups
dplyr_error_call <- dplyr:::dplyr_error_call
dplyr_local_error_call <- dplyr:::dplyr_local_error_call
dplyr_quosures <- dplyr:::dplyr_quosures
eval_relocate <- dplyr:::eval_relocate
eval_select_by <- dplyr:::eval_select_by
group_by_drop_default <- dplyr:::group_by_drop_default
# Need to reimplement mutate_keep() to avoid dplyr_col_select()
# mutate_keep <- dplyr:::mutate_keep
mutate_relocate <- dplyr:::mutate_relocate
some <- dplyr:::some
tally_n <- dplyr:::tally_n


mutate_keep <- function(out, keep, used, names_new, names_groups) {
  if (keep == "all") {
    return(out)
  }

  names <- names(out)

  names_keep <- switch(
    keep,
    used = names(used)[used],
    unused = names(used)[!used],
    none = character(),
    abort("Unknown `keep`.", .internal = TRUE)
  )

  names_out <- intersect(names, c(names_new, names_groups, names_keep))

  select(out, !!!names_out)
}
