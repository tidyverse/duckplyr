test_that("duckplyr_group_map() respects empty groups", {
  res <- duckplyr_group_by(mtcars, cyl) %>%
    duckplyr_group_map(~ head(.x, 2L))
  expect_equal(length(res), 3L)

  res <- iris %>%
    duckplyr_group_by(Species) %>%
    duckplyr_filter(Species == "setosa") %>%
    duckplyr_group_map(~ tally(.x))
  expect_equal(length(res), 1L)

  res <- iris %>%
    duckplyr_group_by(Species, .drop = FALSE) %>%
    duckplyr_filter(Species == "setosa") %>%
    duckplyr_group_map(~ tally(.x))
  expect_equal(length(res), 3L)
})

test_that("duckplyr_group_map() can return arbitrary objects", {
  expect_equal(
    duckplyr_group_by(mtcars, cyl) %>% duckplyr_group_map(~ 10),
    rep(list(10), 3)
  )
})

test_that("duckplyr_group_map() works on ungrouped data frames (#4067)", {
  expect_identical(
    duckplyr_group_map(mtcars, ~ head(.x, 2L)),
    list(head(as_tibble(mtcars), 2L))
  )
})

test_that("duckplyr_group_modify() makes a grouped_df", {
  res <- duckplyr_group_by(mtcars, cyl) %>%
    duckplyr_group_modify(~ head(.x, 2L))

  expect_equal(nrow(res), 6L)
  expect_equal(group_rows(res), list_of(1:2, 3:4, 5:6))

  res <- iris %>%
    duckplyr_group_by(Species) %>%
    duckplyr_filter(Species == "setosa") %>%
    duckplyr_group_modify(~ tally(.x))
  expect_equal(nrow(res), 1L)
  expect_equal(group_rows(res), list_of(1L))

  res <- iris %>%
    duckplyr_group_by(Species, .drop = FALSE) %>%
    duckplyr_filter(Species == "setosa") %>%
    duckplyr_group_modify(~ tally(.x))
  expect_equal(nrow(res), 3L)
  expect_equal(as.list(group_rows(res)), list(1L, 2L, 3L))
})

test_that("duckplyr_group_modify() and duckplyr_group_map() want functions with at least 2 arguments, or ... (#3996)", {
  head1 <- function(d, ...) head(d, 1)

  g <- iris %>% duckplyr_group_by(Species)
  expect_equal(nrow(duckplyr_group_modify(g, head1)), 3L)
  expect_equal(length(duckplyr_group_map(g, head1)), 3L)
})

test_that("duckplyr_group_modify() works on ungrouped data frames (#4067)", {
  expect_identical(
    duckplyr_group_modify(mtcars, ~ head(.x, 2L)),
    head(mtcars, 2L)
  )
})

test_that("duckplyr_group_map() uses ptype on empty splits (#4421)", {
  res <- mtcars %>%
    duckplyr_group_by(cyl) %>%
    duckplyr_filter(hp > 1000) %>%
    duckplyr_group_map(~.x)
  expect_equal(res, list(), ignore_attr = TRUE)
  ptype <- attr(res, "ptype")
  expect_equal(names(ptype), duckplyr_setdiff(names(mtcars), "cyl"))
  expect_equal(nrow(ptype), 0L)
  expect_s3_class(ptype, "data.frame")
})

test_that("duckplyr_group_modify() uses ptype on empty splits (#4421)", {
  res <- mtcars %>%
    duckplyr_group_by(cyl) %>%
    duckplyr_filter(hp > 1000) %>%
    duckplyr_group_modify(~.x)
  expect_equal(res, duckplyr_group_by(mtcars[integer(0L), names(res)], cyl))
})

test_that("duckplyr_group_modify() works with additional arguments (#4509)", {
  myfun <- function(.x, .y, foo) {
    .x[[foo]] <- 1
    .x
  }

  srcdata <-
    data.frame(
      A=rep(1:2, each = 3)
    ) %>%
    duckplyr_group_by(A)
  targetdata <- srcdata
  targetdata$bar <- 1

  expect_equal(
    duckplyr_group_modify(.data = srcdata, .f = myfun, foo = "bar"),
    targetdata
  )
})

test_that("duckplyr_group_map() does not warn about .keep= for rowwise_df", {
  expect_warning(
    data.frame(x = 1) %>% duckplyr_rowwise() %>% group_walk(~ {}),
    NA
  )
})

test_that("duckplyr_group_map() give meaningful errors", {
  head1 <- function(d) head(d, 1)

  expect_snapshot({
    # duckplyr_group_modify()
    (expect_error(mtcars %>% duckplyr_group_by(cyl) %>% duckplyr_group_modify(~ data.frame(cyl = 19))))
    (expect_error(mtcars %>% duckplyr_group_by(cyl) %>% duckplyr_group_modify(~ 10)))
    (expect_error(iris %>% duckplyr_group_by(Species) %>% duckplyr_group_modify(head1)))

    # duckplyr_group_map()
    (expect_error(iris %>% duckplyr_group_by(Species) %>% duckplyr_group_map(head1)))
  })

})
