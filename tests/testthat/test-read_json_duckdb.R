test_that("Reading from JSON works", {
  df <- tibble(a = 1:2, b = c("x", "y"))

  path_json <- withr::local_tempfile(fileext = ".json")
  writeLines('[{"a": 1, "b": "x"}, {"a": 2, "b": "y"}]', path_json)

  db_exec("INSTALL json")
  db_exec("LOAD json")
  out <- read_json_duckdb(path_json)

  expect_equal(collect(out), df)
})
