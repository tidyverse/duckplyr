source("tools/00-funs.R", echo = TRUE)

brio::read_file("tests/testthat/test-rel_api.R") %>%
  str_replace_all("duckdb(?:::|[$])", "") %>%
  str_replace_all("DBI::", "") %>%
  brio::write_file("../duckdb-r/tests/testthat/test-rel_api.R")
