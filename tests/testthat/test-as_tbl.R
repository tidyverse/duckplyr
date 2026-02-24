test_that("as_tbl()", {
  skip_if_not_installed("dbplyr")

  df <- duckdb_tibble(a = 1L)

  tbl <- as_tbl(df)
  expect_s3_class(tbl, "tbl_dbi")
  expect_equal(collect(tbl), tibble(a = 1L))

  sql <- dbplyr::sql_render(tbl)

  out <-
    tbl %>%
    mutate(b = sql("a + 1")) %>%
    as_duckdb_tibble()

  expect_s3_class(out, "duckplyr_df")
  expect_equal(head(out), duckdb_tibble(a = 1L, b = 2L))

  # Test destruction of underlying view
  expect_equal(
    DBI::dbGetQuery(get_default_duckdb_connection(), sql),
    data.frame(a = 1L)
  )

  rm(tbl)
  gc()

  expect_error(DBI::dbGetQuery(get_default_duckdb_connection(), sql))
  # This is expected but perhaps undesirable.
  # We could carry over the duckplyr_scope_guard to the relational object.
  expect_error(collect(out))
})
