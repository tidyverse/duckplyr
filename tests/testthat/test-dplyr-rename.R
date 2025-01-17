test_that("duckplyr_rename() handles deprecated `.data` pronoun", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(duckplyr_rename(tibble(x = 1), y = .data$x), tibble(y = 1))
})

test_that("arguments to duckplyr_rename() don't match vars_rename() arguments (#2861)", {
  df <- tibble(a = 1)
  expect_identical(duckplyr_rename(df, var = a), tibble(var = 1))
  expect_identical(duckplyr_rename(duckplyr_group_by(df, a), var = a), duckplyr_group_by(tibble(var = 1), var))
  expect_identical(duckplyr_rename(df, strict = a), tibble(strict = 1))
  expect_identical(duckplyr_rename(duckplyr_group_by(df, a), strict = a), duckplyr_group_by(tibble(strict = 1), strict))
})

test_that("duckplyr_rename() to UTF-8 column names", {
  skip_if_not(l10n_info()$"UTF-8")

  df <- tibble(a = 1) %>% duckplyr_rename("\u5e78" := a)
  expect_equal(colnames(df), "\u5e78")
})

test_that("can duckplyr_rename() with strings and character vectors", {
  vars <- c(foo = "cyl", bar = "am")

  expect_identical(duckplyr_rename(mtcars, !!!vars), duckplyr_rename(mtcars, foo = cyl, bar = am))
  expect_identical(duckplyr_rename(mtcars, !!vars), duckplyr_rename(mtcars, foo = cyl, bar = am))
})

test_that("rename preserves grouping", {
  gf <- duckplyr_group_by(tibble(g = 1:3, x = 3:1), g)

  i <- count_regroups(out <- duckplyr_rename(gf, h = g))
  expect_equal(i, 0)
  expect_equal(duckplyr_group_vars(out), "h")
})

test_that("can rename with duplicate columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, x = 2, y = 1, .name_repair = "minimal")
  expect_named(df %>% duckplyr_rename(x2 = 2), c("x", "x2", "y"))
})

test_that("duckplyr_rename() ignores duplicates", {
  df <- tibble(x = 1)
  expect_named(duckplyr_rename(df, a = x, b = x), "b")
})

# rename_with -------------------------------------------------------------

test_that("can select columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2)
  expect_named(df %>% duckplyr_rename_with(toupper, 1), c("X", "y"))

  df <- tibble(x = 1, y = 2)
  expect_named(df %>% duckplyr_rename_with(toupper, x), c("X", "y"))
})

test_that("passes ... along", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2)
  expect_named(df %>% duckplyr_rename_with(gsub, 1, pattern = "x", replacement = "X"), c("X", "y"))
})

test_that("can't create duplicated names", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2)
  expect_error(df %>% duckplyr_rename_with(~ rep_along(.x, "X")), class = "vctrs_error_names")
})

test_that("`.fn` result type is checked (#6561)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1)
  fn <- function(x) 1L

  expect_snapshot(error = TRUE, {
    duckplyr_rename_with(df, fn)
  })
})

test_that("`.fn` result size is checked (#6561)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2)
  fn <- function(x) c("a", "b", "c")

  expect_snapshot(error = TRUE, {
    duckplyr_rename_with(df, fn)
  })
})

test_that("can't rename in `.cols`", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_rename_with(df, toupper, .cols = c(y = x))
  })
})
