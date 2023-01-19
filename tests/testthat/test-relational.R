test_that("rel_try() with reason", {
  withr::local_envvar(TESTTHAT = "")

  expect_snapshot({
    rel_try(
      "Not affected" = FALSE,
      "Affected" = TRUE,
      {
      }
    )
  })
})
