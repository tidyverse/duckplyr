# Gezznezzrated by 04-dplyr-tests.R, do not edit by hand

# Workaround for lazytest
test_that("Dummy", {
  expect_true(TRUE)
})

skip_if(Sys.getenv("DUCKPLYR_SKIP_DPLYR_TESTS") == "TRUE")

test_that("as_fun_list() uses rlang auto-naming", {
  nms <- names(as_fun_list(list(min, max), env()))

  # Just check they are labellised as literals enclosed in brackets to
  # insulate from upstream changes
  expect_true(all(grepl("^<", nms)))
})
