test_that("empty mutate returns input", {
  df <- tibble(x = 1)
  gf <- duckplyr_group_by(df, x)

  expect_equal(duckplyr_mutate(df), df)
  expect_equal(duckplyr_mutate(df, .by = x), df)
  expect_equal(duckplyr_mutate(gf), gf)

  expect_equal(duckplyr_mutate(df, !!!list()), df)
  expect_equal(duckplyr_mutate(df, !!!list(), .by = x), df)
  expect_equal(duckplyr_mutate(gf, !!!list()), gf)
})

test_that("rownames preserved", {
  df <- data.frame(x = c(1, 2), row.names = c("a", "b"))

  df <- duckplyr_mutate(df, y = 2)
  expect_equal(row.names(df), c("a", "b"))

  df <- duckplyr_mutate(df, y = 2, .by = x)
  expect_equal(row.names(df), c("a", "b"))
})

test_that("mutations applied progressively", {
  df <- tibble(x = 1)
  expect_equal(df %>% duckplyr_mutate(y = x + 1, z = y + 1), tibble(x = 1, y = 2, z = 3))
  expect_equal(df %>% duckplyr_mutate(x = x + 1, x = x + 1), tibble(x = 3))
  expect_equal(df %>% duckplyr_mutate(x = 2, y = x), tibble(x = 2, y = 2))

  df <- data.frame(x = 1, y = 2)
  expect_equal(
    df %>% duckplyr_mutate(x2 = x, x3 = x2 + 1),
    df %>% duckplyr_mutate(x2 = x + 0, x3 = x2 + 1)
  )
})

test_that("length-1 vectors are recycled (#152)", {
  df <- tibble(x = 1:4)
  expect_equal(duckplyr_mutate(df, y = 1)$y, rep(1, 4))
  expect_error(duckplyr_mutate(df, y = 1:2))
})

test_that("can remove variables with NULL (#462)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:3, y = 1:3)
  gf <- duckplyr_group_by(df, x)

  expect_equal(df %>% duckplyr_mutate(y = NULL), df[1])
  expect_equal(gf %>% duckplyr_mutate(y = NULL), gf[1])

  # even if it doesn't exist
  expect_equal(df %>% duckplyr_mutate(z = NULL), df)
  # or was just created
  expect_equal(df %>% duckplyr_mutate(z = 1, z = NULL), df)

  # regression test for https://github.com/tidyverse/dplyr/issues/4974
  expect_equal(
    duckplyr_mutate(data.frame(x = 1, y = 1), z = 1, x = NULL, y = NULL),
    data.frame(z = 1)
  )
})

test_that("duckplyr_mutate() names pronouns correctly (#2686)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_named(duckplyr_mutate(tibble(x = 1), .data$x), "x")
  expect_named(duckplyr_mutate(tibble(x = 1), .data[["x"]]), "x")
})

test_that("duckplyr_mutate() supports unquoted values", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(1, 1, 2, 2, 2), x = 1:5)
  expect_identical(duckplyr_mutate(df, out = !!1), duckplyr_mutate(df, out = 1))
  expect_identical(duckplyr_mutate(df, out = !!(1:5)), duckplyr_mutate(df, out = 1:5))
  expect_identical(duckplyr_mutate(df, out = !!quote(1:5)), duckplyr_mutate(df, out = 1:5))

  gdf <- duckplyr_group_by(df, g)
  expect_identical(duckplyr_mutate(gdf, out = !!1), duckplyr_mutate(gdf, out = 1))
})

test_that("assignments don't overwrite variables (#315)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2)
  out <- df %>% duckplyr_mutate(z = {x <- 10; x})
  expect_equal(out, tibble(x = 1, y = 2, z = 10))
})

test_that("can mutate a data frame with zero columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- new_data_frame(n = 2L)
  expect_equal(duckplyr_mutate(df, x = 1), data.frame(x = c(1, 1)))
})

test_that("duckplyr_mutate() handles symbol expressions", {
  df <- tibble(x = structure(1, class = "alien"))
  res <- duckplyr_mutate(df, y = x)
  expect_identical(df$x, res$y)

  gf <- duckplyr_group_by(df, x)
  res <- duckplyr_mutate(df, y = x)
  expect_identical(df$x, res$y)
})

