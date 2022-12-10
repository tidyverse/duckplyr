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
  filter(!grepl("^dplyr_", name))

get_test_code <- function(name) {
  paste(
    paste0('test_that("as_duckplyr_df() commutes for ', name, '()", {'),
    "  # Data",
    "  test_df <- data.frame(a = 1, b = 2)",
    "",
    "  # Run",
    paste0("  pre <- test_df %>% as_duckplyr_df() %>% ", name, "()"),
    paste0("  post <- test_df %>% ", name, "() %>% as_duckplyr_df()"),
    "",
    "  # Compare",
    "  expect_equal(pre, post)",
    "})",
    "",
    sep = "\n"
  )
}

tests <-
  df_methods %>%
  mutate(test_code = map_chr(name, get_test_code))

tests %>%
  mutate(path = fs::path("tests", "testthat", paste0("test-", name, ".R"))) %>%
  select(text = test_code, path) %>%
  pwalk(brio::write_file)
