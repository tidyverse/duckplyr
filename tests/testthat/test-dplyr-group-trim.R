# Gezznezzrated by 04-dplyr-tests.R, do not edit by hand

# Workaround for lazytest
test_that("Dummy", { expect_true(TRUE) })

skip_if(Sys.getenv("DUCKPLYR_SKIP_DPLYR_TESTS") == "TRUE")

test_that("duckplyr_group_trim() is identity on non grouped data", {
  expect_identical(duckplyr_group_trim(iris), iris)
})

test_that("duckplyr_group_trim() always regroups even if no factors", {
  res <- mtcars |>
    duckplyr_group_by(cyl) |>
    duckplyr_filter(cyl == 6, .preserve = TRUE) |>
    duckplyr_group_trim()
  expect_equal(duckplyr_n_groups(res), 1L)
})

test_that("duckplyr_group_trim() drops factor levels in data and grouping structure", {
  res <- iris |>
    duckplyr_group_by(Species) |>
    duckplyr_filter(Species == "setosa") |>
    duckplyr_group_trim()

  expect_equal(duckplyr_n_groups(res), 1L)
  expect_equal(levels(res$Species), "setosa")
  expect_equal(levels(attr(res, "groups")$Species), "setosa")
})
