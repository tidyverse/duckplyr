test_that("filter handles passing ...", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x = 1:4)

  f <- function(...) {
    x1 <- 4
    f1 <- function(y) y
    duckplyr_filter(df, ..., f1(x1) > x)
  }
  g <- function(...) {
    x2 <- 2
    f(x > x2, ...)
  }
  res <- g()
  expect_equal(res$x, 3L)

  df <- duckplyr_group_by(df, x)
  res <- g()
  expect_equal(res$x, 3L)
})

test_that("filter handles simple symbols", {
  df <- data.frame(x = 1:4, test = rep(c(T, F), each = 2))
  res <- duckplyr_filter(df, test)

  gdf <- duckplyr_group_by(df, x)
  res <- duckplyr_filter(gdf, test)

  h <- function(data) {
    test2 <- c(T, T, F, F)
    duckplyr_filter(data, test2)
  }
  expect_equal(h(df), df[1:2, ])

  f <- function(data, ...) {
    one <- 1
    duckplyr_filter(data, test, x > one, ...)
  }
  g <- function(data, ...) {
    four <- 4
    f(data, x < four, ...)
  }
  res <- g(df)
  expect_equal(res$x, 2L)
  expect_equal(res$test, TRUE)

  res <- g(gdf)
  expect_equal(res$x, 2L)
  expect_equal(res$test, TRUE)
})

test_that("filter handlers scalar results", {
  expect_equal(duckplyr_filter(mtcars, min(mpg) > 0), mtcars, ignore_attr = TRUE)
  expect_equal(duckplyr_filter(duckplyr_group_by(mtcars, cyl), min(mpg) > 0), duckplyr_group_by(mtcars, cyl))
})

test_that("filter propagates attributes", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  date.start <- ISOdate(2010, 01, 01, 0)
  test <- data.frame(Date = ISOdate(2010, 01, 01, 1:10))
  test2 <- test %>% duckplyr_filter(Date < ISOdate(2010, 01, 01, 5))
  expect_equal(test$Date[1:4], test2$Date)
})

test_that("filter discards NA", {
  temp <- data.frame(
    i = 1:5,
    x = c(NA, 1L, 1L, 0L, 0L)
  )
  res <- duckplyr_filter(temp, x == 1)
  expect_equal(nrow(res), 2L)
})

test_that("date class remains on filter (#273)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  x1 <- x2 <- data.frame(
    date = seq.Date(as.Date("2013-01-01"), by = "1 days", length.out = 2),
    var = c(5, 8)
  )
  x1.filter <- x1 %>% duckplyr_filter(as.Date(date) > as.Date("2013-01-01"))
  x2$date <- x2$date + 1
  x2.filter <- x2 %>% duckplyr_filter(as.Date(date) > as.Date("2013-01-01"))

  expect_equal(class(x1.filter$date), "Date")
  expect_equal(class(x2.filter$date), "Date")
})

test_that("filter handles $ correctly (#278)", {
  d1 <- tibble(
    num1 = as.character(sample(1:10, 1000, T)),
    var1 = runif(1000),
  )
  d2 <- data.frame(num1 = as.character(1:3), stringsAsFactors = FALSE)

  res1 <- d1 %>% duckplyr_filter(num1 %in% c("1", "2", "3"))
  res2 <- d1 %>% duckplyr_filter(num1 %in% d2$num1)
  expect_equal(res1, res2)
})

test_that("duckplyr_filter() returns the input data if no parameters are given", {
  expect_identical(duckplyr_filter(mtcars), mtcars)
  expect_identical(duckplyr_filter(mtcars, !!!list()), mtcars)
})

test_that("$ does not end call traversing. #502", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # Suppose some analysis options are set much earlier in the script
  analysis_opts <- list(min_outcome = 0.25)

  # Generate some dummy data
  d <- expand.grid(Subject = 1:3, TrialNo = 1:2, Time = 1:3) %>%
    as_tibble() %>%
    duckplyr_arrange(Subject, TrialNo, Time) %>%
    duckplyr_mutate(Outcome = (1:18 %% c(5, 7, 11)) / 10)

  # Do some aggregation
  trial_outcomes <- d %>%
    duckplyr_group_by(Subject, TrialNo) %>%
    duckplyr_summarise(MeanOutcome = mean(Outcome), .groups = "drop")

  left <- duckplyr_filter(trial_outcomes, MeanOutcome < analysis_opts$min_outcome)
  right <- duckplyr_filter(trial_outcomes, analysis_opts$min_outcome > MeanOutcome)

  expect_equal(left, right)
})

