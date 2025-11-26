# Bump to 3.0.0 "long enough" before releasing duckdb 2.0.0
on_load({
  if (getNamespaceInfo("duckdb", "spec")[["version"]] >= as.package_version("2.0.0")) {
    cli::cli_abort(c(
      "This version of {.pkg duckplyr} does not support {.pkg duckdb} >= 2.0.0.",
      i = "Please upgrade to a more recent version of {.pkg duckplyr}."
    ))
  }
})

.onLoad <- function(lib, pkg) {
  run_on_load()
}

.onAttach <- function(lib, pkg) {
  if (!exists(".__DEVTOOLS__", asNamespace("duckplyr"))) {
    msg <- character()
    suppressMessages(try_fetch(methods_overwrite(), message = function(cond) {
      msg <<- c(msg, conditionMessage(cond))
      zap()
    }))
    packageStartupMessage(msg)
  }
}

.onDetach <- function(lib) {
  if (!exists(".__DEVTOOLS__", asNamespace("duckplyr"))) {
    msg <- character()
    suppressMessages(try_fetch(methods_restore(), message = function(cond) {
      msg <<- c(msg, conditionMessage(cond))
      zap()
    }))
    packageStartupMessage(msg)
  }
}

# Avoid R CMD check warning
dummy <- function() {
  memoise::memoise()
}
