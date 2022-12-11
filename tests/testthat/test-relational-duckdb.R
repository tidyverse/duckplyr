test_that("rel_aggregate()", {
  local_options(duckdb.materialize_message = FALSE)

  expr_species <- relexpr_reference("species")
  expr_aggregate <- relexpr_function(alias = "mean_bill_length_mm", "avg", list(
    relexpr_reference("bill_length_mm")
  ))

  grouped <-
    palmerpenguins::penguins %>%
    as_duckplyr_df() %>%
    duckdb_rel_from_df() %>%
    rel_aggregate(list(expr_species), list(expr_aggregate))

  ungrouped <-
    palmerpenguins::penguins %>%
    as_duckplyr_df() %>%
    duckdb_rel_from_df() %>%
    rel_aggregate(list(), list(expr_aggregate))

  expect_snapshot({
    grouped %>%
      rel_to_df()
    ungrouped %>%
      rel_to_df()
  })
})
