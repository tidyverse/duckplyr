test_that("rel_to_df()", {
  expect_equal(rel_to_df(rel_from_df(data.frame(a = 1))), data.frame(a = 1))
})
