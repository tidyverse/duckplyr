duckplyr_mutate_keep <- function(out, keep, used, names_new, names_groups) {
  if (keep == "all") {
    return(out)
  }

  names <- names(out)

  if (keep == "transmute") {
    names_groups <- setdiff(names_groups, names_new)
    names_out <- c(names_groups, names_new)
  } else {
    names_keep <- switch(
      keep,
      used = names(used)[used],
      unused = names(used)[!used],
      none = character(),
      abort("Unknown `keep`.", .internal = TRUE)
    )
    names_out <- intersect(names, c(names_new, names_groups, names_keep))
  }

  select(out, !!!names_out)
}
