test_that("can use freshly create variables (#138)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:10)
  out <- duckplyr_summarise(df, y = mean(x), z = y + 1)
  expect_equal(out$y, 5.5)
  expect_equal(out$z, 6.5)
})

test_that("inputs are recycled (deprecated in 1.1.0)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  local_options(lifecycle_verbosity = "quiet")

  expect_equal(
    tibble() %>% duckplyr_summarise(x = 1, y = 1:3, z = 1),
    tibble(x = 1, y = 1:3, z = 1)
  )

  gf <- duckplyr_group_by(tibble(a = 1:2), a)
  expect_equal(
    gf %>% duckplyr_summarise(x = 1, y = 1:3, z = 1),
    tibble(a = rep(1:2, each = 3), x = 1, y = c(1:3, 1:3), z = 1) %>% duckplyr_group_by(a)
  )
  expect_equal(
    gf %>% duckplyr_summarise(x = seq_len(a), y = 1),
    tibble(a = c(1L, 2L, 2L), x = c(1L, 1L, 2L), y = 1) %>% duckplyr_group_by(a)
  )
})

test_that("works with empty data frames", {
  skip("TODO duckdb")
  # 0 rows
  df <- tibble(x = integer())
  expect_equal(duckplyr_summarise(df), tibble(.rows = 1))
  expect_equal(duckplyr_summarise(df, n = n(), sum = sum(x)), tibble(n = 0, sum = 0))

  # 0 cols
  df <- tibble(.rows = 10)
  expect_equal(duckplyr_summarise(df), tibble(.rows = 1))
  expect_equal(duckplyr_summarise(df, n = n()), tibble(n = 10))
})

test_that("works with grouped empty data frames", {
  df <- tibble(x = integer())

  expect_equal(
    df %>% duckplyr_group_by(x) %>% duckplyr_summarise(y = 1L),
    tibble(x = integer(), y = integer())
  )
  expect_equal(
    df %>% duckplyr_rowwise(x) %>% duckplyr_summarise(y = 1L),
    duckplyr_group_by(tibble(x = integer(), y = integer()), x)
  )
})

test_that("no expressions yields grouping data", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:2, y = 1:2)
  gf <- duckplyr_group_by(df, x)

  expect_equal(duckplyr_summarise(df), tibble(.rows = 1))
  expect_equal(duckplyr_summarise(gf), tibble(x = 1:2))

  expect_equal(duckplyr_summarise(df, !!!list()), tibble(.rows = 1))
  expect_equal(duckplyr_summarise(gf, !!!list()), tibble(x = 1:2))
})

test_that("preserved class, but not attributes", {
  df <- structure(
    data.frame(x = 1:10, g1 = rep(1:2, each = 5), g2 = rep(1:5, 2)),
    meta = "this is important"
  )

  out <- df %>% duckplyr_summarise(n = n())
  expect_s3_class(out, "data.frame", exact = TRUE)
  expect_null(attr(out, "res"))

  out <- df %>% duckplyr_group_by(g1) %>% duckplyr_summarise(n = n())
  # expect_s3_class(out, "data.frame", exact = TRUE)
  expect_null(attr(out, "res"))
})

test_that("works with unquoted values", {
  df <- tibble(g = c(1, 1, 2, 2, 2), x = 1:5)
  expect_equal(duckplyr_summarise(df, out = !!1), tibble(out = 1))
  expect_equal(duckplyr_summarise(df, out = !!quo(1)), tibble(out = 1))
})

test_that("formulas are evaluated in the right environment (#3019)", {
  out <- mtcars %>% duckplyr_summarise(fn = list(rlang::as_function(~ list(~foo, environment()))))
  out <- out$fn[[1]]()
  expect_identical(environment(out[[1]]), out[[2]])
})

