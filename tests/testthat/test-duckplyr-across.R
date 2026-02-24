test_that("duckplyr_expand_across() successful", {
  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, mean)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, function(x) mean(x))
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(c(x_mean = x, y_mean = y), mean)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(c(x_mean = x, y_mean = y), mean, .names = "{.col}_{.fn}")
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, function(x) mean(x, na.rm = TRUE))
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0, a = 0),
      across(c(a, x), function(x) x + 1)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0, a = 0),
      across(c(a, x), function(x) x * 2 + 1)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0, a = 0),
      across(-a, function(x) x * x)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, base::mean)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, list(mean))
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, list(mean = mean))
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, list(mean = mean, median = median))
    )
  })
})

test_that("duckplyr_expand_across() failing", {
  expect_null(test_duckplyr_expand_across(
    tibble::tibble(x = 0, y = 0),
    across(x:y, mean, .unpack = TRUE)
  ))
  expect_null(test_duckplyr_expand_across(
    tibble::tibble(x = 0, y = 0),
    across(x:y, mean, na.rm = TRUE)
  ))
})

test_that("duckplyr_expand_across() with primitive functions", {
  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, sum)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, list(mean = mean, sum = sum))
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, min)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, max)
    )
  })
})

test_that("duckplyr_expand_across() with identity", {
  expect_snapshot({
    test_duckplyr_expand_across(
      tibble::tibble(x = 0, y = 0),
      across(x:y, identity)
    )
  })
})

test_that("duckplyr_expand_across() with where() predicates", {
  df <- tibble::tibble(x = 1:3, y = 4:6, z = c("a", "b", "c"))

  expect_snapshot({
    test_duckplyr_expand_across(
      df,
      across(where(is.numeric), mean)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      df,
      across(where(is.character), identity)
    )
  })
})

test_that("across() translation works end-to-end in mutate", {
  df <- as_duckdb_tibble(tibble::tibble(x = 1:3, y = 4:6))

  # identity
  out <- mutate(df, across(everything(), identity))
  expect_equal(as.data.frame(out), data.frame(x = 1:3, y = 4:6))

  # lambda
  out <- mutate(df, across(c(x, y), function(x) x * 2))
  expect_equal(as.data.frame(out), data.frame(x = c(2L, 4L, 6L), y = c(8L, 10L, 12L)))

  # tilde lambda
  out <- mutate(df, across(c(x, y), ~ .x + 1L))
  expect_equal(as.data.frame(out), data.frame(x = 2:4, y = 5:7))
})

test_that("across() translation works end-to-end in summarise", {
  df <- as_duckdb_tibble(tibble::tibble(x = c(1, 2, 3), y = c(4, 5, 6)))

  # simple function
  out <- summarise(df, across(c(x, y), mean))
  expect_equal(as.data.frame(out), data.frame(x = 2, y = 5))

  # list of functions
  out <- summarise(df, across(c(x, y), list(mean = mean, sum = sum)))
  expect_equal(
    as.data.frame(out),
    data.frame(x_mean = 2, x_sum = 6, y_mean = 5, y_sum = 15)
  )
})

test_that("across() with where() works end-to-end", {
  df <- as_duckdb_tibble(tibble::tibble(x = c(1, 2, 3), y = c(4, 5, 6), z = c("a", "b", "c")))

  out <- summarise(df, across(where(is.numeric), mean))
  expect_equal(as.data.frame(out), data.frame(x = 2, y = 5))

  out <- mutate(df, across(where(is.numeric), function(x) x * 2))
  expect_equal(
    as.data.frame(out),
    data.frame(x = c(2, 4, 6), y = c(8, 10, 12), z = c("a", "b", "c"))
  )
})
