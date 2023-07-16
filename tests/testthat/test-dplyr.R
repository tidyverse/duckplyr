test_that("no homonyms", {
  # FIXME: Why does this fail on R-devel?
  skip_if(getRversion() >= "4.4.0")

  dplyr <- asNamespace("dplyr")
  duckplyr <- asNamespace("duckplyr")

  names_dplyr <- ls(dplyr)
  names_duckplyr <- ls(duckplyr)

  names_common <- intersect(names_dplyr, names_duckplyr)
  # Allow overwriting
  names_common <- setdiff(names_common, c("dplyr_reconstruct", "dplyr_reconstruct.data.frame"))
  names_common

  objs_dplyr <- mget(names_common, dplyr)
  objs_duckplyr <- mget(names_common, duckplyr)

  expect_identical(objs_duckplyr, objs_dplyr[names(objs_duckplyr)])
})