test_that("unnamed data frame results with 0 columns are ignored (#5084)", {
  df1 <- tibble(x = 1:2)
  expect_equal(df1 %>% duckplyr_group_by(x) %>% duckplyr_summarise(data.frame()), df1)
  expect_equal(df1 %>% duckplyr_group_by(x) %>% duckplyr_summarise(data.frame(), y = 65), duckplyr_mutate(df1, y = 65))
  expect_equal(df1 %>% duckplyr_group_by(x) %>% duckplyr_summarise(y = 65, data.frame()), duckplyr_mutate(df1, y = 65))

  df2 <- tibble(x = 1:2, y = 3:4)
  expect_equal(df2 %>% duckplyr_group_by(x) %>% duckplyr_summarise(data.frame()), df1)
  expect_equal(df2 %>% duckplyr_group_by(x) %>% duckplyr_summarise(data.frame(), z = 98), duckplyr_mutate(df1, z = 98))
  expect_equal(df2 %>% duckplyr_group_by(x) %>% duckplyr_summarise(z = 98, data.frame()), duckplyr_mutate(df1, z = 98))

  # This includes unnamed data frames that have 0 columns but >0 rows.
  # Noted when working on (#6509).
  empty3 <- new_tibble(list(), nrow = 3L)
  expect_equal(df1 %>% duckplyr_summarise(empty3), new_tibble(list(), nrow = 1L))
  expect_equal(df1 %>% duckplyr_summarise(empty3, y = mean(x)), df1 %>% duckplyr_summarise(y = mean(x)))
  expect_equal(df1 %>% duckplyr_group_by(x) %>% duckplyr_summarise(empty3), df1)
  expect_equal(df1 %>% duckplyr_group_by(x) %>% duckplyr_summarise(empty3, y = x + 1), duckplyr_mutate(df1, y = x + 1))
})

test_that("named data frame results with 0 columns participate in recycling (#6509)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  local_options(lifecycle_verbosity = "quiet")

  df <- tibble(x = 1:3)
  gdf <- duckplyr_group_by(df, x)

  empty <- tibble()
  expect_identical(duckplyr_summarise(df, empty = empty), tibble(empty = empty))
  expect_identical(duckplyr_summarise(df, x = sum(x), empty = empty), tibble(x = integer(), empty = empty))
  expect_identical(duckplyr_summarise(df, empty = empty, x = sum(x)), tibble(empty = empty, x = integer()))

  empty3 <- new_tibble(list(), nrow = 3L)
  expect_identical(duckplyr_summarise(df, empty = empty3), tibble(empty = empty3))
  expect_identical(duckplyr_summarise(df, x = sum(x), empty = empty3), tibble(x = c(6L, 6L, 6L), empty = empty3))
  expect_identical(duckplyr_summarise(df, empty = empty3, x = sum(x)), tibble(empty = empty3, x = c(6L, 6L, 6L)))

  expect_identical(
    duckplyr_summarise(gdf, empty = empty, .groups = "drop"),
    tibble(x = integer(), empty = empty)
  )
  expect_identical(
    duckplyr_summarise(gdf, y = x + 1L, empty = empty, .groups = "drop"),
    tibble(x = integer(), y = integer(), empty = empty)
  )
  expect_identical(
    duckplyr_summarise(gdf, empty = empty3, .groups = "drop"),
    tibble(x = vec_rep_each(1:3, 3), empty = vec_rep(empty3, 3))
  )
  expect_identical(
    duckplyr_summarise(gdf, y = x + 1L, empty = empty3, .groups = "drop"),
    tibble(x = vec_rep_each(1:3, 3), y = vec_rep_each(2:4, 3), empty = vec_rep(empty3, 3))
  )
})

test_that("can't overwrite column active bindings (#6666)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  skip_if(getRversion() < "3.6.3", message = "Active binding error changed")

  df <- tibble(g = c(1, 1, 2, 2), x = 1:4)
  gdf <- duckplyr_group_by(df, g)

  # The error seen here comes from trying to `<-` to an active binding when
  # the active binding function has 0 arguments.
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df, y = {
      x <<- x + 2L
      mean(x)
    })
  })
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df, .by = g, y = {
      x <<- x + 2L
      mean(x)
    })
  })
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(gdf, y = {
      x <<- x + 2L
      mean(x)
    })
  })
})

test_that("assigning with `<-` doesn't affect the mask (#6666)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(1, 1, 2, 2), x = 1:4)
  gdf <- duckplyr_group_by(df, g)

  out <- duckplyr_summarise(df, .by = g, y = {
    x <- x + 4L
    mean(x)
  })
  expect_identical(out$y, c(5.5, 7.5))

  out <- duckplyr_summarise(gdf, y = {
    x <- x + 4L
    mean(x)
  })
  expect_identical(out$y, c(5.5, 7.5))
})

test_that("duckplyr_summarise() correctly auto-names expressions (#6741)", {
  df <- tibble(a = 1:3)
  expect_identical(duckplyr_summarise(df, min(-a)), tibble("min(-a)" = -3L))
})

# grouping ----------------------------------------------------------------

