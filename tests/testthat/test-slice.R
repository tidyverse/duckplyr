test_that("empty slice drops all rows (#6573)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(1, 1, 2), x = 1:3)
  gdf <- duckplyr_group_by(df, g)
  rdf <- duckplyr_rowwise(df)

  expect_identical(duckplyr_slice(df), df[integer(),])
  expect_identical(duckplyr_slice(gdf), gdf[integer(),])
  expect_identical(duckplyr_slice(rdf), rdf[integer(),])
})

test_that("slicing data.frame yields data.frame", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x = 1:3)
  expect_equal(duckplyr_slice(df, 1), data.frame(x = 1L))
})

test_that("slice keeps positive indices, ignoring out of range (#226)", {
  gf <- duckplyr_group_by(tibble(g = c(1, 2, 2, 3, 3, 3), id = 1:6), g)

  out <- duckplyr_slice(gf, 1)
  expect_equal(out$id, c(1, 2, 4))

  out <- duckplyr_slice(gf, 2)
  expect_equal(out$id, c(3, 5))
})

test_that("slice drops negative indices, ignoring out of range (#3073)", {
  gf <- duckplyr_group_by(tibble(g = c(1, 2, 2, 3, 3, 3), id = 1:6), g)

  out <- duckplyr_slice(gf, -1)
  expect_equal(out$id, c(3, 5, 6))

  out <- duckplyr_slice(gf, -(1:2))
  expect_equal(out$id, 6)
})

test_that("slice errors if positive and negative indices mixed", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_snapshot(error = TRUE, {
    duckplyr_slice(tibble(), 1, -1)
  })
})

test_that("slice ignores 0 and NA (#3313, #1235)", {
  gf <- duckplyr_group_by(tibble(g = c(1, 2, 2, 3, 3, 3), id = 1:6), g)

  out <- duckplyr_slice(gf, 0)
  expect_equal(out$id, integer())
  out <- duckplyr_slice(gf, 0, 1)
  expect_equal(out$id, c(1, 2, 4))

  out <- duckplyr_slice(gf, NA)
  expect_equal(out$id, integer())
  out <- duckplyr_slice(gf, NA, -1)
  expect_equal(out$id, c(3, 5, 6))
})

test_that("slicing with one-column matrix is deprecated", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(1, 2, 2, 3, 3, 3), id = 1:6)

  expect_snapshot({
    out <- duckplyr_slice(df, matrix(c(1, 3)))
  })
  expect_equal(out$id, c(1, 3))
})

test_that("slice errors if index is not numeric", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_snapshot(error = TRUE, {
    duckplyr_slice(tibble(), "a")
  })
})

test_that("slice preserves groups iff requested", {
  gf <- duckplyr_group_by(tibble(g = c(1, 2, 2, 3, 3, 3), id = 1:6), g)

  out <- duckplyr_slice(gf, 2, 3)
  expect_equal(duckplyr_group_keys(out), tibble(g = c(2, 3)))
  expect_equal(group_rows(out), list_of(1, c(2, 3)))

  out <- duckplyr_slice(gf, 2, 3, .preserve = TRUE)
  expect_equal(duckplyr_group_keys(out), tibble(g = c(1, 2, 3)))
  expect_equal(group_rows(out), list_of(integer(), 1, c(2, 3)))
})

test_that("slice handles zero-row and zero-column inputs (#1219, #2490)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = numeric())
  expect_equal(duckplyr_slice(df, 1), df)

  df <- tibble(.rows = 10)
  expect_equal(duckplyr_slice(df, 1), tibble(.rows = 1))
})

test_that("user errors are correctly labelled", {
  df <- tibble(x = 1:3)
  expect_snapshot(error = TRUE, {
    duckplyr_slice(df, 1 + "")
    duckplyr_slice(duckplyr_group_by(df, x), 1 + "")
  })
})

test_that("`...` can't be named (#6554)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = 1, x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_slice(df, 1, foo = g)
  })
})

test_that("slice keeps zero length groups", {
  df <- tibble(
    e = 1,
    f = factor(c(1, 1, 2, 2), levels = 1:3),
    g = c(1, 1, 2, 2),
    x = c(1, 2, 1, 4)
  )
  df <- duckplyr_group_by(df, e, f, g, .drop = FALSE)

  expect_equal(duckplyr_group_size(duckplyr_slice(df, 1)), c(1, 1, 0) )
})

