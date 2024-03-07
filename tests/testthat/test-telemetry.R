withr::local_envvar(DUCKPLYR_TELEMETRY_TEST = TRUE)

test_that("telemetry and arrange()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      arrange(a, .by_group = TRUE)
  })
})

test_that("telemetry and count()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      count(a, wt = b, sort = TRUE, name = "nn", .drop = FALSE)
  })
})

test_that("telemetry and distinct()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      distinct(a, b, .keep_all = TRUE)
  })
})

test_that("telemetry and filter()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      filter(a > 1, .by = b)
  })

  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      filter(a > 1, .preserve = TRUE)
  })
})

test_that("telemetry and intersect()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      intersect(tibble(a = 1:3, b = 4:6))
  })
})

test_that("telemetry and mutate()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      mutate(c = a + b, .by = a, .keep = "unused", )
  })
})

test_that("telemetry and relocate()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      relocate(b)
  })
})

test_that("telemetry and rename()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      rename(c = a)
  })
})

test_that("telemetry and select()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      select(c = b)
  })
})

test_that("telemetry and setdiff()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      setdiff(tibble(a = 1:3, b = 4:6))
  })
})

test_that("telemetry and summarise()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      summarise(c = sum(b), .by = a)
  })

  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      summarise(c = sum(b), .groups = "rowwise")
  })
})

test_that("telemetry and symdiff()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      symdiff(tibble(a = 1:3, b = 4:6))
  })
})

test_that("telemetry and transmute()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      transmute(c = a + b)
  })
})

test_that("telemetry and union_all()", {
  expect_snapshot(error = TRUE, {
    tibble(a = 1:3, b = 4:6) %>%
      as_duckplyr_df() %>%
      union_all(tibble(a = 1:3, b = 4:6))
  })
})
