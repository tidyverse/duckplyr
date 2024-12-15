test_that("head(2)", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  out <-
    ducktbl(a = 1:5) %>%
    head(2)

  expect_identical(out$a, 1:2)
})

test_that("head(-2)", {
  withr::local_envvar(DUCKPLYR_FORCE = FALSE)

  out <-
    ducktbl(a = 1:5) %>%
    head(-2)

  expect_identical(out$a, 1:3)
})

test_that("head(0)", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  out <-
    ducktbl(a = 1:5) %>%
    head(0)

  expect_identical(out$a, integer(0))
})
