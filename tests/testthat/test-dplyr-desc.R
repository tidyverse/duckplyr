# Gezznezzrated by 04-dplyr-tests.R, do not edit by hand

# Workaround for lazytest
test_that("Dummy", {
  expect_true(TRUE)
})

skip_if(Sys.getenv("DUCKPLYR_SKIP_DPLYR_TESTS") == "TRUE")

test_that("errors cleanly on non-vectors", {
  expect_snapshot(desc(mean), error = TRUE)
})