test_that("filter handles POSIXlt", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  datesDF <- read.csv(stringsAsFactors = FALSE, text = "
X
2014-03-13 16:08:19
2014-03-13 16:16:23
2014-03-13 16:28:28
2014-03-13 16:28:54
")

  datesDF$X <- as.POSIXlt(datesDF$X)
  expect_equal(
    nrow(duckplyr_filter(datesDF, X > as.POSIXlt("2014-03-13"))),
    4
  )
})

test_that("filter handles complex vectors (#436)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  d <- data.frame(x = 1:10, y = 1:10 + 2i)
  expect_equal(duckplyr_filter(d, x < 4)$y, 1:3 + 2i)
  expect_equal(duckplyr_filter(d, Re(y) < 4)$y, 1:3 + 2i)
})

test_that("%in% works as expected (#126)", {
  df <- tibble(a = c("a", "b", "ab"), g = c(1, 1, 2))

  res <- df %>% duckplyr_filter(a %in% letters)
  expect_equal(nrow(res), 2L)

  res <- df %>% duckplyr_group_by(g) %>% duckplyr_filter(a %in% letters)
  expect_equal(nrow(res), 2L)
})

test_that("row_number does not segfault with example from #781", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  z <- data.frame(a = c(1, 2, 3))
  b <- "a"
  res <- z %>% duckplyr_filter(row_number(b) == 2)
  expect_equal(nrow(res), 0L)
})

test_that("row_number works on 0 length columns (#3454)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_identical(
    duckplyr_mutate(tibble(), a = row_number()),
    tibble(a = integer())
  )
})

test_that("filter does not alter expression (#971)", {
  my_filter <- ~ am == 1
  expect_equal(my_filter[[2]][[2]], as.name("am"))
})

test_that("hybrid evaluation handles $ correctly (#1134)", {
  df <- tibble(x = 1:10, g = rep(1:5, 2))
  res <- df %>% duckplyr_group_by(g) %>% duckplyr_filter(x > min(df$x))
  expect_equal(nrow(res), 9L)
})

test_that("filter correctly handles empty data frames (#782)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  res <- tibble() %>% duckplyr_filter(F)
  expect_equal(nrow(res), 0L)
  expect_equal(length(names(res)), 0L)
})

test_that("duckplyr_filter(.,TRUE,TRUE) works (#1210)", {
  df <- data.frame(x = 1:5)
  res <- duckplyr_filter(df, TRUE, TRUE)
  expect_equal(res, df)
})

test_that("filter, slice and arrange preserves attributes (#1064)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- structure(
    data.frame(x = 1:10, g1 = rep(1:2, each = 5), g2 = rep(1:5, 2)),
    meta = "this is important"
  )
  res <- duckplyr_filter(df, x < 5) %>% attr("meta")
  expect_equal(res, "this is important")

  res <- duckplyr_filter(df, x < 5, x > 4) %>% attr("meta")
  expect_equal(res, "this is important")

  res <- df %>% duckplyr_slice(1:50) %>% attr("meta")
  expect_equal(res, "this is important")

  res <- df %>% duckplyr_arrange(x) %>% attr("meta")
  expect_equal(res, "this is important")
})

test_that("filter works with rowwise data (#1099)", {
  df <- tibble(First = c("string1", "string2"), Second = c("Sentence with string1", "something"))
  res <- df %>% duckplyr_rowwise() %>% duckplyr_filter(grepl(First, Second, fixed = TRUE))
  expect_equal(nrow(res), 1L)
  expect_equal(df[1, ], duckplyr_ungroup(res))
})

test_that("grouped filter handles indices (#880)", {
  res <- iris %>% duckplyr_group_by(Species) %>% duckplyr_filter(Sepal.Length > 5)
  res2 <- duckplyr_mutate(res, Petal = Petal.Width * Petal.Length)
  expect_equal(nrow(res), nrow(res2))
  expect_equal(group_rows(res), group_rows(res2))
  expect_equal(duckplyr_group_keys(res), duckplyr_group_keys(res2))
})

