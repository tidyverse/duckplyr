# across ------------------------------------------------------------------

test_that("across() works on one column data.frame", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x = 1)

  out <- df %>% duckplyr_mutate(across(everything(), identity))
  expect_equal(out, df)
})

test_that("across() does not select grouping variables", {
  df <- data.frame(g = 1, x = 1)

  out <- df %>% duckplyr_group_by(g) %>% duckplyr_summarise(x = across(everything(), identity)) %>% duckplyr_pull()
  expect_equal(out, tibble(x = 1))
})

test_that("across() correctly names output columns", {
  gf <- tibble(x = 1, y = 2, z = 3, s = "") %>% duckplyr_group_by(x)

  expect_named(
    duckplyr_summarise(gf, across(everything(), identity)),
    c("x", "y", "z", "s")
  )
  expect_named(
    duckplyr_summarise(gf, across(everything(), identity, .names = "id_{.col}")),
    c("x", "id_y", "id_z", "id_s")
  )
  expect_named(
    duckplyr_summarise(gf, across(where(is.numeric), mean)),
    c("x", "y", "z")
  )
  expect_named(
    duckplyr_summarise(gf, across(where(is.numeric), mean, .names = "mean_{.col}")),
    c("x", "mean_y", "mean_z")
  )
  expect_named(
    duckplyr_summarise(gf, across(where(is.numeric), list(mean = mean, sum = sum))),
    c("x", "y_mean", "y_sum", "z_mean", "z_sum")
  )
  expect_named(
    duckplyr_summarise(gf, across(where(is.numeric), list(mean = mean, sum))),
    c("x", "y_mean", "y_2", "z_mean", "z_2")
  )
  expect_named(
    duckplyr_summarise(gf, across(where(is.numeric), list(mean, sum = sum))),
    c("x", "y_1", "y_sum", "z_1", "z_sum")
  )
  expect_named(
    duckplyr_summarise(gf, across(where(is.numeric), list(mean, sum))),
    c("x", "y_1", "y_2", "z_1", "z_2")
  )
  expect_named(
    duckplyr_summarise(gf, across(where(is.numeric), list(mean = mean, sum = sum), .names = "{.fn}_{.col}")),
    c("x", "mean_y", "sum_y", "mean_z", "sum_z")
  )
})

test_that("across(.unpack =) can unpack data frame columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  fn1 <- function(x) {
    tibble(a = x, b = x + 1)
  }
  fn2 <- function(x) {
    tibble(c = -x, d = x - 1)
  }

  df <- tibble(x = 1:2, y = 3:4)

  out <- duckplyr_mutate(df, across(x:y, list(one = fn1, two = fn2), .unpack = TRUE))

  expect <- tibble(
    x = 1:2,
    y = 3:4,
    x_one_a = x,
    x_one_b = x + 1,
    x_two_c = -x,
    x_two_d = x - 1,
    y_one_a = y,
    y_one_b = y + 1,
    y_two_c = -y,
    y_two_d = y - 1
  )

  expect_identical(out, expect)
})

test_that("across(.unpack =) allows a glue specification for `.unpack`", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  fn <- function(x) {
    tibble(a = x, b = x + 1)
  }

  df <- tibble(x = 1)
  out <- duckplyr_mutate(df, across(x, fn, .unpack = "{outer}.{inner}"))
  expect_named(out, c("x", "x.a", "x.b"))

  # Can use variables from caller env
  out <- local({
    name <- "name"
    duckplyr_mutate(df, across(x, fn, .unpack = "{name}.{inner}"))
  })
  expect_named(out, c("x", "name.a", "name.b"))
})

test_that("across(.unpack =) skips unpacking non-df-cols", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  fn <- function(x) {
    tibble(a = x, b = x + 1)
  }

  df <- tibble(x = 1)

  out <- duckplyr_mutate(df, across(x, list(fn = fn, double = ~.x * 2), .unpack = TRUE))

  expect <- tibble(x = 1, x_fn_a = 1, x_fn_b = 2, x_double = 2)

  expect_identical(out, expect)
})

test_that("across(.unpack =) uses the result of `.names` as `{outer}`", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  fn <- function(x) {
    tibble(a = x, b = x + 1)
  }

  df <- tibble(x = 1, y = 2)

  out <- df %>% duckplyr_mutate(
    across(x:y, list(f = fn), .names = "{.col}.{.fn}", .unpack = "{inner}.{outer}")
  )

  expect_named(out, c("x", "y", "a.x.f", "b.x.f", "a.y.f", "b.y.f"))
})

test_that("across(.unpack =) errors if the unpacked data frame has non-unique names", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  fn <- function(x) {
    tibble(a = x, b = x)
  }

  df <- tibble(x = 1, y = 2)

  expect_snapshot(error = TRUE, {
    duckplyr_mutate(df, across(x:y, fn, .unpack = "{outer}"))
  })
})

test_that("`.unpack` is validated", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df, across(x, mean, .unpack = 1))
  })
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df, across(x, mean, .unpack = c("x", "y")))
  })
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df, across(x, mean, .unpack = NA))
  })
})

test_that("across() result locations are aligned with column names (#4967)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:2, y = c("a", "b"))
  expect <- tibble(x_cls = "integer", x_type = TRUE, y_cls = "character", y_type = FALSE)

  x <- duckplyr_summarise(df, across(everything(), list(cls = class, type = is.numeric)))

  expect_identical(x, expect)
})


test_that("across() works sequentially (#4907)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(a = 1)
  expect_equal(
    duckplyr_mutate(df, x = ncol(across(where(is.numeric), identity)), y = ncol(across(where(is.numeric), identity))),
    tibble(a = 1, x = 1L, y = 2L)
  )
  expect_equal(
    duckplyr_mutate(df, a = "x", y = ncol(across(where(is.numeric), identity))),
    tibble(a = "x", y = 0L)
  )
  expect_equal(
    duckplyr_mutate(df, x = 1, y = ncol(across(where(is.numeric), identity))),
    tibble(a = 1, x = 1, y = 2L)
  )
})