test_that("duckplyr_mutate() supports constants (#6056, #6305)", {
  df <- data.frame(x = 1:10, g = rep(1:2, each = 5))
  y <- 1:10
  z <- 1:5

  expect_identical(df %>% duckplyr_mutate(y = !!y) %>% duckplyr_pull(y), y)
  expect_identical(df %>% duckplyr_group_by(g) %>% duckplyr_mutate(y = !!y) %>% duckplyr_pull(y), y)
  expect_identical(df %>% duckplyr_rowwise() %>% duckplyr_mutate(y = !!y) %>% duckplyr_pull(y), y)

  expect_snapshot({
    (expect_error(df %>% duckplyr_mutate(z = !!z)))
    (expect_error(df %>% duckplyr_group_by(g) %>% duckplyr_mutate(z = !!z)))
    (expect_error(df %>% duckplyr_rowwise() %>% duckplyr_mutate(z = !!z)))
  })

  # `.env$` is used for per group evaluation
  expect_identical(df %>% duckplyr_mutate(y = .env$y) %>% duckplyr_pull(y), y)
  expect_identical(df %>% duckplyr_group_by(g) %>% duckplyr_mutate(z = .env$z) %>% duckplyr_pull(z), c(z, z))

  expect_snapshot({
    (expect_error(df %>% duckplyr_group_by(g) %>% duckplyr_mutate(y = .env$y)))
    (expect_error(df %>% duckplyr_rowwise() %>% duckplyr_mutate(y = .env$y)))
  })
})

test_that("can't overwrite column active bindings (#6666)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  skip_if(getRversion() < "3.6.3", message = "Active binding error changed")

  df <- tibble(g = 1:2, x = 3:4)
  gdf <- duckplyr_group_by(df, g)

  # The error seen here comes from trying to `<-` to an active binding when
  # the active binding function has 0 arguments.
  expect_snapshot(error = TRUE, {
    duckplyr_mutate(df, y = {
      x <<- 2
      x
    })
  })
  expect_snapshot(error = TRUE, {
    duckplyr_mutate(df, .by = g, y = {
      x <<- 2
      x
    })
  })
  expect_snapshot(error = TRUE, {
    duckplyr_mutate(gdf, y = {
      x <<- 2
      x
    })
  })
})

test_that("assigning with `<-` doesn't affect the mask (#6666)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = 1:2, x = 3:4)
  gdf <- duckplyr_group_by(df, g)

  out <- duckplyr_mutate(df, .by = g, y = {
    x <- x + 2L
    x
  })
  expect_identical(out$x, c(3L, 4L))
  expect_identical(out$y, c(5L, 6L))

  out <- duckplyr_mutate(gdf, y = {
    x <- x + 2L
    x
  })
  expect_identical(out$x, c(3L, 4L))
  expect_identical(out$y, c(5L, 6L))
})

test_that("`across()` inline expansions that use `<-` don't affect the mask (#6666)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = 1:2, x = 3:4)

  out <- df %>%
    duckplyr_mutate(
      across(x, function(col) {
        col <- col + 2L
        col
      }),
      .by = g
    )

  expect_identical(out$x, c(5L, 6L))
})

test_that("can't share local variables across expressions (#6666)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:2, y = 3:4)

  expect_snapshot(error = TRUE, {
    duckplyr_mutate(
      df,
      x2 = {
        foo <- x
        x
      },
      y2 = {
        foo
      }
    )
  })
})

# column types ------------------------------------------------------------

test_that("glue() is supported", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_equal(
    tibble(x = 1) %>% duckplyr_mutate(y = glue("")),
    tibble(x = 1, y = glue(""))
  )
})

test_that("mutate disambiguates NA and NaN (#1448)", {
  df <- tibble(x = c(1, NA, NaN))
  out <- duckplyr_mutate(df, y = x * 1)
  expect_equal(out$y, df$x)
})

test_that("mutate preserves names (#1689, #2675)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(a = 1:3)
  out1 <- df %>% duckplyr_mutate(b = setNames(1:3, letters[1:3]))
  out2 <- df %>% duckplyr_mutate(b = setNames(as.list(1:3), letters[1:3]))

  expect_named(out1$b, letters[1:3])
  expect_named(out2$b, letters[1:3])
})