test_that("slicing retains labels for zero length groups", {
  df <- tibble(
    e = 1,
    f = factor(c(1, 1, 2, 2), levels = 1:3),
    g = c(1, 1, 2, 2),
    x = c(1, 2, 1, 4)
  )
  df <- duckplyr_group_by(df, e, f, g, .drop = FALSE)

  expect_equal(
    duckplyr_ungroup(duckplyr_count(duckplyr_slice(df, 1))),
    tibble(
      e = 1,
      f = factor(1:3),
      g = c(1, 2, NA),
      n = c(1L, 1L, 0L)
    )
  )
})

test_that("can group transiently using `.by`", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(1, 1, 2), x = c(1, 2, 3))

  out <- duckplyr_slice(df, n(), .by = g)

  expect_identical(out$g, c(1, 2))
  expect_identical(out$x, c(2, 3))
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping retains bare data.frame class", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(1, 1, 2), x = c(1, 2, 3))
  out <- duckplyr_slice(df, n(), .by = g)
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping retains data frame attributes", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # With data.frames or tibbles
  df <- data.frame(g = c(1, 1, 2), x = c(1, 2, 3))
  tbl <- as_tibble(df)

  attr(df, "foo") <- "bar"
  attr(tbl, "foo") <- "bar"

  out <- duckplyr_slice(df, n(), .by = g)
  expect_identical(attr(out, "foo"), "bar")

  out <- duckplyr_slice(tbl, n(), .by = g)
  expect_identical(attr(out, "foo"), "bar")
})

test_that("transient grouping orders by first appearance", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(2, 1, 2, 0), x = c(4, 2, 8, 5))

  out <- duckplyr_slice(df, which(x == max(x)), .by = g)

  expect_identical(out$g, c(2, 1, 0))
  expect_identical(out$x, c(8, 2, 5))
})

test_that("can't use `.by` with `.preserve`", {
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_slice(df, .by = x, .preserve = TRUE)
  })
})

test_that("catches `.by` with grouped-df", {
  df <- tibble(x = 1)
  gdf <- duckplyr_group_by(df, x)

  expect_snapshot(error = TRUE, {
    duckplyr_slice(gdf, .by = x)
  })
})

test_that("catches `.by` with rowwise-df", {
  df <- tibble(x = 1)
  rdf <- duckplyr_rowwise(df)

  expect_snapshot(error = TRUE, {
    duckplyr_slice(rdf, .by = x)
  })
})

test_that("catches `by` typo (#6647)", {
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_slice(df, by = x)
  })
})

# Slice variants ----------------------------------------------------------

test_that("slice_helpers() call get_slice_size()", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_slice_head(df, n = "a")
    duckplyr_slice_tail(df, n = "a")
    slice_min(df, x, n = "a")
    slice_max(df, x, n = "a")
    duckplyr_slice_sample(df, n= "a")
  })
})

test_that("get_slice_size() validates its inputs", {
  expect_snapshot(error = TRUE, {
    get_slice_size(n = 1, prop = 1)
    get_slice_size(n = "a")
    get_slice_size(prop = "a")
  })
})

test_that("get_slice_size() snapshots", {
  expect_snapshot({
    body(get_slice_size(prop = 0))

    body(get_slice_size(prop = 0.4))
    body(get_slice_size(prop = 2))
    body(get_slice_size(prop = 2, allow_outsize = TRUE))

    body(get_slice_size(prop = -0.4))
    body(get_slice_size(prop = -2))

    body(get_slice_size(n = 0))

    body(get_slice_size(n = 4))
    body(get_slice_size(n = 20))
    body(get_slice_size(n = 20, allow_outsize = TRUE))

    body(get_slice_size(n = -4))
    body(get_slice_size(n = -20))
  })
})

test_that("get_slice_size() standardises prop", {
  expect_equal(get_slice_size(prop = 0)(10), 0)

  expect_equal(get_slice_size(prop = 0.4)(10), 4)
  expect_equal(get_slice_size(prop = 2)(10), 10)
  expect_equal(get_slice_size(prop = 2, allow_outsize = TRUE)(10), 20)

  expect_equal(get_slice_size(prop = -0.4)(10), 6)
  expect_equal(get_slice_size(prop = -2)(10), 0)
})

