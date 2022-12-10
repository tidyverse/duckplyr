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
  # lazyeval methods, won't implement
  filter(!grepl("_$", name)) %>%
  # special dplyr methods, won't implement
  filter(!(name %in% c("dplyr_col_modify", "dplyr_row_slice"))) %>%
  mutate(code = unname(mget(fun, dplyr)))

func_decl <- function(name, code) {
  code <- capture.output(print(constructive::construct(code, check = FALSE)))
  code <- paste0(code, "\n", collapse = "")
  code <- paste0(name, " <- ", code)
  code
}

df_methods_def <-
  df_methods %>%
  rowwise() %>%
  mutate(decl_chr = func_decl(fun, code)) %>%
  ungroup()

fs::dir_create("dplyr-methods")
usethis::use_build_ignore("dplyr-methods")

df_methods_def %>%
  mutate(path = fs::path("dplyr-methods", paste0(name, ".R"))) %>%
  select(text = decl_chr, path) %>%
  pwalk(brio::write_file)