test_that("mutate handles matrix columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(a = rep(1:3, each = 2), b = 1:6)

  df_regular <- duckplyr_mutate(df, b = scale(b))
  df_grouped <- duckplyr_mutate(duckplyr_group_by(df, a), b = scale(b))
  df_rowwise <- duckplyr_mutate(duckplyr_rowwise(df), b = scale(b))

  expect_equal(dim(df_regular$b), c(6, 1))
  expect_equal(dim(df_grouped$b), c(6, 1))
  expect_equal(dim(df_rowwise$b), c(6, 1))
})

test_that("mutate handles data frame columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame("a" = c(1, 2, 3), "b" = c(2, 3, 4), "base_col" = c(3, 4, 5))
  res <- duckplyr_mutate(df, new_col = data.frame(x = 1:3))
  expect_equal(res$new_col, data.frame(x = 1:3))

  res <- duckplyr_mutate(duckplyr_group_by(df, a), new_col = data.frame(x = a))
  expect_equal(res$new_col, data.frame(x = 1:3))

  res <- duckplyr_mutate(duckplyr_rowwise(df), new_col = data.frame(x = a))
  expect_equal(res$new_col, data.frame(x = 1:3))
})

test_that("unnamed data frames are automatically unspliced  (#2326, #3630)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_identical(
    tibble(a = 1) %>% duckplyr_mutate(tibble(b = 2)),
    tibble(a = 1, b = 2)
  )
  expect_identical(
    tibble(a = 1) %>% duckplyr_mutate(tibble(b = 2), tibble(b = 3)),
    tibble(a = 1, b = 3)
  )
  expect_identical(
    tibble(a = 1) %>% duckplyr_mutate(tibble(b = 2), c = b),
    tibble(a = 1, b = 2, c = 2)
  )
})

test_that("named data frames are packed (#2326, #3630)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1)
  out <- df %>% duckplyr_mutate(y = tibble(a = x))
  expect_equal(out, tibble(x = 1, y = tibble(a = 1)))
})

test_that("unchop only called for when multiple groups", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(g = 1, x = 1:5)
  out <- duckplyr_mutate(df, x = ts(x, start = c(1971, 1), frequency = 52))
  expect_s3_class(out$x, "ts")

  gdf <- duckplyr_group_by(df, g)
  out <- duckplyr_mutate(gdf, x = ts(x, start = c(1971, 1), frequency = 52))
  expect_s3_class(out$x, "ts")
})

# output types ------------------------------------------------------------

test_that("mutate preserves grouping", {
  gf <- duckplyr_group_by(tibble(x = 1:2, y = 2), x)

  i <- count_regroups(out <- duckplyr_mutate(gf, x = 1))
  expect_equal(i, 1L)
  expect_equal(duckplyr_group_vars(out), "x")
  expect_equal(nrow(group_data(out)), 1)

  i <- count_regroups(out <- duckplyr_mutate(gf, z = 1))
  expect_equal(i, 0)
  expect_equal(group_data(out), group_data(gf))
})

test_that("mutate works on zero-row grouped data frame (#596)", {
  dat <- data.frame(a = numeric(0), b = character(0), stringsAsFactors = TRUE)
  res <- dat %>% duckplyr_group_by(b, .drop = FALSE) %>% duckplyr_mutate(a2 = a * 2)
  expect_type(res$a2, "double")
  expect_s3_class(res, "grouped_df")
  expect_equal(res$a2, numeric(0))

  expect_type(group_rows(res), "list")
  expect_equal(attr(group_rows(res), "ptype"), integer())
  expect_equal(group_data(res)$b, factor(character(0)))
})

test_that("mutate preserves class of zero-row rowwise (#4224, #6303)", {
  # Each case needs to test both x and identity(x) because these flow
  # through two slightly different pathways.

  rf <- duckplyr_rowwise(tibble(x = character(0)))
  out <- duckplyr_mutate(rf, x2 = identity(x), x3 = x)
  expect_equal(out$x2, character())
  expect_equal(out$x3, character())

  # including list-of classes of list-cols where possible
  rf <- duckplyr_rowwise(tibble(x = list_of(.ptype = character())))
  out <- duckplyr_mutate(rf, x2 = identity(x), x3 = x)
  expect_equal(out$x2, character())
  expect_equal(out$x3, character())

  # an empty list is turns into a logical (aka unspecified)
  rf <- duckplyr_rowwise(tibble(x = list()))
  out <- duckplyr_mutate(rf, x2 = identity(x), x3 = x)
  expect_equal(out$x2, logical())
  expect_equal(out$x3, logical())
})

