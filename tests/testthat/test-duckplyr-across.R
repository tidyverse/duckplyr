test_that("duckplyr_expand_across() successful", {
  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y"),
      across(x:y, mean)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y"),
      across(x:y, function(x) mean(x))
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y"),
      across(c(x_mean = x, y_mean = y), mean)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y"),
      across(c(x_mean = x, y_mean = y), mean, .names = "{.col}_{.fn}")
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y"),
      across(x:y, function(x) mean(x, na.rm = TRUE))
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y", "a"),
      across(c(a, x), function(x) x + 1)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y", "a"),
      across(c(a, x), function(x) x * 2 + 1)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y", "a"),
      across(-a, function(x) x * x)
    )
  })

  expect_snapshot({
    test_duckplyr_expand_across(
      c("x", "y"),
      across(x:y, base::mean)
    )
  })
})

test_that("duckplyr_expand_across() failing", {
  expect_null(test_duckplyr_expand_across(
    c("x", "y"),
    across(x:y, mean, .unpack = TRUE)
  ))
  expect_null(test_duckplyr_expand_across(
    c("x", "y"),
    across(x:y, mean, na.rm = TRUE)
  ))
  expect_null(test_duckplyr_expand_across(
    c("x", "y"),
    across(x:y, list(mean))
  ))
  expect_null(test_duckplyr_expand_across(
    c("x", "y"),
    across(x:y, list(mean = mean))
  ))
  expect_null(test_duckplyr_expand_across(
    c("x", "y"),
    across(x:y, list(mean = mean, median = median))
  ))
})
