start <- Sys.time()

withr::local_envvar(DUCKPLYR_FALLBACK_COLLECT = 0, .local_envir = testthat::teardown_env())

withr::local_envvar(DUCKPLYR_OUTPUT_ORDER = TRUE, .local_envir = testthat::teardown_env())

# withr::local_envvar(DUCKPLYR_TELEMETRY_PREP_TEST = TRUE, .local_envir = testthat::teardown_env())

# withr::local_envvar(DUCKPLYR_FORCE = TRUE, .local_envir = testthat::teardown_env())

withr::defer(envir = testthat::teardown_env(), {
  writeLines("")
  stats_show()
  writeLines("")
  if (is_installed("hms")) {
    writeLines(format(hms::as_hms(Sys.time() - start)))
  }
})