test_that("get_slice_size() standardises n", {
  expect_equal(get_slice_size(n = 0)(10), 0)

  expect_equal(get_slice_size(n = 4)(10), 4)
  expect_equal(get_slice_size(n = 20)(10), 10)
  expect_equal(get_slice_size(n = 20, allow_outsize = TRUE)(10), 20)

  expect_equal(get_slice_size(n = -4)(10), 6)
  expect_equal(get_slice_size(n = -20)(10), 0)
})

test_that("get_slice_size() rounds prop in the right direction", {
  expect_equal(get_slice_size(prop = 0.16)(10), 1)
  expect_equal(get_slice_size(prop = -0.16)(10), 9)
})

test_that("n must be an integer", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:5)
  expect_snapshot(duckplyr_slice_head(df, n = 1.1), error = TRUE)
})

test_that("functions silently truncate results", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # only test positive n because get_slice_size() converts all others

  df <- tibble(x = 1:5)
  expect_equal(nrow(duckplyr_slice_head(df, n = 6)), 5)
  expect_equal(nrow(duckplyr_slice_tail(df, n = 6)), 5)
  expect_equal(nrow(slice_min(df, x, n = 6)), 5)
  expect_equal(nrow(slice_max(df, x, n = 6)), 5)
  expect_equal(nrow(duckplyr_slice_sample(df, n = 6)), 5)
})

test_that("slice helpers with n = 0 return no rows", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:5)
  expect_equal(nrow(duckplyr_slice_head(df, n = 0)), 0)
  expect_equal(nrow(duckplyr_slice_tail(df, n = 0)), 0)
  expect_equal(nrow(slice_min(df, x, n = 0)), 0)
  expect_equal(nrow(slice_max(df, x, n = 0)), 0)
  expect_equal(nrow(duckplyr_slice_sample(df, n = 0)), 0)
})

test_that("slice_*() doesn't look for `n` in data (#6089)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(x = 1:10, n = 10:1, g = rep(1:2, each = 5))
  expect_error(slice_max(df, order_by = n), NA)
  expect_error(slice_min(df, order_by = n), NA)
  expect_error(duckplyr_slice_sample(df, weight_by = n, n = 1L), NA)

  df <- duckplyr_group_by(df, g)
  expect_error(slice_max(df, order_by = n), NA)
  expect_error(slice_min(df, order_by = n), NA)
  expect_error(duckplyr_slice_sample(df, weight_by = n, n = 1L), NA)
})

test_that("slice_*() checks that `n=` is explicitly named and ... is empty", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # i.e. that every function calls check_slice_dots()
  df <- data.frame(x = 1:10)

  expect_snapshot(error = TRUE, {
    duckplyr_slice_head(df, 5)
    duckplyr_slice_tail(df, 5)
    slice_min(df, x, 5)
    slice_max(df, x, 5)
    duckplyr_slice_sample(df, 5)
  })

  # And works with namespace prefix (#6946)
  expect_snapshot(error = TRUE, {
    dplyr::duckplyr_slice_head(df, 5)
    dplyr::duckplyr_slice_tail(df, 5)
    dplyr::slice_min(df, x, 5)
    dplyr::slice_max(df, x, 5)
    dplyr::duckplyr_slice_sample(df, 5)
  })

  expect_snapshot(error = TRUE, {
    duckplyr_slice_head(df, 5, 2)
    duckplyr_slice_tail(df, 5, 2)
    slice_min(df, x, 5, 2)
    slice_max(df, x, 5, 2)
    duckplyr_slice_sample(df, 5, 2)
  })
})

test_that("slice_helpers do call duckplyr_slice() and benefit from dispatch (#6084)", {
  local_methods(
    slice.noisy = function(.data, ..., .preserve = FALSE) {
      warning("noisy")
      NextMethod()
    }
  )

  nf <- tibble(x = 1:10, g = rep(1:2, each = 5)) %>% duckplyr_group_by(g)
  class(nf) <- c("noisy", class(nf))

  expect_warning(duckplyr_slice(nf, 1:2), "noisy")
  expect_warning(duckplyr_slice_sample(nf, n = 2), "noisy")
  expect_warning(duckplyr_slice_head(nf, n = 2), "noisy")
  expect_warning(duckplyr_slice_tail(nf, n = 2), "noisy")
  expect_warning(slice_min(nf, x, n = 2), "noisy")
  expect_warning(slice_max(nf, x, n = 2), "noisy")
  expect_warning(sample_n(nf, 2), "noisy")
  expect_warning(sample_frac(nf, .5), "noisy")
})

