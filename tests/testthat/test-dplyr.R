test_that("no homonyms", {
  skip_if(identical(Sys.getenv("R_COVR"), "true"))

  dplyr <- asNamespace("dplyr")
  duckplyr <- asNamespace("duckplyr")

  names_dplyr <- ls(dplyr)
  names_duckplyr <- ls(duckplyr)

  names_common <- intersect(names_dplyr, names_duckplyr)
  names_common <- setdiff(names_common, c("DataMask", "the"))

  objs_dplyr <- mget(names_common, dplyr)
  objs_duckplyr <- mget(names_common, duckplyr)

  expect_identical(objs_duckplyr, objs_dplyr[names(objs_duckplyr)])
})