test_that("across() retains original ordering", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(a = 1, b = 2)
  expect_named(duckplyr_mutate(df, a = 2, x = across(everything(), identity))$x, c("a", "b"))
})

test_that("across() throws meaningful error with failure during expansion (#6534)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = 1, x = 1, y = 2, z = 3)
  gdf <- duckplyr_group_by(df, g)

  fn <- function() {
    stop("oh no!")
  }

  # Ends up failing inside the `fn()` call, which gets evaluated
  # during `across()` expansion but outside any group context
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df, across(everything(), fn()))
  })
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(df, across(everything(), fn()), .by = g)
  })
  expect_snapshot(error = TRUE, {
    duckplyr_summarise(gdf, across(everything(), fn()))
  })
})

test_that("across() gives meaningful messages", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_snapshot({
    # expanding
    (expect_error(
      tibble(x = 1) %>%
        duckplyr_summarise(across(where(is.numeric), 42))
    ))
    (expect_error(
      tibble(x = 1) %>%
        duckplyr_summarise(across(y, mean))
    ))

    # computing
    (expect_error(
      tibble(x = 1) %>%
        duckplyr_summarise(res = across(where(is.numeric), 42))
    ))
    (expect_error(
      tibble(x = 1) %>%
        duckplyr_summarise(z  = across(y, mean))
    ))
    (expect_error(
      tibble(x = 1) %>%
        duckplyr_summarise(res = sum(if_any(where(is.numeric), 42)))
    ))
    (expect_error(
      tibble(x = 1) %>%
        duckplyr_summarise(res = sum(if_all(~mean(.x))))
    ))
    (expect_error(
      tibble(x = 1) %>%
        duckplyr_summarise(res = sum(if_any(~mean(.x))))
    ))

    (expect_error(across()))
    (expect_error(c_across()))

    # problem while computing
    error_fn <- function(.) {
      if (all(. > 10)) {
        rlang::abort("too small", call = call("error_fn"))
      } else {
        42
      }
    }
    (expect_error( # expanding
      tibble(x = 1:10, y = 11:20) %>%
        duckplyr_summarise(across(everything(), error_fn))
    ))
    (expect_error( # expanding
      tibble(x = 1:10, y = 11:20) %>%
        duckplyr_mutate(across(everything(), error_fn))
    ))

    (expect_error( # evaluating
      tibble(x = 1:10, y = 11:20) %>%
        duckplyr_summarise(force(across(everything(), error_fn)))
    ))
    (expect_error( # evaluating
      tibble(x = 1:10, y = 11:20) %>%
        duckplyr_mutate(force(across(everything(), error_fn)))
    ))

    # name issue
    (expect_error(
      tibble(x = 1) %>%
        duckplyr_summarise(across(everything(), list(f = mean, f = mean)))
    ))

  })

})

test_that("monitoring cache - across() can be used twice in the same expression", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(a = 1, b = 2)
  expect_equal(
    duckplyr_mutate(df, x = ncol(across(where(is.numeric), identity)) + ncol(across(a, identity))),
    tibble(a = 1, b = 2, x = 3)
  )
})

test_that("monitoring cache - across() can be used in separate expressions", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(a = 1, b = 2)
  expect_equal(
    duckplyr_mutate(df, x = ncol(across(where(is.numeric), identity)), y = ncol(across(a, identity))),
    tibble(a = 1, b = 2, x = 2, y = 1)
  )
})

test_that("monitoring cache - across() usage can depend on the group id", {
  df <- tibble(g = 1:2, a = 1:2, b = 3:4)
  df <- duckplyr_group_by(df, g)

  switcher <- function() {
    if_else(cur_group_id() == 1L, across(a, identity)$a, across(b, identity)$b)
  }

  expect <- df
  expect$x <- c(1L, 4L)

  expect_equal(
    duckplyr_mutate(df, x = switcher()),
    expect
  )
})

test_that("monitoring cache - across() internal cache key depends on all inputs", {
  df <- tibble(g = rep(1:2, each = 2), a = 1:4)
  df <- duckplyr_group_by(df, g)

  expect_identical(
    duckplyr_mutate(df, tibble(x = across(where(is.numeric), mean)$a, y = across(where(is.numeric), max)$a)),
    duckplyr_mutate(df, x = mean(a), y = max(a))
  )
})

test_that("across() rejects non vectors", {
  expect_error(
    data.frame(x = 1) %>% duckplyr_summarise(across(everything(), ~sym("foo")))
  )
})

test_that("across() uses tidy recycling rules", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_equal(
    data.frame(x = 1, y = 2) %>% duckplyr_reframe(across(everything(), ~rep(42, .))),
    data.frame(x = rep(42, 2), y = rep(42, 2))
  )

  expect_error(
    data.frame(x = 2, y = 3) %>% duckplyr_reframe(across(everything(), ~rep(42, .)))
  )
})

test_that("across(<empty set>) returns a data frame with 1 row (#5204)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:42)
  expect_equal(
    duckplyr_mutate(df, across(c(), as.factor)),
    df
  )
  expect_equal(
    duckplyr_mutate(df, y = across(c(), as.factor))$y,
    tibble::new_tibble(list(), nrow = 42)
  )
  duckplyr_mutate(df, {
    res <- across(c(), as.factor)
    expect_equal(nrow(res), 1L)
    res
  })
})

test_that("across(.names=) can use local variables in addition to {col} and {fn}", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  res <- local({
    prefix <- "MEAN"
    data.frame(x = 42) %>%
      duckplyr_summarise(across(everything(), mean, .names = "{prefix}_{.col}"))
  })
  expect_identical(res, data.frame(MEAN_x = 42))
})

test_that("across(.unpack=) can use local variables in addition to {outer} and {inner}", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  fn <- function(x) {
    tibble(x = x, y = x + 1)
  }

  res <- local({
    prefix <- "FN"
    data.frame(col1 = 42, col2 = 24) %>%
      duckplyr_summarise(across(everything(), fn, .unpack = "{prefix}_{outer}_{inner}"))
  })

  expect_identical(
    res,
    data.frame(
      FN_col1_x = 42, FN_col1_y = 43,
      FN_col2_x = 24, FN_col2_y = 25
    )
  )
})

