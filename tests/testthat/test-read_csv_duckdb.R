test_that("Roundtrip to CSV works", {
  df <- tibble(a = 1:3, b = letters[4:6])

  path_csv <- withr::local_tempfile(fileext = ".csv")

  write.csv(df, path_csv, row.names = FALSE)
  out <- read_csv_duckdb(path_csv)

  expect_equal(collect(out), df)
})

test_that("Roundtrip to multiple CSV works", {
  df1 <- tibble(a = 1:3, b = letters[4:6])
  path_csv1 <- withr::local_tempfile(fileext = ".csv")
  write.csv(df1, path_csv1, row.names = FALSE)

  df2 <- tibble(a = 4:6, b = letters[7:9])
  path_csv2 <- withr::local_tempfile(fileext = ".csv")
  write.csv(df2, path_csv2, row.names = FALSE)

  out <- read_csv_duckdb(c(path_csv1, path_csv2))

  expect_equal(collect(out), bind_rows(df1, df2))
})