test_that("slice_helper `by` errors use correct error context and correct `by_arg`", {
  df <- tibble(x = 1)
  gdf <- duckplyr_group_by(df, x)

  expect_snapshot(error = TRUE, {
    duckplyr_slice_head(gdf, n = 1, by = x)
    duckplyr_slice_tail(gdf, n = 1, by = x)
    slice_min(gdf, order_by = x, by = x)
    slice_max(gdf, order_by = x, by = x)
    duckplyr_slice_sample(gdf, n = 1, by = x)
  })
})

test_that("slice_helper catches `.by` typo (#6647)", {
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    duckplyr_slice_head(df, n = 1, .by = x)
    duckplyr_slice_tail(df, n = 1, .by = x)
    slice_min(df, order_by = x, .by = x)
    slice_max(df, order_by = x, .by = x)
    duckplyr_slice_sample(df, n = 1, .by = x)
  })
})

# slice_min/slice_max -----------------------------------------------------

test_that("min and max return ties by default", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(id = 1:5, x = c(1, 1, 1, 2, 2))
  expect_equal(slice_min(df, x)$id, c(1, 2, 3))
  expect_equal(slice_max(df, x)$id, c(4, 5))

  expect_equal(slice_min(df, x, with_ties = FALSE)$id, 1)
  expect_equal(slice_max(df, x, with_ties = FALSE)$id, 4)
})

test_that("min and max reorder results", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- data.frame(id = 1:4, x = c(2, 3, 1, 2))

  expect_equal(slice_min(df, x, n = 2)$id, c(3, 1, 4))
  expect_equal(slice_max(df, x, n = 2)$id, c(2, 1, 4))

  expect_equal(slice_min(df, x, n = 2, with_ties = FALSE)$id, c(3, 1))
  expect_equal(slice_max(df, x, n = 2, with_ties = FALSE)$id, c(2, 1))
})

test_that("min and max include NAs when appropriate", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(id = 1:3, x = c(1, NA, NA))
  expect_equal(slice_min(df, x, n = 1)$id, 1)
  expect_equal(slice_max(df, x, n = 1)$id, 1)

  expect_equal(slice_min(df, x, n = 2)$id, c(1, 2, 3))
  expect_equal(slice_min(df, x, n = 2, with_ties = FALSE)$id, c(1, 2))

  df <- tibble(id = 1:4, x = NA)
  expect_equal(slice_min(df, x, n = 2, na_rm = TRUE)$id, integer())
  expect_equal(slice_max(df, x, n = 2, na_rm = TRUE)$id, integer())
})

test_that("min and max ignore NA's when requested (#4826)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(id = 1:4, x = c(2, NA, 1, 2))
  expect_equal(slice_min(df, x, n = 2, na_rm = TRUE)$id, c(3, 1, 4))
  expect_equal(slice_max(df, x, n = 2, na_rm = TRUE)$id, c(1, 4))

  # Check with list to confirm use full vctrs support
  df <- tibble(id = 1:4, x = list(NULL, 1, NULL, NULL))
  expect_equal(slice_min(df, x, n = 2, na_rm = TRUE)$id, 2)
  expect_equal(slice_max(df, x, n = 2, na_rm = TRUE)$id, 2)

  # Drop when any element is missing
  df <- tibble(id = 1:3, a = c(1, 2, NA), b = c(2, NA, NA))
  expect_equal(slice_min(df, tibble(a, b), n = 3, na_rm = TRUE)$id, 1)
  expect_equal(slice_max(df, tibble(a, b), n = 3, na_rm = TRUE)$id, 1)
})