test_that("across() uses environment from the current quosure (#5460)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # If the data frame `y` is selected, causes a subscript conversion
  # error since it is fractional
  df <- data.frame(x = 1, y = 2.4)
  y <- "x"
  expect_equal(df %>% duckplyr_summarise(across(all_of(y), mean)), data.frame(x = 1))
  expect_equal(df %>% duckplyr_mutate(across(all_of(y), mean)), df)
  expect_equal(df %>% duckplyr_filter(if_all(all_of(y), ~ .x < 2)), df)

  # Inherited case
  expect_error(df %>% duckplyr_summarise(local(across(all_of(y), mean))))

  expect_equal(
    df %>% duckplyr_summarise(duckplyr_summarise(pick(everything()), across(all_of(y), mean))),
    df %>% duckplyr_summarise(across(all_of(y), mean))
  )
})

test_that("across() sees columns in the recursive case (#5498)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  skip_if_not_installed("purrr")
  df <- tibble(
    vars = list("foo"),
    data = list(data.frame(foo = 1, bar = 2))
  )

  out <- df %>% duckplyr_mutate(data = purrr::map2(data, vars, ~ {
    .x %>% duckplyr_mutate(across(all_of(.y), ~ NA))
  }))
  exp <- tibble(
    vars = list("foo"),
    data = list(data.frame(foo = NA, bar = 2))
  )
  expect_identical(out, exp)

  out <- df %>% duckplyr_mutate(data = purrr::map2(data, vars, ~ {
    local({
      .y <- "bar"
      .x %>% duckplyr_mutate(across(all_of(.y), ~ NA))
    })
  }))
  exp <- tibble(
    vars = list("foo"),
    data = list(data.frame(foo = 1, bar = NA))
  )
  expect_identical(out, exp)
})

test_that("across() works with empty data frames (#5523)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
   expect_equal(
     duckplyr_mutate(tibble(), across(everything(), identity)),
     tibble()
   )
})