test_that("peels off a single layer of grouping", {
  df <- tibble(x = rep(1:4, each = 4), y = rep(1:2, each = 8), z = runif(16))
  gf <- df %>% duckplyr_group_by(x, y)
  expect_equal(duckplyr_group_vars(duckplyr_summarise(gf)), "x")
  expect_equal(duckplyr_group_vars(duckplyr_summarise(duckplyr_summarise(gf))), character())
})

test_that("correctly reconstructs groups", {
  d <- tibble(x = 1:4, g1 = rep(1:2, 2), g2 = 1:4) %>%
    duckplyr_group_by(g1, g2) %>%
    duckplyr_summarise(x = x + 1)
  expect_equal(group_rows(d), list_of(1:2, 3:4))
})

test_that("can modify grouping variables", {
  df <- tibble(a = c(1, 2, 1, 2), b = c(1, 1, 2, 2))
  gf <- duckplyr_group_by(df, a, b)

  i <- count_regroups(out <- duckplyr_summarise(gf, a = a + 1))
  expect_equal(i, 1)
  expect_equal(out$a, c(2, 2, 3, 3))
})

test_that("summarise returns a row for zero length groups", {
  df <- tibble(
    e = 1,
    f = factor(c(1, 1, 2, 2), levels = 1:3),
    g = c(1, 1, 2, 2),
    x = c(1, 2, 1, 4)
  )
  df <- duckplyr_group_by(df, e, f, g, .drop = FALSE)

  expect_equal( nrow(duckplyr_summarise(df, z = n())), 3L)
})

test_that("summarise respects zero-length groups (#341)", {
  df <- tibble(x = factor(rep(1:3, each = 10), levels = 1:4))

  out <- df %>%
    duckplyr_group_by(x, .drop = FALSE) %>%
    duckplyr_summarise(n = n())

  expect_equal(out$n, c(10L, 10L, 10L, 0L))
})

# vector types ----------------------------------------------------------

test_that("summarise allows names (#2675)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  data <- tibble(a = 1:3) %>% duckplyr_summarise(b = c("1" = a[[1]]))
  expect_equal(names(data$b), "1")

  data <- tibble(a = 1:3) %>% duckplyr_rowwise() %>% duckplyr_summarise(b = setNames(nm = a))
  expect_equal(names(data$b), c("1", "2", "3"))

  data <- tibble(a = c(1, 1, 2)) %>% duckplyr_group_by(a) %>% duckplyr_summarise(b = setNames(nm = a[[1]]))
  expect_equal(names(data$b), c("1", "2"))

  res <- data.frame(x = c(1:3), y = letters[1:3]) %>%
    duckplyr_group_by(y) %>%
    duckplyr_summarise(
      a = length(x),
      b = quantile(x, 0.5)
    )
  expect_equal(res$b, c("50%" = 1, "50%" = 2, "50%" = 3))
})

test_that("summarise handles list output columns (#832)", {
  df <- tibble(x = 1:10, g = rep(1:2, each = 5))
  res <- df %>% duckplyr_group_by(g) %>% duckplyr_summarise(y = list(x))
  expect_equal(res$y[[1]], 1:5)

  # preserving names
  d <- tibble(x = rep(1:3, 1:3), y = 1:6, names = letters[1:6])
  res <- d %>% duckplyr_group_by(x) %>% duckplyr_summarise(y = list(setNames(y, names)))
  expect_equal(names(res$y[[1]]), letters[[1]])
})

test_that("summarise coerces types across groups", {
  gf <- duckplyr_group_by(tibble(g = 1:2), g)

  out <- duckplyr_summarise(gf, x = if (g == 1) NA else "x")
  expect_type(out$x, "character")

  out <- duckplyr_summarise(gf, x = if (g == 1L) NA else 2.5)
  expect_type(out$x, "double")
})

test_that("unnamed tibbles are unpacked (#2326)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 2)
  out <- duckplyr_summarise(df, tibble(y = x * 2, z = 3))
  expect_equal(out$y, 4)
  expect_equal(out$z, 3)
})

test_that("named tibbles are packed (#2326)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 2)
  out <- duckplyr_summarise(df, df = tibble(y = x * 2, z = 3))
  expect_equal(out$df, tibble(y = 4, z = 3))
})

test_that("duckplyr_summarise(.groups=) in global environment", {
  skip("TODO duckdb")
  expect_message(eval_bare(
    expr(data.frame(x = 1, y = 2) %>% duckplyr_group_by(x, y) %>% duckplyr_summarise()),
    env(global_env())
  ))
  expect_message(eval_bare(
    expr(data.frame(x = 1, y = 2) %>% duckplyr_rowwise(x, y) %>% duckplyr_summarise()),
    env(global_env())
  ))
})