test_that("duckplyr_filter(FALSE) handles indices", {
  out <- mtcars %>%
    duckplyr_group_by(cyl) %>%
    duckplyr_filter(FALSE, .preserve = TRUE) %>%
    group_rows()
  expect_identical(out, list_of(integer(), integer(), integer(), .ptype = integer()))

  out <- mtcars %>%
    duckplyr_group_by(cyl) %>%
    duckplyr_filter(FALSE, .preserve = FALSE) %>%
    group_rows()
  expect_identical(out, list_of(.ptype = integer()))
})

test_that("filter handles S4 objects (#1366)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  env <- environment()
  Numbers <- suppressWarnings(setClass(
    "Numbers",
    slots = c(foo = "numeric"), contains = "integer", where = env
  ))
  setMethod("[", "Numbers", function(x, i, ...){
    Numbers(unclass(x)[i, ...], foo = x@foo)
  })
  on.exit(removeClass("Numbers", where = env))

  df <- data.frame(x = Numbers(1:10, foo = 10))
  res <- duckplyr_filter(df, x > 3)
  expect_s4_class(res$x, "Numbers")
  expect_equal(res$x@foo, 10)
})

test_that("hybrid lag and default value for string columns work (#1403)", {
  res <- mtcars %>%
    duckplyr_mutate(xx = LETTERS[gear]) %>%
    duckplyr_filter(xx == lag(xx, default = "foo"))
  xx <- LETTERS[mtcars$gear]
  ok <- xx == lag(xx, default = "foo")
  expect_equal(xx[ok], res$xx)

  res <- mtcars %>%
    duckplyr_mutate(xx = LETTERS[gear]) %>%
    duckplyr_filter(xx == lead(xx, default = "foo"))
  xx <- LETTERS[mtcars$gear]
  ok <- xx == lead(xx, default = "foo")
  expect_equal(xx[ok], res$xx)
})

# .data and .env tests now in test-hybrid-traverse.R

test_that("filter handles raw vectors (#1803)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(a = 1:3, b = as.raw(1:3))
  expect_identical(duckplyr_filter(df, a == 1), tibble(a = 1L, b = as.raw(1)))
  expect_identical(duckplyr_filter(df, b == 1), tibble(a = 1L, b = as.raw(1)))
})

test_that("`vars` attribute is not added if empty (#2772)", {
  expect_identical(tibble(x = 1:2) %>% duckplyr_filter(x == 1), tibble(x = 1L))
})

test_that("filter handles list columns", {
  res <- tibble(a=1:2, x = list(1:10, 1:5)) %>%
    duckplyr_filter(a == 1) %>%
    duckplyr_pull(x)
  expect_equal(res, list(1:10))

  res <- tibble(a=1:2, x = list(1:10, 1:5)) %>%
    duckplyr_group_by(a) %>%
    duckplyr_filter(a == 1) %>%
    duckplyr_pull(x)
  expect_equal(res, list(1:10))
})

test_that("hybrid function row_number does not trigger warning in filter (#3750)", {
  out <- tryCatch({
    mtcars %>% duckplyr_filter(row_number() > 1, row_number() < 5); TRUE
  }, warning = function(w) FALSE )
  expect_true(out)
})

test_that("duckplyr_filter() preserve order across groups (#3989)", {
  df <- tibble(g = c(1, 2, 1, 2, 1), time = 5:1, x = 5:1)
  res1 <- df %>%
    duckplyr_group_by(g) %>%
    duckplyr_filter(x <= 4) %>%
    duckplyr_arrange(time)

  res2 <- df %>%
    duckplyr_group_by(g) %>%
    duckplyr_arrange(time) %>%
    duckplyr_filter(x <= 4)

  res3 <- df %>%
    duckplyr_filter(x <= 4) %>%
    duckplyr_arrange(time) %>%
    duckplyr_group_by(g)

  expect_equal(res1, res2)
  expect_equal(res1, res3)
  expect_false(is.unsorted(res1$time))
  expect_false(is.unsorted(res2$time))
  expect_false(is.unsorted(res3$time))
})