test_that("lambdas in duckplyr_mutate() + across() can use columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 2, y = 4, z = 8)
  expect_identical(
    df %>% duckplyr_mutate(data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_mutate(across(everything(), ~ .x / y))
  )
  expect_identical(
    df %>% duckplyr_mutate(data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_mutate(+across(everything(), ~ .x / y))
  )

  expect_identical(
    df %>% duckplyr_mutate(data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_mutate(across(everything(), ~ .x / .data$y))
  )
  expect_identical(
    df %>% duckplyr_mutate(data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_mutate(+across(everything(), ~ .x / .data$y))
  )
})

test_that("lambdas in duckplyr_summarise() + across() can use columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 2, y = 4, z = 8)
  expect_identical(
    df %>% duckplyr_summarise(data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_summarise(across(everything(), ~ .x / y))
  )
  expect_identical(
    df %>% duckplyr_summarise(data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_summarise(+across(everything(), ~ .x / y))
  )

  expect_identical(
    df %>% duckplyr_summarise(data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_summarise(across(everything(), ~ .x / .data$y))
  )
  expect_identical(
    df %>% duckplyr_summarise(data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_summarise(+across(everything(), ~ .x / .data$y))
  )
})

test_that("lambdas in duckplyr_mutate() + across() can use columns in follow up expressions (#5717)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 2, y = 4, z = 8)
  expect_identical(
    df %>% duckplyr_mutate(a = 2, data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_mutate(a = 2, across(c(x, y, z), ~ .x / y))
  )
  expect_identical(
    df %>% duckplyr_mutate(a = 2, data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_mutate(a = 2, +across(c(x, y, z), ~ .x / y))
  )

  expect_identical(
    df %>% duckplyr_mutate(a = 2, data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_mutate(a = 2, across(c(x, y, z), ~ .x / .data$y))
  )
  expect_identical(
    df %>% duckplyr_mutate(a = 2, data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_mutate(a = 2, +across(c(x, y, z), ~ .x / .data$y))
  )
})

test_that("lambdas in duckplyr_summarise() + across() can use columns in follow up expressions (#5717)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 2, y = 4, z = 8)
  expect_identical(
    df %>% duckplyr_summarise(a = 2, data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_summarise(a = 2, across(c(x, y, z), ~ .x / y))
  )
  expect_identical(
    df %>% duckplyr_summarise(a = 2, data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_summarise(a = 2, +across(c(x, y, z), ~ .x / y))
  )

  expect_identical(
    df %>% duckplyr_summarise(a = 2, data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_summarise(a = 2, across(c(x, y, z), ~ .x / .data$y))
  )
  expect_identical(
    df %>% duckplyr_summarise(a = 2, data.frame(x = x / y, y = y / y, z = z / y)),
    df %>% duckplyr_summarise(a = 2, +across(c(x, y, z), ~ .x / .data$y))
  )
})

test_that("functions defined inline can use columns (#5734)", {
  df <- data.frame(x = 1, y = 2)
  expect_equal(
    df %>% duckplyr_mutate(across('x', function(.x) .x / y)) %>% duckplyr_pull(x),
    0.5
  )
})

test_that("if_any() and if_all() do not enforce logical", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # We used to coerce to logical using vctrs. Now we use base
  # semantics because we expand `if_all(x:y)` to `x & y`.
  d <- data.frame(x = 10, y = 10)
  expect_equal(duckplyr_filter(d, if_all(x:y, identity)), d)
  expect_equal(duckplyr_filter(d, if_any(x:y, identity)), d)

  expect_equal(
    duckplyr_mutate(d, ok = if_any(x:y, identity)),
    duckplyr_mutate(d, ok = TRUE)
  )
  expect_equal(
    duckplyr_mutate(d, ok = if_all(x:y, identity)),
    duckplyr_mutate(d, ok = TRUE)
  )
})

test_that("if_any() and if_all() can be used in duckplyr_mutate() (#5709)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  d <- data.frame(x = c(1, 5, 10, 10), y = c(0, 0, 0, 10), z = c(10, 5, 1, 10))
  res <- d %>%
    duckplyr_mutate(
      any = if_any(x:z, ~ . > 8),
      all = if_all(x:z, ~ . > 8)
    )
  expect_equal(res$any, c(TRUE, FALSE, TRUE, TRUE))
  expect_equal(res$all, c(FALSE, FALSE, FALSE, TRUE))
})

test_that("across() caching not confused when used from if_any() and if_all() (#5782)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  res <- data.frame(x = 1:3) %>%
    duckplyr_mutate(
      any = if_any(x, ~ . >= 2) + if_any(x, ~ . >= 3),
      all = if_all(x, ~ . >= 2) + if_all(x, ~ . >= 3)
    )
  expect_equal(res$any, c(0, 1, 2))
  expect_equal(res$all, c(0, 1, 2))
})

test_that("if_any() and if_all() respect duckplyr_filter()-like NA handling", {
  df <- expand.grid(
    x = c(TRUE, FALSE, NA), y = c(TRUE, FALSE, NA)
  )
  expect_identical(
    duckplyr_filter(df, x & y),
    duckplyr_filter(df, if_all(c(x,y), identity))
  )
  expect_identical(
    duckplyr_filter(df, x | y),
    duckplyr_filter(df, if_any(c(x,y), identity))
  )
})

test_that("if_any() and if_all() aborts when predicate mistakingly used in .cols= (#5732)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x = 1:10, y = 1:10)
  expect_snapshot({
    # expanded case
    (expect_error(duckplyr_filter(df, if_any(~ .x > 5))))
    (expect_error(duckplyr_filter(df, if_all(~ .x > 5))))

    # non expanded case
    (expect_error(duckplyr_filter(df, !if_any(~ .x > 5))))
    (expect_error(duckplyr_filter(df, !if_all(~ .x > 5))))
  })
})

test_that("across() correctly reset column", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_error(cur_column())
  res <- data.frame(x = 1) %>%
    duckplyr_summarise(
      a = { expect_error(cur_column()); 2},
      across(x, ~{ expect_equal(cur_column(), "x"); 3}, .names = "b"),        # top_across()
      c = { expect_error(cur_column()); 4},
      force(across(x, ~{ expect_equal(cur_column(), "x"); 5}, .names = "d")),  # across()
      e = { expect_error(cur_column()); 6}
    )
  expect_equal(res, data.frame(a = 2, b = 3, c = 4, d = 5, e = 6))
  expect_error(cur_column())

  res <- data.frame(x = 1) %>%
    duckplyr_mutate(
      a = { expect_error(cur_column()); 2},
      across(x, ~{ expect_equal(cur_column(), "x"); 3}, .names = "b"),        # top_across()
      c = { expect_error(cur_column()); 4},
      force(across(x, ~{ expect_equal(cur_column(), "x"); 5}, .names = "d")),  # across()
      e = { expect_error(cur_column()); 6}
    )
  expect_equal(res, data.frame(x = 1, a = 2, b = 3, c = 4, d = 5, e = 6))
  expect_error(cur_column())
})

test_that("across() can omit dots", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = tibble(foo = 1), y = tibble(foo = 2))

  # top
  res <- duckplyr_mutate(df, across(
    everything(),
    list
  ))
  expect_equal(res$x[[1]]$foo, 1)
  expect_equal(res$y[[1]]$foo, 2)

  # not top
  res <- duckplyr_mutate(df, force(across(
    everything(),
    list
  )))
  expect_equal(res$x[[1]]$foo, 1)
  expect_equal(res$y[[1]]$foo, 2)
})

test_that("group variables are in scope (#5832)", {
  f <- function(x, z) x + z
  gdf <- data.frame(x = 1:2, y = 3:4, g = 1:2) %>% duckplyr_group_by(g)
  exp <- gdf %>% duckplyr_summarise(x = f(x, z = y))

  expect_equal(
    gdf %>% duckplyr_summarise(across(x, ~ f(.x, z = y))),
    exp
  )

  expect_equal(
    gdf %>% duckplyr_summarise(across(x, ~ f(.x, z = y))),
    exp
  )
})

test_that("can pass quosure through `across()`", {
  summarise_mean <- function(data, vars) {
    data %>% duckplyr_summarise(across({{ vars }}, mean))
  }
  gdf <- data.frame(g = c(1, 1, 2), x = 1:3) %>% duckplyr_group_by(g)

  expect_equal(
    gdf %>% summarise_mean(where(is.numeric)),
    duckplyr_summarise(gdf, x = mean(x))
  )
})

test_that("across() inlines formulas", {
  # Env of captured quosure passed to `as_across_fn_call()`. The
  # unevaluated lambdas should inherit from that env after inlining.
  env <- env()

  lambda <- quo_eval_fns(quo(function(x) fn(x)), mask = env)
  out <- as_across_fn_call(lambda, quote(var), env, env)
  expect_equal(out, new_quosure(quote(fn(var)), env))

  formula <- quo_eval_fns(quo(~ fn(.x)), mask = env)
  out <- as_across_fn_call(formula, quote(var), env, env)
  expect_equal(out, new_quosure(quote(fn(var)), env))

  # Evaluated formulas preserve their own env
  f <- local(~ fn(.x))
  fn <- quo_eval_fns(quo(!!f), mask = env)
  out <- as_across_fn_call(fn, quote(var), env, env)
  expect_equal(get_env(f), get_env(fn))
  expect_equal(out, new_quosure(call2(fn, quote(var)), env))

  # Inlining is disabled for complex lambda calls
  fn <- quo_eval_fns(quo(function(x, y) x), mask = env)
  out <- as_across_fn_call(fn, quote(var), env, env)
  expect_equal(out, new_quosure(call2(fn, quote(var)), env))

  # Formulas are converted to functions
  expect_rlang_lambda <- function(fn) {
    expect_s3_class(fn, "rlang_lambda_function")
    out <- as_across_fn_call(fn, quote(var), env, env)
    expect_equal(out, new_quosure(call2(fn, quote(var)), env))
  }

  out <- quo_eval_fns(quo(~ .y), mask = env)
  expect_rlang_lambda(out)

  out <- quo_eval_fns(quo(list(~ .y)), mask = env)
  expect_type(out, "list")
  map(out, expect_rlang_lambda)

  # All formula-lambda arguments are interpolated
  fn <- quo_eval_fns(quo(~ list(.x, ., .x)), mask = env)
  out <- as_across_fn_call(fn, quote(var), env, env)
  expect_equal(
    out,
    new_quosure(quote(list(var, var, var)), f_env(f))
  )
})

test_that("inlined and non inlined lambdas work", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(foo = 1:2, bar = 100:101)
  exp <- data.frame(foo = c(101.5, 102.5), bar = c(200.5, 201.5))

  expect_equal(df %>% duckplyr_mutate(across(1:2, function(x) x + mean(bar))), exp)
  expect_equal(df %>% duckplyr_mutate((across(1:2, function(x) x + mean(bar)))), exp)

  expect_equal(df %>% duckplyr_mutate(across(1:2, ~ .x + mean(bar))), exp)
  expect_equal(df %>% duckplyr_mutate((across(1:2, ~ .x + mean(bar)))), exp)

  expect_equal(df %>% duckplyr_mutate(across(1:2, ~ ..1 + mean(bar))), exp)
  expect_equal(df %>% duckplyr_mutate((across(1:2, ~ ..1 + mean(bar)))), exp)

  # Message generated by base R changed
  skip_if_not_installed("base", "3.6.0")
  expect_snapshot({
    (expect_error(df %>% duckplyr_mutate(across(1:2, ~ .y + mean(bar)))))
    (expect_error(df %>% duckplyr_mutate((across(1:2, ~ .y + mean(bar))))))
  })
})

test_that("list of lambdas work", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(foo = 1:2, bar = 100:101)
  exp <- cbind(
    df,
    data.frame(foo_1 = c(101.5, 102.5), bar_1 = c(200.5, 201.5))
  )

  expect_equal(df %>% duckplyr_mutate(across(1:2, list(function(x) x + mean(bar)))), exp)
  expect_equal(df %>% duckplyr_mutate((across(1:2, list(function(x) x + mean(bar))))), exp)

  expect_equal(df %>% duckplyr_mutate(across(1:2, list(~ .x + mean(bar)))), exp)
  expect_equal(df %>% duckplyr_mutate((across(1:2, list(~ .x + mean(bar))))), exp)
})

test_that("anonymous function `.fns` can access the `.data` pronoun even when not inlined", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:2, y = 3:4)

  # Can't access it here, `fn()`'s environment doesn't know about `.data`
  fn <- function(col) {
    .data[["x"]]
  }
  expect_snapshot(error = TRUE, {
    duckplyr_mutate(df, across(y, fn))
  })

  # Can access it with inlinable quosures
  out <- duckplyr_mutate(df, across(y, function(col) {
    .data[["x"]]
  }))
  expect_identical(out$y, out$x)

  # Can access it with non-inlinable quosures
  out <- duckplyr_mutate(df, across(y, function(col) {
    return(.data[["x"]])
  }))
  expect_identical(out$y, out$x)
})

