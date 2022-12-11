source("tools/00-funs.R", echo = TRUE)

tests <- c(
  "helper-s3.R",
  "test-filter.R",
  "test-select.R",
  NULL
)

our_tests <- sub("-", "-dplyr-", tests)

copy_dplyr_test <- function(target, source) {
  rx <- paste0(
    "((?<![a-z_])(?:",
    paste(df_methods$name[!df_methods$skip_impl], collapse = "|"),
    ")[(])"
  )

  text <- brio::read_file(source)
  text <- gsub(rx, "duckplyr_\\1", text, perl = TRUE)
  brio::write_file(text, target)
}

walk2(
  fs::path("tests/testthat", our_tests),
  fs::path("../dplyr/tests/testthat", tests),
  copy_dplyr_test
)
