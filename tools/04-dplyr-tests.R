source("tools/00-funs.R", echo = TRUE)

gert::git_pull(repo = ".sync/dplyr-main")

copy_dplyr_test <- function(target, source, skip) {
  rx <- paste0(
    "((?<![a-z_])(?:",
    paste(df_methods$name, collapse = "|"),
    ")[(])"
  )

  text <- brio::read_lines(source)
  text <- gsub(rx, "duckplyr_\\1", text, perl = TRUE)
  text <- text[grep('skip("TODO duckdb")', text, invert = TRUE, fixed = TRUE)]
  if (!is.null(skip)) {
    skip <- gsub(rx, "duckplyr_\\1", skip, perl = TRUE)
    skip_lines <- unique(unlist(map(paste0('"', skip, '"'), grep, text, fixed = TRUE)))
    text[skip_lines] <- paste0(text[skip_lines], '\n  skip("TODO duckdb")')
  }
  brio::write_lines(text, target)
}

pwalk(
  list(
    fs::path("tests/testthat", names(duckdb_tests)),
    fs::path(".sync/dplyr-main/tests/testthat", names(duckdb_tests)),
    duckdb_tests
  ),
  copy_dplyr_test
)