test_that("duckplyr_filter() with two conditions does not freeze (#4049)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_identical(
    iris %>% duckplyr_filter(Sepal.Length > 7, Petal.Length < 6),
    iris %>% duckplyr_filter(Sepal.Length > 7 & Petal.Length < 6)
  )
})

test_that("duckplyr_filter() handles matrix and data frame columns (#3630)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(
    x = 1:2,
    y = matrix(1:4, ncol = 2),
    z = data.frame(A = 1:2, B = 3:4)
  )
  expect_equal(duckplyr_filter(df, x == 1), df[1, ])
  expect_equal(duckplyr_filter(df, y[,1] == 1), df[1, ])
  expect_equal(duckplyr_filter(df, z$A == 1), df[1, ])

  gdf <- duckplyr_group_by(df, x)
  expect_equal(duckplyr_filter(gdf, x == 1), gdf[1, ])
  expect_equal(duckplyr_filter(gdf, y[,1] == 1), gdf[1, ])
  expect_equal(duckplyr_filter(gdf, z$A == 1), gdf[1, ])

  gdf <- duckplyr_group_by(df, y)
  expect_equal(duckplyr_filter(gdf, x == 1), gdf[1, ])
  expect_equal(duckplyr_filter(gdf, y[,1] == 1), gdf[1, ])
  expect_equal(duckplyr_filter(gdf, z$A == 1), gdf[1, ])

  gdf <- duckplyr_group_by(df, z)
  expect_equal(duckplyr_filter(gdf, x == 1), gdf[1, ])
  expect_equal(duckplyr_filter(gdf, y[,1] == 1), gdf[1, ])
  expect_equal(duckplyr_filter(gdf, z$A == 1), gdf[1, ])
})

test_that("duckplyr_filter() handles named logical (#4638)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  tbl <- tibble(a = c(a = TRUE))
  expect_equal(duckplyr_filter(tbl, a), tbl)
})

test_that("duckplyr_filter() allows named constants that resolve to logical vectors (#4612)", {
  filters <- mtcars %>%
    duckplyr_transmute(
      cyl %in% 6:8,
      hp / drat > 50
    )

  expect_identical(
    mtcars %>% duckplyr_filter(!!!filters),
    mtcars %>% duckplyr_filter(!!!unname(filters))
  )
})

test_that("duckplyr_filter() allows 1 dimension arrays", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = array(c(TRUE, FALSE, TRUE)))
  expect_identical(duckplyr_filter(df, x), df[c(1, 3),])
})

test_that("duckplyr_filter() allows matrices with 1 column with a deprecation warning (#6091)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:2)
  expect_snapshot({
    out <- duckplyr_filter(df, matrix(c(TRUE, FALSE), nrow = 2))
  })
  expect_identical(out, tibble(x = 1L))

  # Only warns once when grouped
  df <- tibble(x = c(1, 1, 2, 2))
  gdf <- duckplyr_group_by(df, x)
  expect_snapshot({
    out <- duckplyr_filter(gdf, matrix(c(TRUE, FALSE), nrow = 2))
  })
  expect_identical(out, duckplyr_group_by(tibble(x = c(1, 2)), x))
})

test_that("duckplyr_filter() disallows matrices with >1 column", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:3)

  expect_snapshot({
    (expect_error(duckplyr_filter(df, matrix(TRUE, nrow = 3, ncol = 2))))
  })
})

test_that("duckplyr_filter() disallows arrays with >2 dimensions", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:3)

  expect_snapshot({
    (expect_error(duckplyr_filter(df, array(TRUE, dim = c(3, 1, 1)))))
  })
})