test_that("mutate works on empty data frames (#1142)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame()
  res <- df %>% duckplyr_mutate()
  expect_equal(nrow(res), 0L)
  expect_equal(length(res), 0L)

  res <- df %>% duckplyr_mutate(x = numeric())
  expect_equal(names(res), "x")
  expect_equal(nrow(res), 0L)
  expect_equal(length(res), 1L)
})

test_that("mutate handles 0 rows rowwise (#1300)", {
  res <- tibble(y = character()) %>% duckplyr_rowwise() %>% duckplyr_mutate(z = 1)
  expect_equal(nrow(res), 0L)
})

test_that("rowwise mutate gives expected results (#1381)", {
  f <- function(x) ifelse(x < 2, NA_real_, x)
  res <- tibble(x = 1:3) %>% duckplyr_rowwise() %>% duckplyr_mutate(y = f(x))
  expect_equal(res$y, c(NA, 2, 3))
})

test_that("rowwise mutate un-lists existing size-1 list-columns (#6302)", {
  # Existing column
  rf <- duckplyr_rowwise(tibble(x = as.list(1:3)))
  out <- duckplyr_mutate(rf, y = x)
  expect_equal(out$y, 1:3)

  # New column
  rf <- duckplyr_rowwise(tibble(x = 1:3))
  out <- duckplyr_mutate(rf, y = list(1), z = y)
  expect_identical(out$z, c(1, 1, 1))

  # Column of data 1-row data frames
  rf <- duckplyr_rowwise(tibble(x = list(tibble(a = 1), tibble(a = 2))))
  out <- duckplyr_mutate(rf, y = x)
  expect_identical(out$y, tibble(a = c(1, 2)))

  # Preserves known list-of type
  rf <- duckplyr_rowwise(tibble(x = list_of(.ptype = character())))
  out <- duckplyr_mutate(rf, y = x)
  expect_identical(out$y, character())

  # Errors if it's not a length-1 list
  df <- duckplyr_rowwise(tibble(x = list(1, 2:3)))
  expect_snapshot(duckplyr_mutate(df, y = x), error = TRUE)
})


test_that("grouped mutate does not drop grouping attributes (#1020)", {
  d <- data.frame(subject = c("Jack", "Jill"), id = c(2, 1)) %>% duckplyr_group_by(subject)
  a1 <- names(attributes(d))
  a2 <- names(attributes(d %>% duckplyr_mutate(foo = 1)))
  expect_equal(duckplyr_setdiff(a1, a2), character(0))
})

test_that("duckplyr_mutate() hands list columns with rowwise magic to follow up expressions (#4845)", {
  test <- duckplyr_rowwise(tibble(x = 1:2))

  expect_identical(
    test %>%
      duckplyr_mutate(a = list(1)) %>%
      duckplyr_mutate(b = list(a + 1)),
    test %>%
      duckplyr_mutate(a = list(1), b = list(a + 1))
  )
})

test_that("mutate keeps zero length groups", {
  df <- tibble(
    e = 1,
    f = factor(c(1, 1, 2, 2), levels = 1:3),
    g = c(1, 1, 2, 2),
    x = c(1, 2, 1, 4)
  )
  df <- duckplyr_group_by(df, e, f, g, .drop = FALSE)

  expect_equal( duckplyr_group_size(duckplyr_mutate(df, z = 2)), c(2, 2, 0) )
})

# other -------------------------------------------------------------------

test_that("no utf8 invasion (#722)", {
  skip_if_not(l10n_info()$"UTF-8")
  skip_if_not_installed("lobstr")
  source("utf-8.txt", local = TRUE, encoding = "UTF-8")
})

test_that("duckplyr_mutate() to UTF-8 column names", {
  df <- tibble(a = 1) %>% duckplyr_mutate("\u5e78" := a)

  expect_equal(colnames(df), c("a", "\u5e78"))
})

test_that("Non-ascii column names in version 0.3 are not duplicated (#636)", {
  local_non_utf8_encoding()

  df <- tibble(a = "1", b = "2")
  names(df) <- c("a", enc2native("\u4e2d"))

  res <- df %>% mutate_all(as.numeric)
  expect_equal(names(res), as_utf8_character(names(df)))
})

