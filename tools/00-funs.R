# pak::pak("cynkra/constructive")
library(tidyverse)

dplyr <- asNamespace("dplyr")

s3_methods <- as_tibble(
  matrix(as.character(dplyr$.__NAMESPACE__.$S3methods), ncol = 4),
  .name_repair = ~ c("name", "class", "fun", "what")
)

df_methods <-
  s3_methods %>%
  filter(class == "data.frame") %>%
  # deprecated and lazyeval methods, won't implement
  filter(!grepl("_$|^as[.]tbl$", name)) %>%
  # special dplyr methods, won't implement
  filter(!(name %in% c("dplyr_col_modify", "dplyr_row_slice"))) %>%
  # methods we don't need to implement but can test
  mutate(skip_impl = name %in% c(
    "collapse", "collect", "compute", "count", "tally",
    "slice_min", "slice_max", "slice_head", "slice_tail", "slice_sample"
  )) %>%
  mutate(is_tbl_return = !(name %in% c(
    # Special case: forward to `NextMethod()`, don't change output
    "dplyr_reconstruct", "auto_copy", "pull", "same_src", "setequal",
    # FIXME: Do we even need those?
    "group_indices", "group_size", "group_vars", "groups", "n_groups"
  ))) %>%
  mutate(code = unname(mget(fun, dplyr)))
