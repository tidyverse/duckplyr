source("tools/00-funs.R", echo = TRUE)

tests <- c(
  "helper-s3.R",
  "helper-encoding.R",
  "test-arrange.R",
  "test-count-tally.R",
  "test-distinct.R",
  "test-filter.R",
  "test-mutate.R",
  "test-pull.R",
  "test-relocate.R",
  "test-rename.R",
  "test-select.R",
  "test-summarise.R",
  "test-transmute.R",
  NULL
)

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
  fs::path("tests/testthat", tests),
  fs::path("../dplyr/tests/testthat", tests),
  copy_dplyr_test
)