test_that("mutate coerces results from one group with all NA values (#1463) ", {
  df <- tibble(x = c(1, 2), y = c(1, NA))
  res <- df %>% duckplyr_group_by(x) %>% duckplyr_mutate(z = ifelse(y > 1, 1, 2))
  expect_true(is.na(res$z[2]))
  expect_type(res$z, "double")
})

test_that("grouped subsets are not lazy (#3360)", {
  make_call <- function(x) {
    quo(!!x)
  }

  res <- tibble(name = 1:2, value = letters[1:2]) %>%
    duckplyr_rowwise() %>%
    duckplyr_mutate(call = list(make_call(value))) %>%
    duckplyr_pull()

  expect_identical(res, list(make_call("a"), make_call("b")))

  res <- tibble(name = 1:2, value = letters[1:2]) %>%
    duckplyr_group_by(name) %>%
    duckplyr_mutate(call = list(make_call(value))) %>%
    duckplyr_pull()

  expect_identical(res, list(make_call("a"), make_call("b")))
})

test_that("duckplyr_mutate() evaluates expression for empty groups", {
  df <- tibble(f = factor(c("a", "b"), levels = c("a", "b", "c")))
  gf <- duckplyr_group_by(df, f, .drop = FALSE)

  count <- 0
  duckplyr_mutate(gf, x = {count <<- count + 1})
  expect_equal(count, 3L)
})

test_that("DataMask$add() forces chunks (#4677)", {
  df <- tibble(bf10 = 0.244) %>%
    duckplyr_mutate(
      bf01 = 1 / bf10,
      log_e_bf10 = log(bf10),
      log_e_bf01 = log(bf01)
    )
  expect_equal(df$log_e_bf01, log(1 / 0.244))
})

test_that("DataMask uses fresh copies of group id / size variables (#6762)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:2)

  fn <- function() {
    df <- tibble(a = 1)
    # Otherwise, this nested `duckplyr_mutate()` can modify the same
    # id/size variable as the outer one, which causes havoc
    duckplyr_mutate(df, b = a + 1)
  }

  out <- duckplyr_mutate(df, y = {fn(); x})

  expect_identical(out$x, 1:2)
  expect_identical(out$y, 1:2)
})

test_that("duckplyr_mutate() correctly auto-names expressions (#6741)", {
  df <- tibble(a = 1L)

  expect_identical(duckplyr_mutate(df, -a), tibble(a = 1L, "-a" = -1L))

  foo <- "foobar"
  expect_identical(duckplyr_mutate(df, foo), tibble(a = 1L, foo = "foobar"))

  a <- 2L
  expect_identical(duckplyr_mutate(df, a), tibble(a = 1L))

  df <- tibble(a = 1L, "a + 1" = 5L)
  a <- 2L
  expect_identical(duckplyr_mutate(df, a + 1), tibble(a = 1L, "a + 1" = 2))
})

# .by -------------------------------------------------------------------------

test_that("can group transiently using `.by`", {
  df <- tibble(g = c(1, 1, 2, 1, 2), x = c(5, 2, 1, 2, 3))

  out <- duckplyr_mutate(df, x = mean(x), .by = g)

  expect_identical(out$g, df$g)
  expect_identical(out$x, c(3, 3, 2, 3, 2))
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping retains bare data.frame class", {
  df <- data.frame(g = c(1, 1, 2, 1, 2), x = c(5, 2, 1, 2, 3))
  out <- duckplyr_mutate(df, x = mean(x), .by = g)
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping retains data frame attributes (#6100)", {
  # With data.frames or tibbles
  df <- data.frame(g = c(1, 1, 2), x = c(1, 2, 1))
  tbl <- as_tibble(df)

  attr(df, "foo") <- "bar"
  attr(tbl, "foo") <- "bar"

  out <- duckplyr_mutate(df, x = mean(x), .by = g)
  expect_identical(attr(out, "foo"), "bar")

  out <- duckplyr_mutate(tbl, x = mean(x), .by = g)
  expect_identical(attr(out, "foo"), "bar")
})

test_that("can `NULL` out the `.by` column", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:3)

  expect_identical(
    duckplyr_mutate(df, x = NULL, .by = x),
    new_tibble(list(), nrow = 3)
  )
})

