source("tools/00-funs.R", echo = TRUE)

func_decl <- function(name, code) {
  code <- utils::capture.output(print(constructive::construct(code, check = FALSE, constructive::opts_function(environment = FALSE))))
  code <- paste0(code, "\n", collapse = "")
  code <- paste0(name, " <- ", code)
  code
}

df_methods_def <-
  df_methods %>%
  rowwise() %>%
  mutate(decl_chr = func_decl(fun, code)) %>%
  ungroup()

fs::dir_delete("dplyr-methods")
fs::dir_create("dplyr-methods")
usethis::use_build_ignore("dplyr-methods")

df_methods_def %>%
  filter(!skip_impl) %>%
  mutate(path = fs::path("dplyr-methods", paste0(name, ".txt"))) %>%
  select(text = decl_chr, path) %>%
  pwalk(brio::write_file)
