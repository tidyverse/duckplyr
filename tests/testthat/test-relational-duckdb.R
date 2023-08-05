test_that("duckdb_rel_from_df()", {
  df <- vctrs::data_frame(
    LOGICAL = TRUE,
    INTEGER = 2L,
    NUMERIC = 3,
    STRING = "four",
    FACTOR = factor("five"),
    DATE = as.Date("2023-08-05"),
    DATE_INTEGER = structure(19574L, class = "Date"),
    TIMESTAMP = structure(1691210978.25436, class = c("POSIXct", "POSIXt"), tzone = "UTC"),
    TIME_SECONDS = structure(6, class = "difftime", units = "secs"),
    # TIME_MINUTES etc.: Loss ok
    TIME_SECONDS_INTEGER = structure(11L, class = "difftime", units = "secs"),
    # TIME_MINUTES_INTEGER etc.: Loss ok

    # INTEGER64 = structure(1, class = "integer64"),
    # LIST_OF_NULLS = list(NULL),
    # BLOB = list(raw(16)),

    `NA` = NA,
  )

  expect_silent(duckdb_rel_from_df(df))

  # If this is no longer an eror, we need to make sure that subsetting
  # forwards to the vector class
  expect_snapshot(error = TRUE, {
    data.frame(a = vctrs::new_vctr(1:3)) %>%
      duckdb_rel_from_df()
  })
})

test_that("duckdb_rel_from_df() and changing column names", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  x <-
    data.frame(a = 1) %>%
    duckplyr_select(a)

  names(x) <- "b"
  expect_equal(x %>% duckplyr_filter(b == 1), data.frame(b = 1))
})

test_that("rel_aggregate()", {
  expr_species <- relexpr_reference("species")
  expr_aggregate <- relexpr_function(alias = "mean_bill_length_mm", "avg", list(
    relexpr_reference("bill_length_mm")
  ))

  grouped <-
    palmerpenguins::penguins %>%
    as_duckplyr_df() %>%
    duckdb_rel_from_df() %>%
    rel_aggregate(list(expr_species), list(expr_aggregate))

  ungrouped <-
    palmerpenguins::penguins %>%
    as_duckplyr_df() %>%
    duckdb_rel_from_df() %>%
    rel_aggregate(list(), list(expr_aggregate))

  expect_snapshot({
    grouped %>%
      rel_to_df() %>%
      arrange(species)
    ungrouped %>%
      rel_to_df()
  })
})
