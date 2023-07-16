test_that("can construct expressions", {
  expect_snapshot({
    relexpr_reference("column")
    relexpr_constant(42)
    relexpr_function("+", list(relexpr_reference("column"), relexpr_constant(42, alias = "fortytwo")))
  })
})