test_that("duckplyr_filter() gives useful error messages", {
  expect_snapshot({
    # wrong type
    (expect_error(
      iris %>%
        duckplyr_group_by(Species) %>%
        duckplyr_filter(1:n())
    ))
    (expect_error(
      iris %>%
        duckplyr_filter(1:n())
    ))

    # matrix with > 1 columns
    (expect_error(
      duckplyr_filter(data.frame(x = 1:2), matrix(c(TRUE, FALSE, TRUE, FALSE), nrow = 2))
    ))

    # wrong size
    (expect_error(
      iris %>%
        duckplyr_group_by(Species) %>%
        duckplyr_filter(c(TRUE, FALSE))
    ))
    (expect_error(
                    iris %>%
                      duckplyr_rowwise(Species) %>%
                      duckplyr_filter(c(TRUE, FALSE))
    ))
    (expect_error(
                    iris %>%
                      duckplyr_filter(c(TRUE, FALSE))
    ))

    # wrong size in column
    (expect_error(
                    iris %>%
                      duckplyr_group_by(Species) %>%
                      duckplyr_filter(data.frame(c(TRUE, FALSE)))
    ))
    (expect_error(
                    iris %>%
                      duckplyr_rowwise() %>%
                      duckplyr_filter(data.frame(c(TRUE, FALSE)))
    ))
    (expect_error(
                    iris %>%
                      duckplyr_filter(data.frame(c(TRUE, FALSE)))
    ))
    (expect_error(
                    tibble(x = 1) %>%
                      duckplyr_filter(c(TRUE, TRUE))
    ))

    # wrong type in column
    (expect_error(
                    iris %>%
                      duckplyr_group_by(Species) %>%
                      duckplyr_filter(data.frame(Sepal.Length > 3, 1:n()))
    ))
    (expect_error(
                    iris %>%
                      duckplyr_filter(data.frame(Sepal.Length > 3, 1:n()))
    ))

    # evaluation error
    (expect_error(
      mtcars %>% duckplyr_filter(`_x`)
    ))
    (expect_error(
                    mtcars %>%
                      duckplyr_group_by(cyl) %>%
                      duckplyr_filter(`_x`)
    ))

    # named inputs
    (expect_error(
      duckplyr_filter(mtcars, x = 1)
    ))
    (expect_error(
      duckplyr_filter(mtcars, y > 2, z = 3)
    ))
    (expect_error(
      duckplyr_filter(mtcars, TRUE, x = 1)
    ))

    # ts
    (expect_error(
      duckplyr_filter(ts(1:10))
    ))

    # Error that contains {
    (expect_error(
      tibble() %>% duckplyr_filter(stop("{"))
    ))

    # across() in duckplyr_filter() does not warn yet
    data.frame(x = 1, y = 1) %>%
      duckplyr_filter(across(everything(), ~ .x > 0))

    data.frame(x = 1, y = 1) %>%
      duckplyr_filter(data.frame(x > 0, y > 0))
  })
})

test_that("filter preserves grouping", {
  gf <- duckplyr_group_by(tibble(g = c(1, 1, 1, 2, 2), x = 1:5), g)

  i <- count_regroups(out <- duckplyr_filter(gf, x %in% c(3,4)))
  expect_equal(i, 0L)
  expect_equal(duckplyr_group_vars(gf), "g")
  expect_equal(group_rows(out), list_of(1L, 2L))

  i <- count_regroups(out <- duckplyr_filter(gf, x < 3))
  expect_equal(i, 0L)
  expect_equal(duckplyr_group_vars(gf), "g")
  expect_equal(group_rows(out), list_of(c(1L, 2L)))
})

test_that("duckplyr_filter() with empty dots still calls dplyr_row_slice()", {
  tbl <- new_tibble(list(x = 1), nrow = 1L)
  foo <- structure(tbl, class = c("foo_df", class(tbl)))

  local_methods(
    # `foo_df` always loses class when row slicing
    dplyr_row_slice.foo_df = function(data, i, ...) {
      out <- NextMethod()
      new_tibble(out, nrow = nrow(out))
    }
  )

  expect_s3_class(duckplyr_filter(foo), class(tbl), exact = TRUE)
  expect_s3_class(duckplyr_filter(foo, x == 1), class(tbl), exact = TRUE)
})

test_that("can duckplyr_filter() with unruly class", {
  local_methods(
    `[.dplyr_foobar` = function(x, i, ...) new_dispatched_quux(vec_slice(x, i)),
    dplyr_row_slice.dplyr_foobar = function(x, i, ...) x[i, ]
  )

  df <- foobar(data.frame(x = 1:3))
  expect_identical(
    duckplyr_filter(df, x <= 2),
    quux(data.frame(x = 1:2, dispatched = TRUE))
  )
})

