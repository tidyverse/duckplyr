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

func_decl_chr <- function(generic, name, code) {
  code <- paste(capture.output(print(code)), collapse = "\n")
  code <- paste0("#' @importFrom dplyr ", generic, "\n#' @export\n", name, " <- ", code, "\n")
  code <- gsub("[{]", "{\n  #", code)
  code
}

duckplyr_df_methods <-
  df_methods %>%
  mutate(formals = map(code, formals)) %>%
  mutate(new_code = map(formals, rlang::new_function, expr({
    out <- NextMethod()
    out <- duckplyr_df_reconstruct(out)
    return(out)
  }))) %>%
  mutate(new_code_chr = map(new_code, constructive::construct, check = FALSE)) %>%
  mutate(new_fun = paste0(name, ".duckplyr_df")) %>%
  rowwise() %>%
  mutate(decl_chr = func_decl_chr(name, new_fun, new_code_chr)) %>%
  ungroup()

fs::dir_create("R")

duckplyr_df_methods %>%
  mutate(path = fs::path("R", paste0(name, ".R"))) %>%
  select(text = decl_chr, path) %>%
  pwalk(brio::write_file)
