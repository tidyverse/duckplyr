source("tools/00-funs.R", echo = TRUE)

brio::read_file("tests/testthat/test-rel_api.R") %>%
  str_replace_all("duckdb(?:::|[$])", "") %>%
  str_replace_all("DBI::", "") %>%
  str_replace_all("\n[^\n]+asNamespace[^\n]+\n", "\n") %>%
  str_replace_all(fixed("# skip_if_not(TEST_RE2)"), "skip_if_not(TEST_RE2)") %>%
  brio::write_file("../duckdb-r/tests/testthat/test-rel_api.R")
