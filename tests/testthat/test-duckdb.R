test_that("case-insensitive duplicates", {
  out <- duckdb_tibble(a = 1:2) %>%
    mutate(A = a + 1L, b = A - 1L)

  expect_identical(out$a, out$b)
})

test_that("contains_window_expr() works", {
  # A plain column reference: no window
  ref <- relexpr_reference("a")
  expect_false(duckplyr:::contains_window_expr(ref))

  # A plain function: no window
  fn <- relexpr_function("sum", list(relexpr_reference("a")))
  expect_false(duckplyr:::contains_window_expr(fn))

  # A window expression: yes
  win <- relexpr_window(relexpr_function("sum", list(relexpr_reference("a"))), list(), list())
  expect_true(duckplyr:::contains_window_expr(win))

  # A function wrapping a window expression: yes
  wrapped <- relexpr_function("r_base::as.integer", list(win))
  expect_true(duckplyr:::contains_window_expr(wrapped))

  # NULL: no
  expect_false(duckplyr:::contains_window_expr(NULL))
})

test_that("mutate() uses oo_prep only when window functions are present", {
  withr::local_envvar(DUCKPLYR_OUTPUT_ORDER = "TRUE")

  df <- duckdb_tibble(a = 1:3, b = c(1, 1, 2))

  # Non-window expression: ___row_number should not appear
  rel_simple <- duckplyr:::duckdb_rel_from_df(df)
  rel_simple <- duckplyr:::oo_prep(rel_simple, force = FALSE)
  expect_false("___row_number" %in% duckplyr:::rel_names(rel_simple))

  # Window expression path goes through oo_prep: ___row_number appears
  rel_prepped <- duckplyr:::duckdb_rel_from_df(df)
  rel_prepped <- duckplyr:::oo_prep(rel_prepped, force = TRUE)
  expect_true("___row_number" %in% duckplyr:::rel_names(rel_prepped))

  # Full mutate with window function: result should be intact
  out <- df |> mutate(n = n(), .by = b)
  r <- collect(out)
  # group b==1 has 2 rows, group b==2 has 1 row
  expect_identical(r$n[r$b == 1], c(2L, 2L))
  expect_identical(r$n[r$b == 2], c(1L))
})
