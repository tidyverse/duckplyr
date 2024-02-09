test_that("can construct expressions", {
  skip_on_cran()

  expect_snapshot({
    relexpr_reference("column")
    relexpr_constant(42)
    relexpr_function("+", list(relexpr_reference("column"), relexpr_constant(42, alias = "fortytwo")))
  })
})

test_that(".env pronoun works", {
  withr::local_envvar(DUCKPLYR_FORCE = TRUE)

  a <- 2
  data <- data.frame(a = 1)
  out <- data %>% as_duckplyr_df() %>% mutate(b = .env$a)
  expect_equal(out, data.frame(a = 1, b = 2) %>% as_duckplyr_df())
})