test_that("duckplyr_summarise(.groups=)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x = 1, y = 2)
  expect_equal(df %>% duckplyr_summarise(z = 3, .groups= "rowwise"), duckplyr_rowwise(data.frame(z = 3)))

  gf <- df %>% duckplyr_group_by(x, y)
  expect_equal(gf %>% duckplyr_summarise() %>% duckplyr_group_vars(), "x")
  expect_equal(gf %>% duckplyr_summarise(.groups = "drop_last") %>% duckplyr_group_vars(), "x")
  expect_equal(gf %>% duckplyr_summarise(.groups = "drop") %>% duckplyr_group_vars(), character())
  expect_equal(gf %>% duckplyr_summarise(.groups = "keep") %>% duckplyr_group_vars(), c("x", "y"))

  rf <- df %>% duckplyr_rowwise(x, y)
  expect_equal(rf %>% duckplyr_summarise(.groups = "drop") %>% duckplyr_group_vars(), character())
  expect_equal(rf %>% duckplyr_summarise(.groups = "keep") %>% duckplyr_group_vars(), c("x", "y"))
})

test_that("duckplyr_summarise() casts data frame results to common type (#5646)", {
  df <- data.frame(x = 1:2, g = 1:2) %>% duckplyr_group_by(g)

  res <- df %>%
    duckplyr_summarise(if (g == 1) data.frame(y = 1) else data.frame(y = 1, z = 2), .groups = "drop")
  expect_equal(res$z, c(NA, 2))
})

test_that("duckplyr_summarise() silently skips when all results are NULL (#5708)", {
  df <- data.frame(x = 1:2, g = 1:2) %>% duckplyr_group_by(g)

  expect_equal(duckplyr_summarise(df, x = NULL), duckplyr_summarise(df))
  expect_error(duckplyr_summarise(df, x = if(g == 1) 42))
})

# .by ----------------------------------------------------------------------

test_that("can group transiently using `.by`", {
  df <- tibble(g = c(1, 1, 2, 1, 2), x = c(5, 2, 1, 2, 3))

  out <- duckplyr_summarise(df, x = mean(x), .by = g)

  expect_identical(out$g, c(1, 2))
  expect_identical(out$x, c(3, 2))
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping retains bare data.frame class", {
  df <- data.frame(g = c(1, 1, 2, 1, 2), x = c(5, 2, 1, 2, 3))
  out <- duckplyr_summarise(df, x = mean(x), .by = g)
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping drops data frame attributes", {
  # Because `duckplyr_summarise()` theoretically creates a "new" data frame

  # With data.frames or tibbles
  df <- data.frame(g = c(1, 1, 2), x = c(1, 2, 1))
  tbl <- as_tibble(df)

  attr(df, "foo") <- "bar"
  attr(tbl, "foo") <- "bar"

  out <- duckplyr_summarise(df, x = mean(x), .by = g)
  expect_null(attr(out, "foo"))

  out <- duckplyr_summarise(tbl, x = mean(x), .by = g)
  expect_null(attr(out, "foo"))
})

test_that("transient grouping orders by first appearance", {
  df <- tibble(g = c(2, 1, 2, 0), x = c(4, 2, 8, 5))

  out <- duckplyr_summarise(df, x = mean(x), .by = g)

  expect_identical(out$g, c(2, 1, 0))
  expect_identical(out$x, c(6, 2, 5))
})

test_that("can't use `.by` with `.groups`", {
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df, .by = x, .groups = "drop")
  })
})

test_that("catches `.by` with grouped-df", {
  df <- tibble(x = 1)
  gdf <- duckplyr_group_by(df, x)

  expect_snapshot(error = TRUE, {
    duckplyr_summarise(gdf, .by = x)
  })
})

test_that("catches `.by` with rowwise-df", {
  df <- tibble(x = 1)
  rdf <- duckplyr_rowwise(df)

  expect_snapshot(error = TRUE, {
    duckplyr_summarise(rdf, .by = x)
  })
})

# errors -------------------------------------------------------------------

test_that("duckplyr_summarise() preserves the call stack on error (#5308)", {
  foobar <- function() stop("foo")

  stack <- NULL
  expect_error(
    withCallingHandlers(
      error = function(...) stack <<- sys.calls(),
      duckplyr_summarise(mtcars, foobar())
    )
  )

  expect_true(some(stack, is_call, "foobar"))
})

test_that("`duckplyr_summarise()` doesn't allow data frames with missing or empty names (#6758)", {
  df1 <- new_data_frame(set_names(list(1), ""))
  df2 <- new_data_frame(set_names(list(1), NA_character_))

  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df1)
  })
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df2)
  })
})

