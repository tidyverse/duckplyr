# Gezznezzrated by 04-dplyr-tests.R, do not edit by hand

# Workaround for lazytest
test_that("Dummy", { expect_true(TRUE) })

skip_if(Sys.getenv("DUCKPLYR_SKIP_DPLYR_TESTS") == "TRUE")

test_that("returns expected type/data", {
  df <- data.frame(g = 1:2, x = 1:2, y = 1:2)
  out <- duckplyr_nest_by(df, g)

  expect_s3_class(out, "rowwise_df")
  expect_equal(duckplyr_group_vars(out), "g")
  expect_named(out, c("g", "data"))
})

test_that("can control key col", {
  df <- data.frame(g = 1:2, x = 1:2, y = 1:2)
  out <- duckplyr_nest_by(df, g, .key = "key")
  expect_named(out, c("g", "key"))
})

test_that("duckplyr_nest_by() inherits grouping", {
  df <- data.frame(g1 = 1:2, g2 = 1:2, x = 1:2, y = 1:2)

  expect_equal(
    df |> duckplyr_group_by(g1) |> duckplyr_nest_by() |> duckplyr_group_vars(),
    "g1"
  )

  # And you can't have it both ways
  expect_error(df |> duckplyr_group_by(g1) |> duckplyr_nest_by("g2"), "re-group")
})

test_that("can control whether grouping data in list-col", {
  df <- data.frame(g = 1:2, x = 1:2, y = 1:2)
  out <- duckplyr_nest_by(df, g)
  expect_named(out$data[[1]], c("x", "y"))

  out <- duckplyr_nest_by(df, g, .keep = TRUE)
  expect_named(out$data[[1]], c("g", "x", "y"))
})
