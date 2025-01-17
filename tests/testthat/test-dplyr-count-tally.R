# count -------------------------------------------------------------------

test_that("count sorts output by keys by default", {
  # Due to usage of `duckplyr_summarise()` internally
  df <- tibble(x = c(2, 1, 1, 2, 1))
  out <- duckplyr_count(df, x)
  expect_equal(out, tibble(x = c(1, 2), n = c(3, 2)))
})

test_that("count can sort output by `n`", {
  df <- tibble(x = c(1, 1, 2, 2, 2))
  out <- duckplyr_count(df, x, sort = TRUE)
  expect_equal(out, tibble(x = c(2, 1), n = c(3, 2)))
})

test_that("count can rename grouping columns", {
  # But should it really allow this?
  df <- tibble(x = c(2, 1, 1, 2, 1))
  out <- duckplyr_count(df, y = x)
  expect_equal(out, tibble(y = c(1, 2), n = c(3, 2)))
})

test_that("informs if n column already present, unless overridden", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df1 <- tibble(n = c(1, 1, 2, 2, 2))
  expect_message(out <- duckplyr_count(df1, n), "already present")
  expect_named(out, c("n", "nn"))

  # not a good idea, but supported
  expect_message(out <- duckplyr_count(df1, n, name = "n"), NA)
  expect_named(out, "n")

  expect_message(out <- duckplyr_count(df1, n, name = "nn"), NA)
  expect_named(out, c("n", "nn"))

  df2 <- tibble(n = c(1, 1, 2, 2, 2), nn = 1:5)
  expect_message(out <- duckplyr_count(df2, n), "already present")
  expect_named(out, c("n", "nn"))

  expect_message(out <- duckplyr_count(df2, n, nn), "already present")
  expect_named(out, c("n", "nn", "nnn"))
})

test_that("name must be string", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = c(1, 2))
  expect_snapshot(error = TRUE, duckplyr_count(df, x, name = 1))
  expect_snapshot(error = TRUE, duckplyr_count(df, x, name = letters))
})

test_that("output includes empty levels with .drop = FALSE", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(f = factor("b", levels = c("a", "b", "c")))
  out <- duckplyr_count(df, f, .drop = FALSE)
  expect_equal(out$n, c(0, 1, 0))

  out <- duckplyr_count(duckplyr_group_by(df, f, .drop = FALSE))
  expect_equal(out$n, c(0, 1, 0))
})

test_that("count preserves grouping", {
  df <- tibble(g = c(1, 2, 2, 2))
  exp <- tibble(g = c(1, 2), n = c(1, 3))

  expect_equal(df %>% duckplyr_count(g), exp)
  expect_equal(df %>% duckplyr_group_by(g) %>% duckplyr_count(), exp %>% duckplyr_group_by(g))
})

test_that("output preserves class & attributes where possible", {
  df <- data.frame(g = c(1, 2, 2, 2))
  attr(df, "my_attr") <- 1

  out <- df %>% duckplyr_count(g)
  expect_s3_class(out, "data.frame", exact = TRUE)
  expect_equal(attr(out, "my_attr"), 1)

  out <- df %>% duckplyr_group_by(g) %>% duckplyr_count()
  expect_s3_class(out, "grouped_df")
  expect_equal(duckplyr_group_vars(out), "g")
  # duckplyr_summarise() currently drops attributes
  expect_null(attr(out, "my_attr"))
})

test_that("works with dbplyr", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("RSQLite")

  db <- dbplyr::memdb_frame(x = c(1, 1, 1, 2, 2))
  df1 <- db %>% duckplyr_count(x) %>% as_tibble()
  expect_equal(df1, tibble(x = c(1, 2), n = c(3, 2)))

  df2 <- db %>% duckplyr_add_count(x) %>% as_tibble()
  expect_equal(df2, tibble(x = c(1, 1, 1, 2, 2), n = c(3, 3, 3, 2, 2)))
})

test_that("dbplyr `duckplyr_count()` method has transient internal grouping (#6338, tidyverse/dbplyr#940)", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("RSQLite")

  db <- dbplyr::memdb_frame(
    x = c(1, 1, 1, 2, 2),
    y = c("a", "a", "b", "c", "c")
  )

  df <- db %>%
    duckplyr_count(x, y) %>%
    duckplyr_collect()

  expect <- tibble(
    x = c(1, 1, 2),
    y = c("a", "b", "c"),
    n = c(2L, 1L, 2L)
  )

  expect_false(is_grouped_df(df))
  expect_identical(df, expect)
})

