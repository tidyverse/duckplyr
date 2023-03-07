local_options(duckdb.materialize_message = FALSE, .frame = testthat::teardown_env())

withr::local_envvar(DUCKPLYR_JOIN_OUTPUT_ORDER = TRUE, .local_envir = testthat::teardown_env())

withr::defer(envir = testthat::teardown_env(), {
  writeLines("")
  stats_show()
})
