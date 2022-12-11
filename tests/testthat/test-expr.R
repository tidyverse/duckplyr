test_that("can construct expressions", {
  expect_snapshot({
    expr_reference("column")
    expr_constant(42)
    expr_function("+", list(expr_reference("column"), expr_constant(42, alias = "fortytwo")))
  })
})