test_that("catches `.by` with grouped-df", {
  df <- tibble(x = 1)
  gdf <- duckplyr_group_by(df, x)

  expect_snapshot(error = TRUE, {
    duckplyr_mutate(gdf, .by = x)
  })
})

test_that("catches `.by` with rowwise-df", {
  df <- tibble(x = 1)
  rdf <- duckplyr_rowwise(df)

  expect_snapshot(error = TRUE, {
    duckplyr_mutate(rdf, .by = x)
  })
})

# .before, .after, .keep ------------------------------------------------------

test_that(".keep = 'unused' keeps variables explicitly mentioned", {
  df <- tibble(x = 1, y = 2)
  out <- duckplyr_mutate(df, x1 = x + 1, y = y, .keep = "unused")
  expect_named(out, c("y", "x1"))
})

test_that(".keep = 'used' not affected by across() or pick()", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2, z = 3, a = "a", b = "b", c = "c")

  # This must evaluate every column in order to figure out if should
  # be included in the set or not, but that shouldn't be counted for
  # the purposes of "used" variables
  out <- duckplyr_mutate(df, across(where(is.numeric), identity), .keep = "unused")
  expect_named(out, names(df))

  out <- duckplyr_mutate(df, pick(where(is.numeric)), .keep = "unused")
  expect_named(out, names(df))
})

test_that(".keep = 'used' keeps variables used in expressions", {
  df <- tibble(a = 1, b = 2, c = 3, x = 1, y = 2)
  out <- duckplyr_mutate(df, xy = x + y, .keep = "used")
  expect_named(out, c("x", "y", "xy"))
})

test_that(".keep = 'none' only keeps grouping variables", {
  df <- tibble(x = 1, y = 2)
  gf <- duckplyr_group_by(df, x)

  expect_named(duckplyr_mutate(df, z = 1, .keep = "none"), "z")
  expect_named(duckplyr_mutate(gf, z = 1, .keep = "none"), c("x", "z"))
})

test_that(".keep = 'none' retains original ordering (#5967)", {
  df <- tibble(x = 1, y = 2)
  expect_named(df %>% duckplyr_mutate(y = 1, x = 2, .keep = "none"), c("x", "y"))

  # even when grouped
  gf <- duckplyr_group_by(df, x)
  expect_named(gf %>% duckplyr_mutate(y = 1, x = 2, .keep = "none"), c("x", "y"))
})

test_that("can use .before and .after to control column position", {
  df <- tibble(x = 1, y = 2)
  expect_named(duckplyr_mutate(df, z = 1), c("x", "y", "z"))
  expect_named(duckplyr_mutate(df, z = 1, .before = 1), c("z", "x", "y"))
  expect_named(duckplyr_mutate(df, z = 1, .after = 1), c("x", "z", "y"))

  # but doesn't affect order of existing columns
  df <- tibble(x = 1, y = 2)
  expect_named(duckplyr_mutate(df, x = 1, .after = y), c("x", "y"))
})

test_that("attributes of bare data frames are retained when `.before` and `.after` are used (#6341)", {
  # We require `[` methods to be in charge of keeping extra attributes for all
  # data frame subclasses (except for data.tables)
  df <- vctrs::data_frame(x = 1, y = 2)
  attr(df, "foo") <- "bar"

  out <- duckplyr_mutate(df, z = 3, .before = x)

  expect_identical(attr(out, "foo"), "bar")
})

test_that(".keep and .before/.after interact correctly", {
  df <- tibble(x = 1, y = 1, z = 1, a = 1, b = 2, c = 3) %>%
    duckplyr_group_by(a, b)

  expect_named(duckplyr_mutate(df, d = 1, x = 2, .keep = "none"), c("x", "a", "b", "d"))
  expect_named(duckplyr_mutate(df, d = 1, x = 2, .keep = "none", .before = "a"), c("x", "d", "a", "b"))
  expect_named(duckplyr_mutate(df, d = 1, x = 2, .keep = "none", .after = "a"), c("x", "a", "d", "b"))
})

