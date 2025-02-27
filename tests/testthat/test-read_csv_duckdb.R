test_that("Roundtrip to CSV works", {
  df <- tibble(a = 1:3, b = letters[4:6])

  path_csv <- withr::local_tempfile(fileext = ".csv")

  write.csv(df, path_csv, row.names = FALSE)
  out <- read_csv_duckdb(path_csv)

  expect_equal(collect(out), df)
})
