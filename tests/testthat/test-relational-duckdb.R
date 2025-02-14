test_that("duckdb_rel_from_df()", {
  df <- vctrs::data_frame(
    LOGICAL = TRUE,
    INTEGER = 2L,
    NUMERIC = 3,
    STRING = "four",
    # FACTOR = factor("five"), # https://github.com/duckdb/duckdb/issues/8561
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

  if (Sys.getenv("DUCKPLYR_CHECK_ROUNDTRIP") == "TRUE") {
    # Ingestion only
    df$DATE_INTEGER <- NULL
    df$TIME_SECONDS_INTEGER <- NULL
  }

  expect_silent(duckdb_rel_from_df(df))

  expect_identical(
    map(df, vec_ptype_safe),
    map(df, vec_ptype)
  )

  # FIXME: Test that vec_ptype_safe() does not materialize (#149),
  # remove test-altrep.R

  skip_if(Sys.getenv("DUCKPLYR_CHECK_ROUNDTRIP") == "TRUE")

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

test_that("duckdb_rel_from_df() error call", {
  expect_snapshot(error = TRUE, {
    as_duckdb_tibble(data.frame(a = factor(letters)))
  })
})

test_that("rel_aggregate()", {
  skip_if_not_installed("palmerpenguins")

  expr_species <- relexpr_reference("species")
  expr_aggregate <- relexpr_function(alias = "mean_bill_length_mm", "avg", list(
    relexpr_reference("bill_length_mm")
  ))

  grouped <-
    palmerpenguins::penguins %>%
    # https://github.com/duckdb/duckdb/issues/8561
    mutate(species = as.character(species)) %>%
    mutate(island = as.character(island)) %>%
    mutate(sex = as.character(sex)) %>%
    as_duckdb_tibble() %>%
    duckdb_rel_from_df() %>%
    rel_aggregate(list(expr_species), list(expr_aggregate))

  ungrouped <-
    palmerpenguins::penguins %>%
    # https://github.com/duckdb/duckdb/issues/8561
    mutate(species = as.character(species)) %>%
    mutate(island = as.character(island)) %>%
    mutate(sex = as.character(sex)) %>%
    as_duckdb_tibble() %>%
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

test_that("duckdb_rel_from_df() uses materialized results", {
  skip_if(identical(Sys.getenv("R_COVR"), "true"))

  withr::local_envvar(DUCKPLYR_FORCE = TRUE)
  n_calls <- 0
  withr::local_options(duckdb.materialize_callback = function(...) {
    n_calls <<- n_calls + 1
  })

  df <-
    data.frame(a = 1) %>%
    duckplyr_filter(a == 1)

  transform <- function(x) {
    x <- gsub("0x[0-9a-f]+", "0xdeadbeef", x)
    x
  }

  expect_equal(n_calls, 0)

  expect_snapshot(transform = transform, {
    duckdb_rel_from_df(df)
  })

  expect_equal(n_calls, 0)

  expect_snapshot(transform = transform, {
    nrow(df)
  })

  expect_equal(n_calls, 1)

  expect_snapshot(transform = transform, {
    duckdb_rel_from_df(df)
  })

  expect_equal(n_calls, 1)
})
