start <- Sys.time()

local_options(duckdb.materialize_message = FALSE, .frame = testthat::teardown_env())

withr::local_envvar(DUCKPLYR_OUTPUT_ORDER = TRUE, .local_envir = testthat::teardown_env())

withr::defer(envir = testthat::teardown_env(), {
  writeLines("")
  stats_show()
  writeLines("")
  writeLines(format(hms::as_hms(Sys.time() - start)))
})
