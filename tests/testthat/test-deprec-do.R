# Grouped data frames ----------------------------------------------------------

df <- data.frame(
  g = c(1, 2, 2, 3, 3, 3),
  x = 1:6,
  y = 6:1
) %>% duckplyr_group_by(g)

test_that("unnamed results bound together by row", {
  first <- df %>% duckplyr_do(head(., 1))

  expect_equal(nrow(first), 3)
  expect_equal(first$g, 1:3)
  expect_equal(first$x, c(1, 2, 4))
})

test_that("named argument become list columns", {
  out <- df %>% duckplyr_do(nrow = nrow(.), ncol = ncol(.))
  expect_equal(out$nrow, list(1, 2, 3))
  # includes grouping columns
  expect_equal(out$ncol, list(3, 3, 3))
})

test_that("multiple outputs can access data (#2998)", {
  skip_if(Sys.getenv("DUCKPLYR_FORCE") == "TRUE")
  out <- duckplyr_do(tibble(a = 1), g = nrow(.), h = nrow(.))
  expect_equal(names(out), c("g", "h"))
  expect_equal(out$g, list(1L))
  expect_equal(out$h, list(1L))
})

test_that("columns in output override columns in input", {
  out <- df %>% duckplyr_do(data.frame(g = 1))
  expect_equal(names(out), "g")
  expect_equal(out$g, c(1, 1, 1))
})

test_that("empty results preserved (#597)", {
  blankdf <- function(x) data.frame(blank = numeric(0))

  dat <- data.frame(a = 1:2, b = factor(1:2))
  expect_equal(
    dat %>% duckplyr_group_by(b, .drop = FALSE) %>% duckplyr_do(blankdf(.)) %>% duckplyr_ungroup(),
    tibble(b = factor(integer(), levels = 1:2), blank = numeric())
  )
})

test_that("empty inputs give empty outputs (#597)", {
  out <- data.frame(a = numeric(), b = factor()) %>%
    duckplyr_group_by(b, .drop = FALSE) %>%
    duckplyr_do(data.frame())
  expect_equal(out, data.frame(b = factor()) %>% duckplyr_group_by(b, .drop = FALSE))

  out <- data.frame(a = numeric(), b = character()) %>%
    duckplyr_group_by(b, .drop = FALSE) %>%
    duckplyr_do(data.frame())
  expect_equal(out, data.frame(b = character()) %>% duckplyr_group_by(b, .drop = FALSE))
})

test_that("grouped do evaluates args in correct environment", {
  a <- 10
  f <- function(a) {
    mtcars %>% duckplyr_group_by(cyl) %>% duckplyr_do(a = a)
  }
  expect_equal(f(100)$a, list(100, 100, 100))
})

# Ungrouped data frames --------------------------------------------------------

test_that("ungrouped data frame with unnamed argument returns data frame", {
  out <- mtcars %>% duckplyr_do(head(.))
  expect_s3_class(out, "data.frame")
  expect_equal(dim(out), c(6, 11))
})

test_that("ungrouped data frame with named argument returns list data frame", {
  out <- mtcars %>% duckplyr_do(x = 1, y = 2:10)
  expect_s3_class(out, "tbl_df")
  expect_equal(out$x, list(1))
  expect_equal(out$y, list(2:10))
})

test_that("ungrouped do evaluates args in correct environment", {
  a <- 10
  f <- function(a) {
    mtcars %>% duckplyr_do(a = a)
  }
  expect_equal(f(100)$a, list(100))
})

# Rowwise data frames ----------------------------------------------------------

test_that("can do on rowwise dataframe", {
  out <- mtcars %>% duckplyr_rowwise() %>% duckplyr_do(x = 1)
  exp <- tibble(x =rep(list(1), nrow(mtcars))) %>% duckplyr_rowwise()
  expect_identical(out, exp)
})


# Zero row inputs --------------------------------------------------------------

test_that("empty data frames give consistent outputs", {
  dat <- tibble(x = numeric(0), g = character(0))
  grp <- dat %>% duckplyr_group_by(g)
  emt <- grp %>% duckplyr_filter(FALSE)

  dat %>%
    duckplyr_do(data.frame()) %>%
    vapply(pillar::type_sum, character(1)) %>%
    length() %>%
    expect_equal(0)
  dat %>%
    duckplyr_do(data.frame(y = integer(0))) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(y = "int"))
  dat %>%
    duckplyr_do(data.frame(.)) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(x = "dbl", g = "chr"))
  dat %>%
    duckplyr_do(data.frame(., y = integer(0))) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(x = "dbl", g = "chr", y = "int"))
  dat %>%
    duckplyr_do(y = ncol(.)) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(y = "list"))

  # Grouped data frame should have same col types as ungrouped, with addition
  # of grouping variable
  grp %>%
    duckplyr_do(data.frame()) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(g = "chr"))
  grp %>%
    duckplyr_do(data.frame(y = integer(0))) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(g = "chr", y = "int"))
  grp %>%
    duckplyr_do(data.frame(.)) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(x = "dbl", g = "chr"))
  grp %>%
    duckplyr_do(data.frame(., y = integer(0))) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(x = "dbl", g = "chr", y = "int"))
  grp %>%
    duckplyr_do(y = ncol(.)) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(g = "chr", y = "list"))

  # A empty grouped dataset should have same types as grp
  emt %>%
    duckplyr_do(data.frame()) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(g = "chr"))
  emt %>%
    duckplyr_do(data.frame(y = integer(0))) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(g = "chr", y = "int"))
  emt %>%
    duckplyr_do(data.frame(.)) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(x = "dbl", g = "chr"))
  emt %>%
    duckplyr_do(data.frame(., y = integer(0))) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(x = "dbl", g = "chr", y = "int"))
  emt %>%
    duckplyr_do(y = ncol(.)) %>%
    vapply(pillar::type_sum, character(1)) %>%
    expect_equal(c(g = "chr", y = "list"))
})

test_that("handling of empty data frames in do", {
  blankdf <- function(x) data.frame(blank = numeric(0))
  dat <- data.frame(a = 1:2, b = factor(1:2))
  res <- dat %>% duckplyr_group_by(b, .drop = FALSE) %>% duckplyr_do(blankdf(.))
  expect_equal(names(res), c("b", "blank"))
})

test_that("duckplyr_do() does not retain .drop attribute (#4176)", {
  res <- iris %>%
    duckplyr_group_by(Species) %>%
    duckplyr_do(data.frame(n=1))
  expect_null(attr(res, ".drop", exact = TRUE))
})

# Errors --------------------------------------------

test_that("duckplyr_do() gives meaningful error messages", {
  df <- data.frame(
    g = c(1, 2, 2, 3, 3, 3),
    x = 1:6,
    y = 6:1
  ) %>% duckplyr_group_by(g)

  expect_snapshot({
    (expect_error(df %>% duckplyr_do(head, tail)))

    # unnamed elements must return data frames
    (expect_error(df %>% duckplyr_ungroup() %>% duckplyr_do(1)))
    (expect_error(df %>% duckplyr_do(1)))
    (expect_error(df %>% duckplyr_do("a")))

    # can't use both named and unnamed args
    (expect_error(df %>% duckplyr_do(x = 1, 2)))
  })

})