test_that("duckplyr_summarise() gives meaningful errors", {
  skip("TODO duckdb")
  eval(envir = global_env(), expr({
    expect_snapshot({
      # Messages about .groups=
      tibble(x = 1, y = 2) %>% duckplyr_group_by(x, y) %>% duckplyr_summarise()
      tibble(x = 1, y = 2) %>% duckplyr_rowwise(x, y) %>% duckplyr_summarise()
      tibble(x = 1, y = 2) %>% duckplyr_rowwise() %>% duckplyr_summarise()
    })
  }))

  eval(envir = global_env(), expr({
    expect_snapshot({
      # unsupported type
      (expect_error(
                      tibble(x = 1, y = c(1, 2, 2), z = runif(3)) %>%
                        duckplyr_summarise(a = rlang::env(a = 1))
      ))
      (expect_error(
                      tibble(x = 1, y = c(1, 2, 2), z = runif(3)) %>%
                        duckplyr_group_by(x, y) %>%
                        duckplyr_summarise(a = rlang::env(a = 1))
      ))
      (expect_error(
                      tibble(x = 1, y = c(1, 2, 2), z = runif(3)) %>%
                        duckplyr_rowwise() %>%
                        duckplyr_summarise(a = lm(y ~ x))
      ))

      # mixed types
      (expect_error(
                      tibble(id = 1:2, a = list(1, "2")) %>%
                        duckplyr_group_by(id) %>%
                        duckplyr_summarise(a = a[[1]])
      ))
      (expect_error(
                      tibble(id = 1:2, a = list(1, "2")) %>%
                        duckplyr_rowwise() %>%
                        duckplyr_summarise(a = a[[1]])
      ))

      # incompatible size
      (expect_error(
                      tibble(z = 1) %>%
                        duckplyr_summarise(x = 1:3, y = 1:2)
      ))
      (expect_error(
                      tibble(z = 1:2) %>%
                        duckplyr_group_by(z) %>%
                        duckplyr_summarise(x = 1:3, y = 1:2)
      ))
      (expect_error(
                      tibble(z = c(1, 3)) %>%
                        duckplyr_group_by(z) %>%
                        duckplyr_summarise(x = seq_len(z), y = 1:2)
      ))

      # mixed nulls
      (expect_error(
                      data.frame(x = 1:2, g = 1:2) %>% duckplyr_group_by(g) %>% duckplyr_summarise(x = if(g == 1) 42)
      ))
      (expect_error(
                      data.frame(x = 1:2, g = 1:2) %>% duckplyr_group_by(g) %>% duckplyr_summarise(x = if(g == 2) 42)
      ))

      # .data pronoun
      (expect_error(duckplyr_summarise(tibble(a = 1), c = .data$b)))
      (expect_error(duckplyr_summarise(duckplyr_group_by(tibble(a = 1:3), a), c = .data$b)))

      # Duplicate column names
      (expect_error(
                      tibble(x = 1, x = 1, .name_repair = "minimal") %>% duckplyr_summarise(x)
      ))

      # Not glue()ing
      (expect_error(tibble() %>% duckplyr_summarise(stop("{"))))
      (expect_error(
                      tibble(a = 1, b="{value:1, unit:a}") %>% duckplyr_group_by(b) %>% duckplyr_summarise(a = stop("!"))
      ))
    })
  }))

})

test_that("non-summary results are deprecated in favor of `duckplyr_reframe()` (#6382)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  local_options(lifecycle_verbosity = "warning")

  df <- tibble(g = c(1, 1, 2), x = 1:3)
  gdf <- duckplyr_group_by(df, g)
  rdf <- duckplyr_rowwise(df)

  expect_snapshot({
    out <- duckplyr_summarise(df, x = which(x < 3))
  })
  expect_identical(out$x, 1:2)

  expect_snapshot({
    out <- duckplyr_summarise(df, x = which(x < 3), .by = g)
  })
  expect_identical(out$g, c(1, 1))
  expect_identical(out$x, 1:2)

  # First group returns size 2 summary
  expect_snapshot({
    out <- duckplyr_summarise(gdf, x = which(x < 3))
  })
  expect_identical(out$g, c(1, 1))
  expect_identical(out$x, 1:2)

  # Last row returns size 0 summary
  expect_snapshot({
    out <- duckplyr_summarise(rdf, x = which(x < 3))
  })
  expect_identical(out$x, c(1L, 1L))
})
