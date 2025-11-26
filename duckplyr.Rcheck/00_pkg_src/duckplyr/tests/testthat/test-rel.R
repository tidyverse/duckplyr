test_that("new_relational() creates relational objects", {
  expect_s3_class(new_relational(list()), "relational")
})

test_that("rel_from_df() creates a data frame", {
  expect_s3_class(rel_from_df(data.frame(a = 1)), "relational")
})

test_that("rel_from_df() fails with bogus input", {
  expect_error(rel_from_df("bogus"))
})