test_that("can only explicitly chain together multiple tallies", {
  expect_snapshot({
    df <- data.frame(g = c(1, 1, 2, 2), n = 1:4)

    df %>% duckplyr_count(g, wt = n)
    df %>% duckplyr_count(g, wt = n) %>% duckplyr_count(wt = n)
    df %>% duckplyr_count(n)
  })
})

test_that("wt = n() is deprecated", {
  df <- data.frame(x = 1:3)
  expect_warning(duckplyr_count(df, wt = n()), "`wt = n()`", fixed = TRUE)
})

test_that("duckplyr_count() owns errors (#6139)", {
  expect_snapshot({
    (expect_error(duckplyr_count(mtcars, new = 1 + "")))
    (expect_error(duckplyr_count(mtcars, wt = 1 + "")))
  })
})

# tally -------------------------------------------------------------------

test_that("tally can sort output", {
  gf <- duckplyr_group_by(tibble(x = c(1, 1, 2, 2, 2)), x)
  out <- tally(gf, sort = TRUE)
  expect_equal(out, tibble(x = c(2, 1), n = c(3, 2)))
})

test_that("weighted tally drops NAs (#1145)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = c(1, 1, NA))
  expect_equal(tally(df, x)$n, 2)
})

test_that("tally() drops last group (#5199) ", {
  df <- data.frame(x = 1, y = 2, z = 3)

  res <- expect_message(df %>% duckplyr_group_by(x, y) %>% tally(wt = z), NA)
  expect_equal(duckplyr_group_vars(res), "x")
})

test_that("tally() owns errors (#6139)", {
  expect_snapshot({
    (expect_error(tally(mtcars, wt = 1 + "")))
  })
})

# add_count ---------------------------------------------------------------

test_that("add_count preserves grouping", {
  df <- tibble(g = c(1, 2, 2, 2))
  exp <- tibble(g = c(1, 2, 2, 2), n = c(1, 3, 3, 3))

  expect_equal(df %>% duckplyr_add_count(g), exp)
  expect_equal(df %>% duckplyr_group_by(g) %>% duckplyr_add_count(), exp %>% duckplyr_group_by(g))
})

test_that(".drop is deprecated",  {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  local_options(lifecycle_verbosity = "warning")

  df <- tibble(f = factor("b", levels = c("a", "b", "c")))
  expect_warning(out <- duckplyr_add_count(df, f, .drop = FALSE), "deprecated")
})

test_that("duckplyr_add_count() owns errors (#6139)", {
  expect_snapshot({
    (expect_error(duckplyr_add_count(mtcars, new = 1 + "")))
    (expect_error(duckplyr_add_count(mtcars, wt = 1 + "")))
  })
})

# add_tally ---------------------------------------------------------------

test_that("can add tallies of a variable", {
  df <- tibble(a = c(2, 1, 1))
  expect_equal(
    df %>% duckplyr_group_by(a) %>% add_tally(),
    duckplyr_group_by(tibble(a = c(2, 1, 1), n = c(1, 2, 2)), a)
  )
})

test_that("add_tally can be given a weighting variable", {
  df <- data.frame(a = c(1, 1, 2, 2, 2), w = c(1, 1, 2, 3, 4))

  out <- df %>% duckplyr_group_by(a) %>% add_tally(wt = w)
  expect_equal(out$n, c(2, 2, 9, 9, 9))

  out <- df %>% duckplyr_group_by(a) %>% add_tally(wt = w + 1)
  expect_equal(out$n, c(4, 4, 12, 12, 12))
})

test_that("can override output column", {
  df <- data.frame(g = c(1, 1, 2, 2, 2), x = c(3, 2, 5, 5, 5))
  expect_named(add_tally(df, name = "xxx"), c("g", "x", "xxx"))
})

test_that("add_tally() owns errors (#6139)", {
  expect_snapshot({
    (expect_error(add_tally(mtcars, wt = 1 + "")))
  })
})
