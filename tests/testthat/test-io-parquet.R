test_that("Roundtrip to Parquet works", {
  df <- tibble(a = 1:3, b = letters[4:6])

  path_parquet <- withr::local_tempfile(fileext = ".parquet")

  df_to_parquet(df, path_parquet)
  out <- df_from_parquet(path_parquet)

  expect_equal(out, df)
})

test_that("Writing to Parquet works without materialization", {
  withr::local_options(duckdb.materialize_message = TRUE)

  df <- tibble(a = 1:3, b = letters[4:6])
  path_parquet <- withr::local_tempfile(fileext = ".parquet")

  df %>%
    as_duckplyr_df() %>%
    select(b, a) %>%
    df_to_parquet(path_parquet) %>%
    expect_silent()

  out <- df_from_parquet(path_parquet)
  expect_output(nrow(out))

  expect_equal(out, df[2:1])
})