test_that("dropping column with `NULL` then readding it retains original location", {
  df <- tibble(x = 1, y = 2, z = 3, a = 4)
  df <- duckplyr_group_by(df, z)

  expect_named(duckplyr_mutate(df, y = NULL, y = 3, .keep = "all"), c("x", "y", "z", "a"))
  expect_named(duckplyr_mutate(df, b = a, y = NULL, y = 3, .keep = "used"), c("y", "z", "a", "b"))
  expect_named(duckplyr_mutate(df, b = a, y = NULL, y = 3, .keep = "unused"), c("x", "y", "z", "b"))

  # It isn't treated as a "new" column
  expect_named(duckplyr_mutate(df, y = NULL, y = 3, .keep = "all", .before = x), c("x", "y", "z", "a"))
})

test_that("setting a new column to `NULL` works with `.before` and `.after` (#6563)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2, z = 3, a = 4)

  expect_named(duckplyr_mutate(df, b = NULL, .before = 1), names(df))
  expect_named(duckplyr_mutate(df, b = 1, b = NULL, .before = 1), names(df))
  expect_named(duckplyr_mutate(df, b = NULL, b = 1, .before = 1), c("b", "x", "y", "z", "a"))

  expect_named(duckplyr_mutate(df, b = NULL, c = 1, .after = 2), c("x", "y", "c", "z", "a"))
})

test_that(".keep= always retains grouping variables (#5582)", {
  df <- tibble(x = 1, y = 2, z = 3) %>% duckplyr_group_by(z)
  expect_equal(
    df %>% duckplyr_mutate(a = x + 1, .keep = "none"),
    tibble(z = 3, a = 2) %>% duckplyr_group_by(z)
  )
  expect_equal(
    df %>% duckplyr_mutate(a = x + 1, .keep = "all"),
    tibble(x = 1, y = 2, z = 3, a = 2) %>% duckplyr_group_by(z)
  )
  expect_equal(
    df %>% duckplyr_mutate(a = x + 1, .keep = "used"),
    tibble(x = 1, z = 3, a = 2) %>% duckplyr_group_by(z)
  )
  expect_equal(
    df %>% duckplyr_mutate(a = x + 1, .keep = "unused"),
    tibble(y = 2, z = 3, a = 2) %>% duckplyr_group_by(z)
  )
})

test_that("duckplyr_mutate() preserves the call stack on error (#5308)", {
  foobar <- function() stop("foo")

  stack <- NULL
  expect_error(
    withCallingHandlers(
      error = function(...) stack <<- sys.calls(),
      duckplyr_mutate(mtcars, foobar())
    )
  )

  expect_true(some(stack, is_call, "foobar"))
})

test_that("dplyr data mask can become obsolete", {
  lazy <- function(x) {
    list(enquo(x))
  }
  df <- tibble(
    x = 1:2
  )

  res <- df %>%
    duckplyr_rowwise() %>%
    duckplyr_mutate(y = lazy(x), .keep = "unused")
  expect_equal(names(res), c("x", "y"))
  expect_error(eval_tidy(res$y[[1]]))
})

test_that("duckplyr_mutate() deals with 0 groups (#5534)", {
  df <- data.frame(x = numeric()) %>%
    duckplyr_group_by(x)

  expect_equal(
    duckplyr_mutate(df, y = x + 1),
    data.frame(x = numeric(), y = numeric()) %>% duckplyr_group_by(x)
  )

  expect_snapshot({
    duckplyr_mutate(df, y = max(x))
  })
})

test_that("functions are not skipped in data pronoun (#5608)", {
  f <- function(i) i + 1
  df <- tibble(a = list(f), b = 1)

  two <- df %>%
    duckplyr_rowwise() %>%
    duckplyr_mutate(res = .data$a(.data$b)) %>%
    duckplyr_pull(res)

  expect_equal(two, 2)
})

test_that("duckplyr_mutate() casts data frame results to common type (#5646)", {
  df <- data.frame(x = 1:2, g = 1:2) %>% duckplyr_group_by(g)

  res <- df %>%
    duckplyr_mutate(if (g == 1) data.frame(y = 1) else data.frame(y = 1, z = 2))
  expect_equal(res$z, c(NA, 2))
})

test_that("duckplyr_mutate() supports empty list columns in rowwise data frames (#5804", {
  res <- tibble(a = list()) %>%
    duckplyr_rowwise() %>%
    duckplyr_mutate(n = lengths(a))
  expect_equal(res$n, integer())
})

