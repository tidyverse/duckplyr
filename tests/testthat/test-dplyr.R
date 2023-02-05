test_that("no homonyms", {
  dplyr <- asNamespace("dplyr")
  duckplyr <- asNamespace("duckplyr")

  names_dplyr <- ls(dplyr)
  names_duckplyr <- ls(duckplyr)

  names_common <- intersect(names_dplyr, names_duckplyr)
  # Allow overwriting
  names_common <- setdiff(names_common, "dplyr_reconstruct")
  names_common

  objs_dplyr <- mget(names_common, dplyr)
  objs_duckplyr <- mget(names_common, duckplyr)

  same <- purrr::map2_lgl(objs_dplyr, objs_duckplyr, identical)
  expect_snapshot({
    names_common[!same]
  })
})
