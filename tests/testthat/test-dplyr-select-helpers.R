# Gezznezzrated by 04-dplyr-tests.R, do not edit by hand

# Workaround for lazytest
test_that("Dummy", {
  expect_true(TRUE)
})

skip_if(Sys.getenv("DUCKPLYR_SKIP_DPLYR_TESTS") == "TRUE")

test_that("group_cols() selects grouping variables", {
  df <- tibble(x = 1:3, y = 1:3)
  gf <- duckplyr_group_by(df, x)

  expect_equal(df |> duckplyr_select(group_cols()), df[integer()])
  expect_message(
    expect_equal(gf |> duckplyr_select(group_cols()), gf["x"]),
    NA
  )
})

test_that("group_cols() finds groups in scoped helpers", {
  gf <- duckplyr_group_by(tibble(x = 1, y = 2), x)
  out <- select_at(gf, vars(group_cols()))
  expect_named(out, "x")
})

test_that("group_cols(vars =) is defunct", {
  expect_snapshot(error = TRUE, {
    group_cols("a")
  })
})
