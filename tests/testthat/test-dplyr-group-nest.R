# Gezznezzrated by 04-dplyr-tests.R, do not edit by hand

# Workaround for lazytest
test_that("Dummy", {
  expect_true(TRUE)
})

skip_if(Sys.getenv("DUCKPLYR_SKIP_DPLYR_TESTS") == "TRUE")

test_that("duckplyr_group_nest() works", {
  grouped <- duckplyr_group_by(starwars, species, homeworld)
  gdata <- group_data(grouped)

  res <- duckplyr_group_nest(starwars, species, homeworld)
  expect_type(duckplyr_pull(res), "list")
  expect_equal(
    attr(duckplyr_pull(res), "ptype"),
    vec_slice(duckplyr_select(starwars, -species, -homeworld), 0L)
  )

  expect_equal(res[1:2], structure(gdata[1:2], .drop = NULL))

  nested <- bind_rows(!!!res$data)
  expect_equal(
    names(nested),
    duckplyr_setdiff(names(starwars), c("species", "homeworld"))
  )
})

test_that("duckplyr_group_nest() can keep the grouping variables", {
  grouped <- duckplyr_group_by(starwars, species, homeworld)
  gdata <- group_data(grouped)

  res <- duckplyr_group_nest(starwars, species, homeworld, keep = TRUE)
  nested <- bind_rows(!!!res$data)
  expect_equal(names(nested), names(starwars))
})

test_that("duckplyr_group_nest() works on grouped data frames", {
  grouped <- duckplyr_group_by(starwars, species, homeworld)
  gdata <- group_data(grouped)

  res <- duckplyr_group_nest(grouped)
  expect_type(duckplyr_pull(res), "list")
  expect_equal(res[1:2], structure(gdata[1:2], .drop = NULL))
  expect_equal(
    names(bind_rows(!!!res$data)),
    duckplyr_setdiff(names(starwars), c("species", "homeworld"))
  )

  res <- duckplyr_group_nest(grouped, keep = TRUE)
  expect_type(duckplyr_pull(res), "list")
  expect_equal(attr(duckplyr_pull(res), "ptype"), vec_slice(starwars, 0L))

  expect_equal(res[1:2], structure(gdata[1:2], .drop = NULL))
  expect_equal(names(bind_rows(!!!res$data)), names(starwars))
})

test_that("group_nest.grouped_df() warns about ...", {
  expect_warning(duckplyr_group_nest(duckplyr_group_by(mtcars, cyl), cyl))
})

test_that("duckplyr_group_nest() works if no grouping column", {
  skip("TODO duckdb")
  res <- duckplyr_group_nest(iris)
  expect_equal(res$data, list(iris))
  expect_equal(names(res), "data")
})

test_that("duckplyr_group_nest() respects .drop", {
  nested <- tibble(f = factor("b", levels = c("a", "b", "c")), x = 1, y = 2) |>
    duckplyr_group_nest(f, .drop = TRUE)
  expect_equal(nrow(nested), 1L)
})
