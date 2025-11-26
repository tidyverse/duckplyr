withr::local_envvar(DUCKPLYR_TELEMETRY_TEST = TRUE)

test_that("telemetry and anti_join()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      anti_join(tibble(a = 1:3, b = 4:6))
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      anti_join(
        tibble(a = 1:3, b = 4:6),
        by = "a",
        copy = FALSE,
        na_matches = "na"
      )
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      anti_join(
        tibble(a = 1:3, b = 4:6),
        by = c("a" = "b"),
        copy = FALSE,
        na_matches = "na"
      )
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      anti_join(
        tibble(a = 1:3, b = 4:6),
        by = join_by(a == b),
        copy = FALSE,
        na_matches = "never"
      )
  })
})

test_that("telemetry and arrange()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      arrange(a)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      arrange(a, .by_group = TRUE)
  })
})

test_that("telemetry and count()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      count(a)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      count(a, wt = b, sort = TRUE, name = "nn", .drop = FALSE)
  })
})

test_that("telemetry and distinct()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      distinct(a)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      distinct(a, b, .keep_all = TRUE)
  })
})

test_that("telemetry and filter()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      filter(a > 1)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      filter(a > 1, .by = b)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      filter(a > 1, .preserve = TRUE)
  })
})

test_that("telemetry and full_join()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      full_join(tibble(a = 1:3, b = 4:6))
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      full_join(
        tibble(a = 1:3, b = 4:6),
        by = "a",
        copy = TRUE,
        suffix = c("x", "y"),
        keep = TRUE,
        na_matches = "na",
        multiple = "all",
        relationship = "one-to-one"
      )
  })
})

test_that("telemetry and inner_join()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      inner_join(tibble(a = 1:3, b = 4:6))
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      inner_join(
        tibble(a = 1:3, b = 4:6),
        by = "a",
        copy = TRUE,
        suffix = c("x", "y"),
        keep = TRUE,
        na_matches = "na",
        multiple = "all",
        unmatched = "error",
        relationship = "one-to-one"
      )
  })
})

test_that("telemetry and intersect()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      intersect(tibble(a = 1:3, b = 4:6))
  })
})

test_that("telemetry and left_join()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      left_join(tibble(a = 1:3, b = 4:6))
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      left_join(
        tibble(a = 1:3, b = 4:6),
        by = "a",
        copy = TRUE,
        suffix = c("x", "y"),
        keep = TRUE,
        na_matches = "na",
        multiple = "all",
        unmatched = "error",
        relationship = "one-to-one"
      )
  })
})

test_that("telemetry and mutate()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      mutate(c = a + b)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      mutate(c = a + b, .by = a, .keep = "unused", )
  })
})

test_that("telemetry and relocate()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      relocate(b)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      relocate(b, .before = a)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      relocate(a, .after = b)
  })
})

test_that("telemetry and rename()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      rename(c = a)
  })
})

test_that("telemetry and right_join()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      right_join(tibble(a = 1:3, b = 4:6))
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      right_join(
        tibble(a = 1:3, b = 4:6),
        by = "a",
        copy = TRUE,
        suffix = c("x", "y"),
        keep = TRUE,
        na_matches = "na",
        multiple = "all",
        unmatched = "error",
        relationship = "one-to-one"
      )
  })
})

test_that("telemetry and select()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      select(c = b)
  })
})

test_that("telemetry and semi_join()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      semi_join(tibble(a = 1:3, b = 4:6))
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      semi_join(
        tibble(a = 1:3, b = 4:6),
        by = "a",
        copy = TRUE,
        na_matches = "na"
      )
  })
})

test_that("telemetry and setdiff()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      setdiff(tibble(a = 1:3, b = 4:6))
  })
})

test_that("telemetry and summarise()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      summarise(c = sum(b))
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      summarise(c = sum(b), .by = a)
  })

  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      summarise(c = sum(b), .groups = "rowwise")
  })
})

test_that("telemetry and symdiff()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      symdiff(tibble(a = 1:3, b = 4:6))
  })
})

test_that("telemetry and transmute()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      transmute(c = a + b)
  })
})

test_that("telemetry and union_all()", {
  expect_snapshot(error = TRUE, {
    duckdb_tibble(a = 1:3, b = 4:6) %>%
      union_all(tibble(a = 1:3, b = 4:6))
  })
})

test_that("scrubbing function declarations", {
  expect_snapshot({
    expr <- expr(
      across(x:y, function(arg) mean(arg, na.rm = TRUE))
    )

    expr_scrub(expr)
  })
})