test_that("across() uses local formula environment (#5881)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  f <- local({
    prefix <- "foo"
    ~ paste(prefix, .x)
  })
  df <- tibble(x = "x")
  expect_equal(
    duckplyr_mutate(df, across(x, f)),
    tibble(x = "foo x")
  )
  expect_equal(
    duckplyr_mutate(df, across(x, list(f = f))),
    tibble(x = "x", x_f = "foo x")
  )

  local({
    # local() here is not necessary, it's just in case the
    # code is run directly without the test_that()
    prefix <- "foo"
    expect_equal(
      duckplyr_mutate(df, across(x, ~paste(prefix, .x))),
      tibble(x = "foo x")
    )
    expect_equal(
      duckplyr_mutate(df, across(x, list(f = ~paste(prefix, .x)))),
      tibble(x = "x", x_f = "foo x")
    )
  })

  expect_equal(
    data.frame(x = 1) %>% duckplyr_mutate(across(1, list(f = local(~ . + 1)))),
    data.frame(x = 1, x_f = 2)
  )

  expect_equal(
    data.frame(x = 1) %>% duckplyr_mutate(across(1, local({
      `_local_var` <- 1
      ~ . + `_local_var`
    }))),
    data.frame(x = 2)
  )
})

test_that("unevaluated formulas (currently) fail", {
  df <- tibble(x = "x")
  expect_error(
    duckplyr_mutate(df, across(x, quote(~ paste("foo", .x))))
  )
})

test_that("across() can access lexical scope (#5862)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  f_across <- function(data, cols, fn) {
    data %>%
      duckplyr_summarise(
        across({{ cols }}, fn)
      )
  }

  df <- data.frame(x = 1:10, y = 1:10)
  expect_equal(
    f_across(df, c(x, y), mean),
    duckplyr_summarise(df, across(c(x, y), mean))
  )
})

test_that("across() allows renaming in `.cols` (#6895)", {
  df <- tibble(x = 1, y = 2, z = 3)
  cols <- set_names(c("x", "y"), c("a", "b"))

  expect_identical(
    duckplyr_mutate(df, across(all_of(cols), identity)),
    duckplyr_mutate(df, a = x, b = y)
  )
  expect_identical(
    duckplyr_mutate(df, (across(all_of(cols), identity))),
    duckplyr_mutate(df, a = x, b = y)
  )

  expect_identical(
    duckplyr_mutate(df, across(all_of(cols), identity, .names = "{.col}_name")),
    duckplyr_mutate(df, a_name = x, b_name = y)
  )
  expect_identical(
    duckplyr_mutate(df, (across(all_of(cols), identity, .names = "{.col}_name"))),
    duckplyr_mutate(df, a_name = x, b_name = y)
  )
})

