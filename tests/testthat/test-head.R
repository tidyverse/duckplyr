test_that("head(2)", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  out <-
    data.frame(a = 1:5) %>%
    duckplyr::as_duckplyr_df() %>%
    head(2)

  expect_identical(out$a, 1:2)
})

test_that("head(-2)", {
  withr::local_envvar(DUCKPLYR_FORCE = FALSE)

  out <-
    data.frame(a = 1:5) %>%
    duckplyr::as_duckplyr_df() %>%
    head(-2)

  expect_identical(out$a, 1:3)
})

test_that("head(0)", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  out <-
    data.frame(a = 1:5) %>%
    duckplyr::as_duckplyr_df() %>%
    head(0)

  expect_identical(out$a, integer(0))
})
