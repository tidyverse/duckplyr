test_that("can construct expressions", {
  # FIXME: Restore after https://github.com/cynkra/constructive/pull/199
  skip_on_ci()
  skip_on_cran()

  expect_snapshot({
    relexpr_reference("column")
    relexpr_constant(42)
    relexpr_function("+", list(relexpr_reference("column"), relexpr_constant(42, alias = "fortytwo")))
  })
})
