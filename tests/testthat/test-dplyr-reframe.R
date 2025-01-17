test_that("`duckplyr_reframe()` allows summaries", {
  df <- tibble(g = c(1, 1, 1, 2, 2), x = 1:5)

  expect_identical(
    duckplyr_reframe(df, x = mean(x)),
    tibble(x = 3)
  )
  expect_identical(
    duckplyr_reframe(df, x = mean(x), .by = g),
    tibble(g = c(1, 2), x = c(2, 4.5))
  )
})

test_that("`duckplyr_reframe()` allows size 0 results", {
  df <- tibble(g = c(1, 1, 1, 2, 2), x = 1:5)
  gdf <- duckplyr_group_by(df, g)

  expect_identical(
    duckplyr_reframe(df, x = which(x > 5)),
    tibble(x = integer())
  )
  expect_identical(
    duckplyr_reframe(df, x = which(x > 5), .by = g),
    tibble(g = double(), x = integer())
  )
  expect_identical(
    duckplyr_reframe(gdf, x = which(x > 5)),
    tibble(g = double(), x = integer())
  )
})

test_that("`duckplyr_reframe()` allows size >1 results", {
  df <- tibble(g = c(1, 1, 1, 2, 2), x = 1:5)
  gdf <- duckplyr_group_by(df, g)

  expect_identical(
    duckplyr_reframe(df, x = which(x > 2)),
    tibble(x = 3:5)
  )
  expect_identical(
    duckplyr_reframe(df, x = which(x > 2), .by = g),
    tibble(g = c(1, 2, 2), x = c(3L, 1L, 2L))
  )
  expect_identical(
    duckplyr_reframe(gdf, x = which(x > 2)),
    tibble(g = c(1, 2, 2), x = c(3L, 1L, 2L))
  )
})

test_that("`duckplyr_reframe()` recycles across columns", {
  df <- tibble(g = c(1, 1, 2, 2, 2), x = 1:5)

  out <- duckplyr_reframe(df, a = 1:2, b = 1L, c = 2:3)
  expect_identical(out$a, 1:2)
  expect_identical(out$b, c(1L, 1L))
  expect_identical(out$c, 2:3)

  out <- duckplyr_reframe(df, a = 1:2, b = 1L, c = 2:3, .by = g)
  expect_identical(out$g, c(1, 1, 2, 2))
  expect_identical(out$a, c(1:2, 1:2))
  expect_identical(out$b, c(1L, 1L, 1L, 1L))
  expect_identical(out$c, c(2:3, 2:3))
})

test_that("`duckplyr_reframe()` can recycle across columns to size 0", {
  df <- tibble(g = 1:2, x = 1:2)
  gdf <- duckplyr_group_by(df, g)

  out <- duckplyr_reframe(df, y = mean(x), z = which(x > 3))
  expect_identical(out$y, double())
  expect_identical(out$z, integer())

  out <- duckplyr_reframe(df, y = mean(x), z = which(x > 1), .by = g)
  expect_identical(out$g, 2L)
  expect_identical(out$y, 2)
  expect_identical(out$z, 1L)

  out <- duckplyr_reframe(gdf, y = mean(x), z = which(x > 1))
  expect_identical(out$g, 2L)
  expect_identical(out$y, 2)
  expect_identical(out$z, 1L)
})

test_that("`duckplyr_reframe()` throws intelligent recycling errors", {
  df <- tibble(g = 1:2, x = 1:2)
  gdf <- duckplyr_group_by(df, g)

  expect_snapshot(error = TRUE, {
    duckplyr_reframe(df, x = 1:2, y = 3:5)
  })
  expect_snapshot(error = TRUE, {
    duckplyr_reframe(df, x = 1:2, y = 3:5, .by = g)
  })
  expect_snapshot(error = TRUE, {
    duckplyr_reframe(gdf, x = 1:2, y = 3:5)
  })
})

