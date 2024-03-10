test_that("non-syntactic grouping variable is preserved (#1138)", {
  df <- tibble(`a b` = 1L) %>% duckplyr_group_by(`a b`) %>% duckplyr_transmute()
  expect_named(df, "a b")
})

test_that("transmute preserves grouping", {
  gf <- duckplyr_group_by(tibble(x = 1:2, y = 2), x)

  i <- count_regroups(out <- duckplyr_transmute(gf, x = 1))
  expect_equal(i, 1L)
  expect_equal(duckplyr_group_vars(out), "x")
  expect_equal(nrow(group_data(out)), 1)

  i <- count_regroups(out <- duckplyr_transmute(gf, z = 1))
  expect_equal(i, 0)
  expect_equal(group_data(out), group_data(gf))
})

# Empty transmutes -------------------------------------------------

test_that("transmute with no args returns grouping vars", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2)
  gf <- duckplyr_group_by(df, x)

  expect_equal(df %>% duckplyr_transmute(), df[integer()])
  expect_equal(gf %>% duckplyr_transmute(), gf[1L])
})

# transmute variables -----------------------------------------------

test_that("transmute succeeds in presence of raw columns (#1803)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(a = 1:3, b = as.raw(1:3))
  expect_identical(duckplyr_transmute(df, a), df["a"])
  expect_identical(duckplyr_transmute(df, b), df["b"])
})

test_that("arguments to duckplyr_transmute() don't match vars_transmute() arguments", {
  df <- tibble(a = 1)
  expect_identical(duckplyr_transmute(df, var = a), tibble(var = 1))
  expect_identical(duckplyr_transmute(df, exclude = a), tibble(exclude = 1))
  expect_identical(duckplyr_transmute(df, include = a), tibble(include = 1))
})

test_that("arguments to duckplyr_rename() don't match vars_rename() arguments (#2861)", {
  df <- tibble(a = 1)
  expect_identical(duckplyr_rename(df, var = a), tibble(var = 1))
  expect_identical(duckplyr_rename(duckplyr_group_by(df, a), var = a), duckplyr_group_by(tibble(var = 1), var))
  expect_identical(duckplyr_rename(df, strict = a), tibble(strict = 1))
  expect_identical(duckplyr_rename(duckplyr_group_by(df, a), strict = a), duckplyr_group_by(tibble(strict = 1), strict))
})

test_that("can duckplyr_transmute() with .data pronoun (#2715)", {
  expect_identical(duckplyr_transmute(mtcars, .data$cyl), duckplyr_transmute(mtcars, cyl))
})

test_that("duckplyr_transmute() does not warn when a variable is removed with = NULL (#4609)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x=1)
  expect_warning(duckplyr_transmute(df, y =x+1, z=y*2, y = NULL), NA)
})

test_that("duckplyr_transmute() can handle auto splicing", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_equal(
    iris %>% duckplyr_transmute(tibble(Sepal.Length, Sepal.Width)),
    iris %>% duckplyr_select(Sepal.Length, Sepal.Width)
  )
})

test_that("duckplyr_transmute() retains ordering supplied in `...`, even for pre-existing columns (#6086)", {
  df <- tibble(x = 1:3, y = 4:6)
  out <- duckplyr_transmute(df, x, z = x + 1, y)
  expect_named(out, c("x", "z", "y"))
})

test_that("duckplyr_transmute() retains ordering supplied in `...`, even for group columns (#6086)", {
  df <- tibble(x = 1:3, g1 = 1:3, g2 = 1:3, y = 4:6)
  df <- duckplyr_group_by(df, g1, g2)

  out <- duckplyr_transmute(df, x, z = x + 1, y, g1)

  # - Untouched group variables are first
  # - Following by ordering supplied through `...`
  expect_named(out, c("g2", "x", "z", "y", "g1"))
})

test_that("duckplyr_transmute() error messages", {
  expect_snapshot({
    (expect_error(duckplyr_transmute(mtcars, cyl2 = cyl, .keep = 'all')))
    (expect_error(duckplyr_transmute(mtcars, cyl2 = cyl, .before = disp)))
    (expect_error(duckplyr_transmute(mtcars, cyl2 = cyl, .after = disp)))
  })
})