test_that("duckplyr_filter() preserves the call stack on error (#5308)", {
  foobar <- function() stop("foo")

  stack <- NULL
  expect_error(
    withCallingHandlers(
      error = function(...) stack <<- sys.calls(),
      duckplyr_filter(mtcars, foobar())
    )
  )

  expect_true(some(stack, is_call, "foobar"))
})

test_that("if_any() and if_all() work", {
  df <- tibble(x1 = 1:10, x2 = c(1:5, 10:6))
  expect_equal(
    duckplyr_filter(df, if_all(starts_with("x"), ~ . > 6)),
    duckplyr_filter(df, x1 > 6 & x2 > 6)
  )

  expect_equal(
    duckplyr_filter(df, if_any(starts_with("x"), ~ . > 6)),
    duckplyr_filter(df, x1 > 6 | x2 > 6)
  )
})

test_that("filter keeps zero length groups", {
  df <- tibble(
    e = 1,
    f = factor(c(1, 1, 2, 2), levels = 1:3),
    g = c(1, 1, 2, 2),
    x = c(1, 2, 1, 4)
  )
  df <- duckplyr_group_by(df, e, f, g, .drop = FALSE)

  expect_equal(duckplyr_group_size(duckplyr_filter(df, f == 1)), c(2, 0, 0) )
})

test_that("filtering retains labels for zero length groups", {
  df <- tibble(
    e = 1,
    f = factor(c(1, 1, 2, 2), levels = 1:3),
    g = c(1, 1, 2, 2),
    x = c(1, 2, 1, 4)
  )
  df <- duckplyr_group_by(df, e, f, g, .drop = FALSE)

  expect_equal(
    duckplyr_ungroup(duckplyr_count(duckplyr_filter(df, f == 1))),
    tibble(
      e = 1,
      f = factor(1:3),
      g = c(1, 2, NA),
      n = c(2L, 0L, 0L)
    )
  )
})

test_that("`duckplyr_filter()` doesn't allow data frames with missing or empty names (#6758)", {
  df1 <- new_data_frame(set_names(list(1), ""))
  df2 <- new_data_frame(set_names(list(1), NA_character_))

  expect_snapshot(error = TRUE, {
    duckplyr_filter(df1)
  })
  expect_snapshot(error = TRUE, {
    duckplyr_filter(df2)
  })
})

# .by -------------------------------------------------------------------------

test_that("can group transiently using `.by`", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(1, 1, 2, 1, 2), x = c(5, 10, 1, 2, 3))

  out <- duckplyr_filter(df, x > mean(x), .by = g)

  expect_identical(out$g, c(1, 2))
  expect_identical(out$x, c(10, 3))
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping retains bare data.frame class", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(1, 1, 2, 1, 2), x = c(5, 10, 1, 2, 3))
  out <- duckplyr_filter(df, x > mean(x), .by = g)
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping retains data frame attributes", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # With data.frames or tibbles
  df <- data.frame(g = c(1, 1, 2), x = c(1, 2, 1))
  tbl <- as_tibble(df)

  attr(df, "foo") <- "bar"
  attr(tbl, "foo") <- "bar"

  out <- duckplyr_filter(df, x > mean(x), .by = g)
  expect_identical(attr(out, "foo"), "bar")

  out <- duckplyr_filter(tbl, x > mean(x), .by = g)
  expect_identical(attr(out, "foo"), "bar")
})

test_that("can't use `.by` with `.preserve`", {
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_filter(df, .by = x, .preserve = TRUE)
  })
})

test_that("catches `.by` with grouped-df", {
  df <- tibble(x = 1)
  gdf <- duckplyr_group_by(df, x)

  expect_snapshot(error = TRUE, {
    duckplyr_filter(gdf, .by = x)
  })
})

test_that("catches `.by` with rowwise-df", {
  df <- tibble(x = 1)
  rdf <- duckplyr_rowwise(df)

  expect_snapshot(error = TRUE, {
    duckplyr_filter(rdf, .by = x)
  })
})

test_that("catches `by` typo (#6647)", {
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_filter(df, by = x)
  })
})