test_that("`duckplyr_reframe()` can return more rows than the original data frame", {
  df <- tibble(x = 1:2)

  expect_identical(
    duckplyr_reframe(df, x = vec_rep_each(x, x)),
    tibble(x = c(1L, 2L, 2L))
  )
})

test_that("`duckplyr_reframe()` doesn't message about regrouping when multiple group columns are supplied", {
  df <- tibble(a = c(1, 1, 2, 2, 2), b = c(1, 2, 1, 1, 2), x = 1:5)
  gdf <- duckplyr_group_by(df, a, b)

  # Silence
  expect_snapshot({
    out <- duckplyr_reframe(df, x = mean(x), .by = c(a, b))
  })
  expect_snapshot({
    out <- duckplyr_reframe(gdf, x = mean(x))
  })
})

test_that("`duckplyr_reframe()` doesn't message about regrouping when >1 rows are returned per group", {
  df <- tibble(g = c(1, 1, 2, 2, 2), x = 1:5)
  gdf <- duckplyr_group_by(df, g)

  # Silence
  expect_snapshot({
    out <- duckplyr_reframe(df, x = vec_rep_each(x, x), .by = g)
  })
  expect_snapshot({
    out <- duckplyr_reframe(gdf, x = vec_rep_each(x, x))
  })
})

test_that("`duckplyr_reframe()` allows sequential assignments", {
  df <- tibble(g = 1:2, x = 1:2)

  expect_identical(
    duckplyr_reframe(df, y = 3, z = mean(x) + y),
    tibble(y = 3, z = 4.5)
  )
  expect_identical(
    duckplyr_reframe(df, y = 3, z = mean(x) + y, .by = g),
    tibble(g = 1:2, y = c(3, 3), z = c(4, 5))
  )
})

test_that("`duckplyr_reframe()` allows for overwriting existing columns", {
  df <- tibble(g = c("a", "b"), x = 1:2)

  expect_identical(
    duckplyr_reframe(df, x = 3, z = x),
    tibble(x = 3, z = 3)
  )
  expect_identical(
    duckplyr_reframe(df, x = cur_group_id(), z = x, .by = g),
    tibble(g = c("a", "b"), x = 1:2, z = 1:2)
  )
})

test_that("`duckplyr_reframe()` works with unquoted values", {
  df <- tibble(x = 1:5)
  expect_equal(duckplyr_reframe(df, out = !!1), tibble(out = 1))
  expect_equal(duckplyr_reframe(df, out = !!quo(1)), tibble(out = 1))
  expect_equal(duckplyr_reframe(df, out = !!(1:2)), tibble(out = 1:2))
})