test_that("if_any() and if_all() expansions deal with no inputs or single inputs", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  d <- data.frame(x = 1)

  # No inputs
  expect_equal(
    duckplyr_filter(d, if_any(starts_with("c"), ~ FALSE)),
    duckplyr_filter(d)
  )
  expect_equal(
    duckplyr_filter(d, if_all(starts_with("c"), ~ FALSE)),
    duckplyr_filter(d)
  )

  # Single inputs
  expect_equal(
    duckplyr_filter(d, if_any(x, ~ FALSE)),
    duckplyr_filter(d, FALSE)
  )
  expect_equal(
    duckplyr_filter(d, if_all(x, ~ FALSE)),
    duckplyr_filter(d, FALSE)
  )
})

test_that("if_any() and if_all() wrapped deal with no inputs or single inputs", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  d <- data.frame(x = 1)

  # No inputs
  expect_equal(
    duckplyr_filter(d, (if_any(starts_with("c"), ~ FALSE))),
    duckplyr_filter(d)
  )
  expect_equal(
    duckplyr_filter(d, (if_all(starts_with("c"), ~ FALSE))),
    duckplyr_filter(d)
  )

  # Single inputs
  expect_equal(
    duckplyr_filter(d, (if_any(x, ~ FALSE))),
    duckplyr_filter(d, FALSE)
  )
  expect_equal(
    duckplyr_filter(d, (if_all(x, ~ FALSE))),
    duckplyr_filter(d, FALSE)
  )
})

test_that("expanded if_any() finds local data", {
  limit <- 7
  df <- data.frame(x = 1:10, y = 10:1)

  expect_identical(
    duckplyr_filter(df, if_any(everything(), ~ .x > limit)),
    duckplyr_filter(df, x > limit | y > limit)
  )
})

test_that("across() can use named selections", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x = 1, y = 2)

  # no fns
  expect_equal(
    df %>% duckplyr_summarise(across(c(a = x, b = y))),
    data.frame(a = 1, b = 2)
  )
  expect_equal(
    df %>% duckplyr_summarise(across(all_of(c(a = "x", b = "y")))),
    data.frame(a = 1, b = 2)
  )

  # no fns, non expanded
  expect_equal(
    df %>% duckplyr_summarise((across(c(a = x, b = y)))),
    data.frame(a = 1, b = 2)
  )
  expect_equal(
    df %>% duckplyr_summarise((across(all_of(c(a = "x", b = "y"))))),
    data.frame(a = 1, b = 2)
  )

  # one fn
  expect_equal(
    df %>% duckplyr_summarise(across(c(a = x, b = y), mean)),
    data.frame(a = 1, b = 2)
  )
  expect_equal(
    df %>% duckplyr_summarise(across(all_of(c(a = "x", b = "y")), mean)),
    data.frame(a = 1, b = 2)
  )

  # one fn - non expanded
  expect_equal(
    df %>% duckplyr_summarise((across(c(a = x, b = y), mean))),
    data.frame(a = 1, b = 2)
  )
  expect_equal(
    df %>% duckplyr_summarise((across(all_of(c(a = "x", b = "y")), mean))),
    data.frame(a = 1, b = 2)
  )

  # multiple fns
  expect_equal(
    df %>% duckplyr_summarise(across(c(a = x, b = y), list(mean = mean, sum = sum))),
    data.frame(a_mean = 1, a_sum = 1, b_mean = 2, b_sum = 2)
  )
  expect_equal(
    df %>% duckplyr_summarise(across(all_of(c(a = "x", b = "y")), list(mean = mean, sum = sum))),
    data.frame(a_mean = 1, a_sum = 1, b_mean = 2, b_sum = 2)
  )

  # multiple fns - non expanded
  expect_equal(
    df %>% duckplyr_summarise((across(c(a = x, b = y), list(mean = mean, sum = sum)))),
    data.frame(a_mean = 1, a_sum = 1, b_mean = 2, b_sum = 2)
  )
  expect_equal(
    df %>% duckplyr_summarise((across(all_of(c(a = "x", b = "y")), list(mean = mean, sum = sum)))),
    data.frame(a_mean = 1, a_sum = 1, b_mean = 2, b_sum = 2)
  )
})

test_that("expr_subtitute() stops at lambdas (#5896)", {
  expect_identical(
    expr_substitute(expr(map(.x, ~mean(.x))), quote(.x), quote(a)),
    expr(map(a, ~mean(.x)))
  )
  expect_identical(
    expr_substitute(expr(map(.x, function(.x) mean(.x))), quote(.x), quote(a)),
    expr(map(a, function(.x) mean(.x)))
  )
})

test_that("expr_subtitute() keeps at double-sided formula (#5894)", {
  expect_identical(
    expr_substitute(expr(case_when(.x < 5 ~ 5, .default = .x)), quote(.x), quote(a)),
    expr(case_when(a < 5 ~ 5, .default = a))
  )

  expect_identical(
    expr_substitute(expr(case_when(. < 5 ~ 5, .default = .)), quote(.), quote(a)),
    expr(case_when(a < 5 ~ 5, .default = a))
  )
})

test_that("across() predicates operate on whole data", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(
    x = c(1, 1, 2),
    g = c(1, 1, 2)
  )

  out <- df %>%
    duckplyr_mutate(across(where(~ n_distinct(.x) > 1), ~ .x + 10))

  exp <- tibble(
    x = c(11, 11, 12),
    g = c(11, 11, 12)
  )

  expect_equal(out, exp)


  out <- df %>%
    duckplyr_group_by(g) %>%
    duckplyr_mutate(across(where(~ n_distinct(.x) > 1), ~ .x + 10))

  exp <- tibble(
    x = c(11, 11, 12),
    g = c(1, 1, 2)
  ) %>%
    duckplyr_group_by(g)

  expect_equal(out, exp)
})

