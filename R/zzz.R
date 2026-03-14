# Bump to 3.0.0 "long enough" before releasing duckdb 2.0.0
on_load({
  if (
    getNamespaceInfo("duckdb", "spec")[["version"]] >=
      as.package_version("2.0.0")
  ) {
    cli::cli_abort(c(
      "This version of {.pkg duckplyr} does not support {.pkg duckdb} >= 2.0.0.",
      i = "Please upgrade to a more recent version of {.pkg duckplyr}."
    ))
  }
})

.onLoad <- function(lib, pkg) {
  run_on_load()
}

# Avoid R CMD check warning
dummy <- function() {
  memoise::memoise()
}