test_that("slice_min/max() count from back with negative n/prop", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(id = 1:4, x = c(2, 3, 1, 4))
  expect_equal(slice_min(df, x, n = -1), slice_min(df, x, n = 3))
  expect_equal(slice_max(df, x, n = -1), slice_max(df, x, n = 3))

  # and can be larger than group size
  expect_equal(slice_min(df, x, n = -10), df[0, ])
  expect_equal(slice_max(df, x, n = -10), df[0, ])
})

test_that("slice_min/max() can order by multiple variables (#6176)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(id = 1:4, x = 1, y = c(1, 4, 2, 3))
  expect_equal(slice_min(df, tibble(x, y), n = 1)$id, 1)
  expect_equal(slice_max(df, tibble(x, y), n = 1)$id, 2)
})

test_that("slice_min/max() work with `by`", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(2, 2, 1, 1), x = c(1, 2, 3, 1))

  expect_identical(slice_min(df, x, by = g), df[c(1, 4),])
  expect_identical(slice_max(df, x, by = g), df[c(2, 3),])
})

test_that("slice_min/max() inject `with_ties` and `na_rm` (#6725)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # So columns named `with_ties` and `na_rm` don't mask those arguments

  df <- tibble(x = c(1, 1, 2, 2), with_ties = 1:4)

  expect_identical(slice_min(df, x, n = 1), vec_slice(df, 1:2))
  expect_identical(slice_min(df, x, n = 1, with_ties = FALSE), vec_slice(df, 1))

  expect_identical(slice_max(df, x, n = 1), vec_slice(df, 3:4))
  expect_identical(slice_max(df, x, n = 1, with_ties = FALSE), vec_slice(df, 3))

  df <- tibble(x = c(1, NA), na_rm = 1:2)

  expect_identical(slice_min(df, x, n = 2), df)
  expect_identical(slice_min(df, x, n = 2, na_rm = TRUE), vec_slice(df, 1))

  expect_identical(slice_max(df, x, n = 2), df)
  expect_identical(slice_max(df, x, n = 2, na_rm = TRUE), vec_slice(df, 1))
})

test_that("slice_min/max() check size of `order_by=` (#5922)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  expect_snapshot(error = TRUE, {
    slice_min(data.frame(x = 1:10), 1:6)
    slice_max(data.frame(x = 1:10), 1:6)
  })
})

test_that("slice_min/max() validate simple arguments", {
  expect_snapshot(error = TRUE, {
    slice_min(data.frame(x = 1:10))
    slice_max(data.frame(x = 1:10))

    slice_min(data.frame(x = 1:10), x, with_ties = 1)
    slice_max(data.frame(x = 1:10), x, with_ties = 1)

    slice_min(data.frame(x = 1:10), x, na_rm = 1)
    slice_max(data.frame(x = 1:10), x, na_rm = 1)
  })
})

# slice_sample ------------------------------------------------------------

test_that("duckplyr_slice_sample() respects weight_by and replaces", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:100, wt = c(1, rep(0, 99)))

  out <- duckplyr_slice_sample(df, n = 1, weight_by = wt)
  expect_equal(out$x, 1)

  out <- duckplyr_slice_sample(df, n = 2, weight_by = wt, replace = TRUE)
  expect_equal(out$x, c(1, 1))
})

test_that("duckplyr_slice_sample() can increase rows iff replace = TRUE", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:10)
  expect_equal(nrow(duckplyr_slice_sample(df, n = 20, replace = FALSE)), 10)
  expect_equal(nrow(duckplyr_slice_sample(df, n = 20, replace = TRUE)), 20)
})

test_that("duckplyr_slice_sample() checks size of `weight_by=` (#5922)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1:10)
  expect_snapshot(duckplyr_slice_sample(df, n = 2, weight_by = 1:6), error = TRUE)
})

test_that("duckplyr_slice_sample() works with zero-row data frame (#5729)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = character(), w = numeric())
  out <- duckplyr_slice_sample(df, prop = 0.5, weight_by = w)
  expect_equal(out, df)
})

test_that("`duckplyr_slice_sample()` validates `replace`", {
  df <- tibble()
  expect_snapshot(error = TRUE, {
    duckplyr_slice_sample(df, replace = 1)
    duckplyr_slice_sample(df, replace = NA)
  })
})

test_that("duckplyr_slice_sample() injects `replace` (#6725)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  # So a column named `replace` doesn't mask that argument
  df <- tibble(replace = 1)
  expect_identical(duckplyr_slice_sample(df, n = 2), df)
  expect_identical(duckplyr_slice_sample(df, n = 2, replace = TRUE), vec_slice(df, c(1, 1)))
})

