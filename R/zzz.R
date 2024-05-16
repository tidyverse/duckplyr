.onLoad <- function(lib, pkg) {
  run_on_load()
}

.onAttach <- function(lib, pkg) {
  if (!exists(".__DEVTOOLS__", asNamespace("duckplyr"))) {
    msg <- tryCatch(methods_overwrite(), message = conditionMessage)
    packageStartupMessage(msg)
  }
}

.onDetach <- function(lib) {
  if (!exists(".__DEVTOOLS__", asNamespace("duckplyr"))) {
    msg <- tryCatch(methods_restore(), message = conditionMessage)
    packageStartupMessage(msg)
  }
}
