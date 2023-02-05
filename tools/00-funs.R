# pak::pak("cynkra/constructive")
library(tidyverse)
library(rlang)

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
  filter(!(name %in% c(
    "dplyr_col_modify",
    "dplyr_row_slice",
    "group_by",
    "rowwise",
    "group_data", "group_indices", "group_keys", "group_map", "group_modify", "group_nest", "group_size", "group_split", "group_trim", "groups", "n_groups",
    "same_src", # data frames can be copied into duck-frames with zero cost
    NULL
  ))) %>%
  # methods we don't need to implement but can test
  mutate(skip_impl = name %in% c(
    "collapse", "tally",
    "slice_min", "slice_max", "slice_head", "slice_tail", "slice_sample"
  )) %>%
  mutate(is_tbl_return = !(name %in% c(
    # Special case: forward to `NextMethod()`, don't change output
    "dplyr_reconstruct", "auto_copy", "pull", "setequal", "tbl_vars",
    "group_vars",
    NULL
  ))) %>%
  mutate(code = unname(mget(fun, dplyr)))
