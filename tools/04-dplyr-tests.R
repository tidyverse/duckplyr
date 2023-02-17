source("tools/00-funs.R", echo = TRUE)

tests <- compact(list(
  "helper-s3.R" = c(
  ),
  "helper-encoding.R" = c(
  ),
  "test-arrange.R" = c(
  ),
  "test-count-tally.R" = c(
  ),
  "test-distinct.R" = c(
  ),
  "test-filter.R" = c(
  ),
  "test-join.R" = c(
  ),
  "test-mutate.R" = c(
  ),
  "test-pull.R" = c(
  ),
  "test-relocate.R" = c(
  ),
  "test-rename.R" = c(
  ),
  "test-select.R" = c(
  ),
  "test-summarise.R" = c(
  ),
  "test-transmute.R" = c(
  ),
  NULL
))

copy_dplyr_test <- function(target, source) {
  rx <- paste0(
    "((?<![a-z_])(?:",
    paste(df_methods$name, collapse = "|"),
    ")[(])"
  )

  text <- brio::read_file(source)
  text <- gsub(rx, "duckplyr_\\1", text, perl = TRUE)
  brio::write_file(text, target)
}

walk2(
  fs::path("tests/testthat", names(tests)),
  fs::path("../dplyr/tests/testthat", names(tests)),
  copy_dplyr_test
)
