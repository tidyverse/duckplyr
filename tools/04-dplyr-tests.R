source("tools/00-funs.R", echo = TRUE)

gert::git_pull(repo = ".sync/dplyr-main")

copy_dplyr_test <- function(test_name) {
  source <- fs::path(".sync/dplyr-main/tests/testthat", test_name)
  target <- fs::path("tests/testthat", test_name)

  rx <- paste0(
    "((?<![a-z_])(?:",
    paste(df_methods$name, collapse = "|"),
    ")[(])"
  )

  text <- brio::read_lines(source)
  text <- gsub(rx, "duckplyr_\\1", text, perl = TRUE)
  text <- text[grep('skip("TODO duckdb")', text, invert = TRUE, fixed = TRUE)]

  skip_todo <- duckdb_tests[[test_name]]
  if (!is.null(skip_todo)) {
    skip_todo <- gsub(rx, "duckplyr_\\1", skip_todo, perl = TRUE)
    skip_todo_lines <- unique(unlist(map(paste0('"', skip_todo, '"'), grep, text, fixed = TRUE)))
    text[skip_todo_lines] <- paste0(text[skip_todo_lines], '\n  skip("TODO duckdb")')
  }
  brio::write_lines(text, target)
}

walk(
  names(duckdb_tests),
  copy_dplyr_test
)