test_that("duckplyr_mutate() fails on named empty arguments (#5925)", {
  expect_error(
    duckplyr_mutate(tibble(), bogus = )
  )
})

# Error messages ----------------------------------------------------------

test_that("duckplyr_mutate() give meaningful errors", {
  expect_snapshot({
    tbl <- tibble(x = 1:2, y = 1:2)

    # setting column to NULL makes it unavailable
    (expect_error(tbl %>% duckplyr_mutate(y = NULL, a = sum(y))))
    (expect_error(tbl %>%
                      duckplyr_group_by(x) %>%
                      duckplyr_mutate(y = NULL, a = sum(y))
    ))

    # incompatible column type
    (expect_error(tibble(x = 1) %>% duckplyr_mutate(y = mean)))

    # Unsupported type"
    df <- tibble(g = c(1, 1, 2, 2, 2), x = 1:5)
    (expect_error(df %>% duckplyr_mutate(out = env(a = 1))))
    (expect_error(df %>%
                      duckplyr_group_by(g) %>%
                      duckplyr_mutate(out = env(a = 1))
    ))
    (expect_error(df %>%
                      duckplyr_rowwise() %>%
                      duckplyr_mutate(out = rnorm)
    ))

    # incompatible types across groups
    (expect_error(
                    data.frame(x = rep(1:5, each = 3)) %>%
                      duckplyr_group_by(x) %>%
                      duckplyr_mutate(val = ifelse(x < 3, "foo", 2))
    ))

    # mixed nulls
    (expect_error(
                    tibble(a = 1:3, b=4:6) %>%
                      duckplyr_group_by(a) %>%
                      duckplyr_mutate(if(a==1) NULL else "foo")
    ))
    (expect_error(
                    tibble(a = 1:3, b=4:6) %>%
                      duckplyr_group_by(a) %>%
                      duckplyr_mutate(if(a==2) NULL else "foo")
    ))

    # incompatible size
    (expect_error(
                    data.frame(x = c(2, 2, 3, 3)) %>% duckplyr_mutate(int = 1:5)
    ))
    (expect_error(
                    data.frame(x = c(2, 2, 3, 3)) %>%
                      duckplyr_group_by(x) %>%
                      duckplyr_mutate(int = 1:5)
    ))
    (expect_error(
                    data.frame(x = c(2, 3, 3)) %>%
                      duckplyr_group_by(x) %>%
                      duckplyr_mutate(int = 1:5)
    ))
    (expect_error(
                    data.frame(x = c(2, 2, 3, 3)) %>%
                      duckplyr_rowwise() %>%
                      duckplyr_mutate(int = 1:5)
    ))
    (expect_error(
                    tibble(y = list(1:3, "a")) %>%
                      duckplyr_rowwise() %>%
                      duckplyr_mutate(y2 = y)
    ))
    (expect_error(
                    data.frame(x = 1:10) %>% duckplyr_mutate(y = 11:20, y = 1:2)
    ))

    # .data pronoun
    (expect_error(
                    tibble(a = 1) %>% duckplyr_mutate(c = .data$b)
    ))
    (expect_error(
                    tibble(a = 1:3) %>%
                      duckplyr_group_by(a) %>%
                      duckplyr_mutate(c = .data$b)
    ))

    # obsolete data mask
    lazy <- function(x) list(enquo(x))
    res <- tbl %>%
      duckplyr_rowwise() %>%
      duckplyr_mutate(z = lazy(x), .keep = "unused")
    (expect_error(
      eval_tidy(res$z[[1]])
    ))


    # Error that contains {
    (expect_error(
      tibble() %>% duckplyr_mutate(stop("{"))
    ))
  })
})

test_that("duckplyr_mutate() errors refer to expressions if not named", {
  expect_snapshot({
    (expect_error(duckplyr_mutate(mtcars, 1:3)))
    (expect_error(duckplyr_mutate(duckplyr_group_by(mtcars, cyl), 1:3)))
  })
})

test_that("`duckplyr_mutate()` doesn't allow data frames with missing or empty names (#6758)", {
  df1 <- new_data_frame(set_names(list(1), ""))
  df2 <- new_data_frame(set_names(list(1), NA_character_))

  expect_snapshot(error = TRUE, {
    duckplyr_mutate(df1)
  })
  expect_snapshot(error = TRUE, {
    duckplyr_mutate(df2)
  })
})
