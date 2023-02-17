source("tools/00-funs.R", echo = TRUE)

tests <- compact(list(
  "helper-s3.R" = c(
    NULL
  ),
  "helper-encoding.R" = c(
    NULL
  ),
  "test-arrange.R" = c(
    NULL
  ),
  "test-count-tally.R" = c(
    NULL
  ),
  "test-distinct.R" = c(
    NULL
  ),
  "test-filter.R" = c(
    NULL
  ),
  "test-join.R" = c(
    "mutating joins preserve row and column order of x",
    NULL
  ),
  "test-mutate.R" = c(
    NULL
  ),
  "test-pull.R" = c(
    NULL
  ),
  "test-relocate.R" = c(
    NULL
  ),
  "test-rename.R" = c(
    NULL
  ),
  "test-select.R" = c(
    NULL
  ),
  "test-summarise.R" = c(
    NULL
  ),
  "test-transmute.R" = c(
    NULL
  ),
  NULL
))

copy_dplyr_test <- function(target, source, skip) {
  rx <- paste0(
    "((?<![a-z_])(?:",
    paste(df_methods$name, collapse = "|"),
    ")[(])"
  )

  text <- brio::read_lines(source)
  text <- gsub(rx, "duckplyr_\\1", text, perl = TRUE)
  skip_lines <- unique(unlist(map(skip, grep, text, fixed = TRUE)))
  text[skip_lines] <- paste0(text[skip_lines], '\n  skip("TODO duckdb")')
  brio::write_lines(text, target)
}

pwalk(
  list(
    fs::path("tests/testthat", names(tests)),
    fs::path("../dplyr/tests/testthat", names(tests)),
    tests
  ),
  copy_dplyr_test
)
