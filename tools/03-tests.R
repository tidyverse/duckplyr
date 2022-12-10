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

get_test_code <- function(name, code) {
  formals <- formals(code)

  two_tables <- (length(formals) > 1) && (names(formals)[[2]] == "y")

  test_code_pre <- c(
    paste0('test_that("as_duckplyr_df() commutes for ', name, '()", {'),
    "  # Data"
  )

  if (two_tables) {
    test_code <- c(
      "  test_df_x <- data.frame(a = 1, b = 2)",
      "  test_df_y <- data.frame(a = 1, b = 2)",
      "",
      "  # Run",
      paste0("  pre <- test_df_x %>% as_duckplyr_df() %>% ", name, "(test_df_y)"),
      paste0("  post <- test_df_x %>% ", name, "(test_df_y) %>% as_duckplyr_df()")
    )
  } else {
    test_code <- c(
      "  test_df <- data.frame(a = 1, b = 2)",
      "",
      "  # Run",
      paste0("  pre <- test_df %>% as_duckplyr_df() %>% ", name, "()"),
      paste0("  post <- test_df %>% ", name, "() %>% as_duckplyr_df()")
    )
  }

  test_code_post <- c(
    "",
    "  # Compare",
    "  expect_equal(pre, post)",
    "})",
    ""
  )

  paste(c(test_code_pre, test_code, test_code_post), collapse = "\n")
}

tests <-
  df_methods %>%
  mutate(test_code = map2_chr(name, code, get_test_code))

tests %>%
  mutate(path = fs::path("tests", "testthat", paste0("test-", name, ".R"))) %>%
  select(text = test_code, path) %>%
  pwalk(brio::write_file)