test_that("`duckplyr_reframe()` with bare data frames always returns a bare data frame", {
  df <- data.frame(g = c(1, 1, 2, 1, 2), x = c(5, 2, 1, 2, 3))

  out <- duckplyr_reframe(df, x = mean(x))
  expect_s3_class(out, class(df), exact = TRUE)

  out <- duckplyr_reframe(df, x = mean(x), .by = g)
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("`duckplyr_reframe()` drops data frame attributes", {
  # Because `duckplyr_reframe()` theoretically creates a "new" data frame

  # With data.frames
  df <- data.frame(g = c(1, 1, 2), x = c(1, 2, 1))
  attr(df, "foo") <- "bar"

  out <- duckplyr_reframe(df, x = mean(x))
  expect_null(attr(out, "foo"))

  out <- duckplyr_reframe(df, x = mean(x), .by = g)
  expect_null(attr(out, "foo"))

  # With tibbles
  tbl <- as_tibble(df)
  attr(tbl, "foo") <- "bar"

  out <- duckplyr_reframe(tbl, x = mean(x))
  expect_null(attr(out, "foo"))

  out <- duckplyr_reframe(tbl, x = mean(x), .by = g)
  expect_null(attr(out, "foo"))

  # With grouped_df
  gdf <- duckplyr_group_by(df, g)
  attr(gdf, "foo") <- "bar"

  out <- duckplyr_reframe(gdf, x = mean(x))
  expect_null(attr(out, "foo"))
})

test_that("`duckplyr_reframe()` with `duckplyr_group_by()` sorts keys", {
  df <- tibble(g = c(2, 1, 2, 0), x = c(4, 2, 8, 5))
  df <- duckplyr_group_by(df, g)

  out <- duckplyr_reframe(df, x = mean(x))

  expect_identical(out$g, c(0, 1, 2))
  expect_identical(out$x, c(5, 2, 6))
})

test_that("`duckplyr_reframe()` with `duckplyr_group_by()` respects `.drop = FALSE`", {
  g <- factor(c("c", "a", "c"), levels = c("a", "b", "c"))

  df <- tibble(g = g, x = c(1, 4, 2))
  gdf <- duckplyr_group_by(df, g, .drop = FALSE)

  out <- duckplyr_reframe(gdf, x = mean(x))

  expect_identical(out$g, factor(c("a", "b", "c")))
  expect_identical(out$x, c(4, NaN, 1.5))
})

test_that("`duckplyr_reframe()` with `duckplyr_group_by()` always returns an ungrouped tibble", {
  df <- tibble(a = c(1, 1, 2, 2, 2), b = c(1, 2, 1, 1, 2), x = 1:5)
  gdf <- duckplyr_group_by(df, a, b)

  out <- duckplyr_reframe(gdf, x = mean(x))
  expect_identical(class(out), class(df))
})

test_that("`duckplyr_reframe()` with `duckplyr_rowwise()` respects list-col element access", {
  df <- tibble(x = list(1:2, 3:5, 6L))
  rdf <- duckplyr_rowwise(df)

  expect_identical(
    duckplyr_reframe(rdf, x),
    tibble(x = 1:6)
  )
})

test_that("`duckplyr_reframe()` with `duckplyr_rowwise()` respects rowwise group columns", {
  df <- tibble(g = c(1, 1, 2), x = list(1:2, 3:5, 6L))
  rdf <- duckplyr_rowwise(df, g)

  out <- duckplyr_reframe(rdf, x)
  expect_identical(out$g, c(rep(1, 5), 2))
  expect_identical(out$x, 1:6)
})

test_that("`duckplyr_reframe()` with `duckplyr_rowwise()` always returns an ungrouped tibble", {
  df <- tibble(g = c(1, 1, 2), x = list(1:2, 3:5, 6L))
  rdf <- duckplyr_rowwise(df, g)

  expect_s3_class(duckplyr_reframe(rdf, x), class(df), exact = TRUE)
})

# .by ----------------------------------------------------------------------

test_that("can group transiently using `.by`", {
  df <- tibble(g = c(1, 1, 2, 1, 2), x = c(5, 2, 1, 2, 3))

  out <- duckplyr_reframe(df, x = mean(x), .by = g)

  expect_identical(out$g, c(1, 2))
  expect_identical(out$x, c(3, 2))
  expect_s3_class(out, class(df), exact = TRUE)
})

test_that("transient grouping orders by first appearance", {
  df <- tibble(g = c(2, 1, 2, 0), x = c(4, 2, 8, 5))

  out <- duckplyr_reframe(df, x = mean(x), .by = g)

  expect_identical(out$g, c(2, 1, 0))
  expect_identical(out$x, c(6, 2, 5))
})

test_that("catches `.by` with grouped-df", {
  df <- tibble(x = 1)
  gdf <- duckplyr_group_by(df, x)

  expect_snapshot(error = TRUE, {
    duckplyr_reframe(gdf, .by = x)
  })
})

test_that("catches `.by` with rowwise-df", {
  df <- tibble(x = 1)
  rdf <- duckplyr_rowwise(df)

  expect_snapshot(error = TRUE, {
    duckplyr_reframe(rdf, .by = x)
  })
})