test_that("expand_across() expands lambdas", {
  quo <- quo(across(c(cyl, am), ~ identity(.x)))
  quo <- new_dplyr_quosure(
    quo,
    name = quo,
    is_named = FALSE,
    index = 1
  )

  by <- compute_by(by = NULL, data = mtcars, error_call = call("caller"))
  DataMask$new(mtcars, by, "mutate", call("caller"))

  expect_equal(
    map(expand_across(quo), quo_get_expr),
    exprs(
      cyl = identity(cyl),
      am = identity(am)
    )
  )
})

test_that("expand_if_across() expands lambdas", {
  quo <- quo(if_any(c(cyl, am), ~ . > 4))
  quo <- new_dplyr_quosure(
    quo,
    name = quo,
    is_named = FALSE,
    index = 1
  )

  by <- compute_by(by = NULL, data = mtcars, error_call = call("caller"))
  DataMask$new(mtcars, by, "mutate", call("caller"))

  expect_equal(
    map(expand_if_across(quo), quo_squash),
    alist(`|`(cyl > 4, am > 4))
  )
})

test_that("duckplyr_rowwise() preserves list-cols iff no `.fns` (#5951, #6264)", {
  # TODO: Deprecate this behavior in favor of `pick()`, which doesn't preserve
  # list-cols but is well-defined as pure macro expansion.

  rf <- duckplyr_rowwise(tibble(x = list(1:2, 3:5)))

  # Need to unchop so works like duckplyr_mutate(rf, x = length(x))
  out <- duckplyr_mutate(rf, across(everything(), length))
  expect_equal(out$x, c(2, 3))

  # Need to preserve to create valid data frame
  out <- duckplyr_mutate(rf, across = list(across(everything())))
  expect_equal(out$across, list(
    tibble(x = list(1:2)),
    tibble(x = list(3:5))
  ))
})

# c_across ----------------------------------------------------------------

test_that("selects and combines columns", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x = 1:2, y = 3:4)
  out <- df %>% duckplyr_summarise(z = list(c_across(x:y)))
  expect_equal(out$z, list(1:4))
})

test_that("can't rename during selection (#6522)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_mutate(df, z = c_across(c(y = x)))
  })
})

test_that("can't explicitly select grouping columns (#6522)", {
  # Related to removing the mask layer from the quosure environments
  df <- tibble(g = 1, x = 2)
  gdf <- duckplyr_group_by(df, g)

  expect_snapshot(error = TRUE, {
    duckplyr_mutate(gdf, y = c_across(g))
  })
})

test_that("`all_of()` is evaluated in the correct environment (#6522)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # Related to removing the mask layer from the quosure environments
  df <- tibble(x = 1, y = 2)

  # We expect an "object not found" error, but we don't control that
  # so we aren't going to snapshot it, especially since the call reported
  # by those kinds of errors changed in R 4.3.
  expect_error(duckplyr_mutate(df, z = c_across(all_of(y))))

  y <- "x"
  expect <- df[["x"]]

  out <- duckplyr_mutate(df, z = c_across(all_of(y)))
  expect_identical(out$z, expect)
})

# cols deprecation --------------------------------------------------------

test_that("across() applies old `.cols = everything()` default with a warning", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  local_options(lifecycle_verbosity = "warning")

  df <- tibble(g = c(1, 2), x = c(1, 2), y = c(3, 4))
  gdf <- duckplyr_group_by(df, g)

  times_two <- function(x) x * 2

  # Expansion path
  expect_snapshot(out <- duckplyr_mutate(df, across(.fns = times_two)))
  expect_identical(out$g, df$g * 2)
  expect_identical(out$x, df$x * 2)
  expect_identical(out$y, df$y * 2)
  expect_snapshot(out <- duckplyr_mutate(gdf, across(.fns = times_two)))
  expect_identical(out$g, df$g)
  expect_identical(out$x, df$x * 2)
  expect_identical(out$y, df$y * 2)

  # Evaluation path
  expect_snapshot(out <- duckplyr_mutate(df, (across(.fns = times_two))))
  expect_identical(out$g, df$g * 2)
  expect_identical(out$x, df$x * 2)
  expect_identical(out$y, df$y * 2)
  expect_snapshot(out <- duckplyr_mutate(gdf, (across(.fns = times_two))))
  expect_identical(out$g, df$g)
  expect_identical(out$x, df$x * 2)
  expect_identical(out$y, df$y * 2)
})

test_that("if_any() and if_all() apply old `.cols = everything()` default with a warning", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  local_options(lifecycle_verbosity = "warning")

  df <- tibble(x = c(TRUE, FALSE, TRUE), y = c(FALSE, FALSE, TRUE))
  gdf <- duckplyr_mutate(df, g = c(1, 1, 2), .before = 1)
  gdf <- duckplyr_group_by(gdf, g)

  # Expansion path
  expect_snapshot(out <- duckplyr_filter(df, if_any()))
  expect_identical(out, df[c(1, 3),])
  expect_snapshot(out <- duckplyr_filter(gdf, if_any()))
  expect_identical(out, gdf[c(1, 3),])

  expect_snapshot(out <- duckplyr_filter(df, if_all()))
  expect_identical(out, df[3,])
  expect_snapshot(out <- duckplyr_filter(gdf, if_all()))
  expect_identical(out, gdf[3,])

  # Evaluation path
  expect_snapshot(out <- duckplyr_filter(df, (if_any())))
  expect_identical(out, df[c(1, 3),])
  expect_snapshot(out <- duckplyr_filter(gdf, (if_any())))
  expect_identical(out, gdf[c(1, 3),])

  expect_snapshot(out <- duckplyr_filter(df, (if_all())))
  expect_identical(out, df[3,])
  expect_snapshot(out <- duckplyr_filter(gdf, (if_all())))
  expect_identical(out, gdf[3,])
})

test_that("c_across() applies old `cols = everything()` default with a warning", {
  local_options(lifecycle_verbosity = "warning")

  df <- tibble(x = c(1, 3), y = c(2, 4))
  df <- duckplyr_rowwise(df)

  # Will see 2 warnings because verbosity option forces it to warn every time
  expect_snapshot(out <- duckplyr_mutate(df, z = sum(c_across())))
  expect_identical(out$z, c(3, 7))
})