test_that("duckplyr_slice_sample() handles positive n= and prop=", {
  gf <- duckplyr_group_by(tibble(a = 1, b = 1), a)
  expect_equal(duckplyr_slice_sample(gf, n = 3, replace = TRUE), gf[c(1, 1, 1), ])
  expect_equal(duckplyr_slice_sample(gf, prop = 3, replace = TRUE), gf[c(1, 1, 1), ])
})

test_that("duckplyr_slice_sample() handles negative n= and prop= (#6402)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(a = 1:2)
  expect_equal(nrow(duckplyr_slice_sample(df, n = -1)), 1)
  expect_equal(nrow(duckplyr_slice_sample(df, prop = -0.5)), 1)

  # even if larger than n
  expect_equal(nrow(duckplyr_slice_sample(df, n = -3)), 0)
  expect_equal(nrow(duckplyr_slice_sample(df, prop = -2)), 0)
})

test_that("duckplyr_slice_sample() works with `by`", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(2, 2, 2, 1), x = c(1, 2, 3, 1))
  expect_identical(duckplyr_slice_sample(df, n = 2, by = g)$g, c(2, 2, 1))
})

# slice_head/slice_tail ---------------------------------------------------

test_that("slice_head/slice_tail keep positive values", {
  gf <- duckplyr_group_by(tibble(g = c(1, 2, 2, 3, 3, 3), id = 1:6), g)

  expect_equal(duckplyr_slice_head(gf, n = 1)$id, c(1, 2, 4))
  expect_equal(duckplyr_slice_head(gf, n = 2)$id, c(1, 2, 3, 4, 5))

  expect_equal(duckplyr_slice_tail(gf, n = 1)$id, c(1, 3, 6))
  expect_equal(duckplyr_slice_tail(gf, n = 2)$id, c(1, 2, 3, 5, 6))
})

test_that("slice_head/tail() count from back with negative n/prop", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(id = 1:4, x = c(2, 3, 1, 4))
  expect_equal(duckplyr_slice_head(df, n = -1), duckplyr_slice_head(df, n = 3))
  expect_equal(duckplyr_slice_tail(df, n = -1), duckplyr_slice_tail(df, n = 3))

  # and can be larger than group size
  expect_equal(duckplyr_slice_head(df, n = -10), df[0, ])
  expect_equal(duckplyr_slice_tail(df, n = -10), df[0, ])
})

test_that("slice_head/slice_tail drop from opposite end when n/prop negative", {
  gf <- duckplyr_group_by(tibble(g = c(1, 2, 2, 3, 3, 3), id = 1:6), g)

  expect_equal(duckplyr_slice_head(gf, n = -1)$id, c(2, 4, 5))
  expect_equal(duckplyr_slice_head(gf, n = -2)$id, 4)

  expect_equal(duckplyr_slice_tail(gf, n = -1)$id, c(3, 5, 6))
  expect_equal(duckplyr_slice_tail(gf, n = -2)$id, 6)
})

test_that("slice_head/slice_tail handle infinite n/prop", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(x = 1)
  expect_identical(duckplyr_slice_head(df, n = Inf), df)
  expect_identical(duckplyr_slice_tail(df, n = Inf), df)
  expect_identical(duckplyr_slice_head(df, n = -Inf), df[0, ])
  expect_identical(duckplyr_slice_tail(df, n = -Inf), df[0, ])

  expect_identical(duckplyr_slice_head(df, prop = Inf), df)
  expect_identical(duckplyr_slice_tail(df, prop = Inf), df)
  expect_identical(duckplyr_slice_head(df, prop = -Inf), df[0, ])
  expect_identical(duckplyr_slice_tail(df, prop = -Inf), df[0, ])
})

test_that("slice_head/slice_tail work with `by`", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  df <- tibble(g = c(2, 2, 2, 1), x = c(1, 2, 3, 1))
  expect_identical(duckplyr_slice_head(df, n = 2, by = g), df[c(1, 2, 4),])
  expect_identical(duckplyr_slice_tail(df, n = 2, by = g), df[c(2, 3, 4),])
})