# fns deprecation ---------------------------------------------------------

test_that("across() applies old `.fns = NULL` default", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1, y = 2)

  # Expansion path
  out <- duckplyr_mutate(df, z = across(everything()))
  expect_identical(out$z, df)

  # Evaluation path
  out <- duckplyr_mutate(df, z = (across(everything())))
  expect_identical(out$z, df)
})

test_that("if_any() and if_all() apply old `.fns = NULL` default", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = c(TRUE, FALSE, TRUE), y = c(FALSE, FALSE, TRUE))

  # Expansion path
  expect_identical(duckplyr_filter(df, if_any(everything())), df[c(1, 3),])
  expect_identical(duckplyr_filter(df, if_all(everything())), df[3,])

  # Evaluation path
  expect_identical(duckplyr_filter(df, (if_any(everything()))), df[c(1, 3),])
  expect_identical(duckplyr_filter(df, (if_all(everything()))), df[3,])
})

test_that("across errors with non-empty dots and no `.fns` supplied (#6638)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1)

  expect_snapshot(
    error = TRUE,
    duckplyr_mutate(df, across(x, .funs = ~ . * 1000))
  )
})

# dots --------------------------------------------------------------------

test_that("across(...) is deprecated", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")

  df <- tibble(x = c(1, NA))
  expect_snapshot(duckplyr_summarise(df, across(everything(), mean, na.rm = TRUE)))

})

test_that("across() passes ... to functions", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  options(lifecycle_verbosity = "quiet")

  df <- tibble(x = c(1, NA))
  expect_equal(
    duckplyr_summarise(df, across(everything(), mean, na.rm = TRUE)),
    tibble(x = 1)
  )
  expect_equal(
    duckplyr_summarise(df, across(everything(), list(mean = mean, median = median), na.rm = TRUE)),
    tibble(x_mean = 1, x_median = 1)
  )
})

test_that("across() passes unnamed arguments following .fns as ... (#4965)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  options(lifecycle_verbosity = "quiet")

  df <- tibble(x = 1)
  expect_equal(duckplyr_mutate(df, across(x, `+`, 1)), tibble(x = 2))
})

test_that("across() avoids simple argument name collisions with ... (#4965)", {
  options(lifecycle_verbosity = "quiet")

  df <- tibble(x = c(1, 2))
  expect_equal(summarize(df, across(x, tail, n = 1)), tibble(x = 2))
})


test_that("across() evaluates ... with promise semantics (#5813)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  options(lifecycle_verbosity = "quiet")

  df <- tibble(x = tibble(foo = 1), y = tibble(foo = 2))

  res <- duckplyr_mutate(df, across(
    everything(),
    mutate,
    foo = foo + 1
  ))
  expect_equal(res$x$foo, 2)
  expect_equal(res$y$foo, 3)

  # Dots are evaluated only once
  new_counter <- function() {
    n <- 0L
    function() {
      n <<- n + 1L
      n
    }
  }
  counter <- new_counter()
  list_second <- function(...) {
    list(..2)
  }
  res <- duckplyr_mutate(df, across(
    everything(),
    list_second,
    counter()
  ))
  expect_equal(res$x[[1]], 1)
  expect_equal(res$y[[1]], 1)
})


test_that("arguments in dots are evaluated once per group", {
  options(lifecycle_verbosity = "quiet")

  set.seed(0)
  out <- data.frame(g = 1:3, var = NA) %>%
    duckplyr_group_by(g) %>%
    duckplyr_mutate(across(var, function(x, y) y, rnorm(1))) %>%
    duckplyr_pull(var)

  set.seed(0)
  expect_equal(out, rnorm(3))
})

test_that("group variables are in scope when passed in dots (#5832)", {
  options(lifecycle_verbosity = "quiet")

  f <- function(x, z) x + z
  gdf <- data.frame(x = 1:2, y = 3:4, g = 1:2) %>% duckplyr_group_by(g)
  exp <- gdf %>% duckplyr_summarise(x = f(x, z = y))

  expect_equal(
    gdf %>% duckplyr_summarise(across(x, f, z = y)),
    exp
  )

  expect_equal(
    gdf %>% duckplyr_summarise((across(x, f, z = y))),
    exp
  )
})

test_that("symbols are looked up as list or functions (#6545)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(mean = 1:5)
  exp <- duckplyr_summarise(df, across(everything(), function(x) mean(x)))

  expect_equal(
    duckplyr_summarise(df, across(everything(), mean)),
    exp
  )
  expect_equal(
    duckplyr_summarise(df, (across(everything(), mean))),
    exp
  )

  exp <- duckplyr_summarise(df, across(everything(), list(function(x) mean(x))))

  expect_equal(
    summarize(df, across(everything(), list(mean))),
    exp
  )
  expect_equal(
    summarize(df, (across(everything(), list(mean)))),
    exp
  )
})

test_that("non-inlinable but maskable lambdas give precedence to function arguments", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(
    foo = 1,
    bar = "a"
  )
  out <- duckplyr_mutate(df, across(1:2, function(foo) return(foo)))
  expect_equal(out, df)
})

test_that("maskable lambdas can refer to their lexical environment", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  foo <- "OK"
  df <- tibble(bar = "a")

  # Non-inlinable
  expect_equal(
    duckplyr_mutate(df, across(1, function(x) return(paste(x, foo)))),
    tibble(bar = "a OK")
  )
  expect_equal(
    duckplyr_mutate(df, across(1, ~ return(paste(.x, foo)))),
    tibble(bar = "a OK")
  )

  # Inlinable
  expect_equal(
    duckplyr_mutate(df, across(1, function(x) paste(x, foo))),
    tibble(bar = "a OK")
  )
  expect_equal(
    duckplyr_mutate(df, across(1, ~ paste(.x, foo))),
    tibble(bar = "a OK")
  )
})
