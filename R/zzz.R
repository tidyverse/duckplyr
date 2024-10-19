.onLoad <- function(lib, pkg) {
  run_on_load()
}

.onAttach <- function(lib, pkg) {
  if (!exists(".__DEVTOOLS__", asNamespace("duckplyr"))) {
    msg <- character()
    try_fetch(methods_overwrite(), message = function(cond) {
      msg <<- c(msg, conditionMessage(cond))
      zap()
    })
    packageStartupMessage(msg)
  }
}

.onDetach <- function(lib) {
  if (!exists(".__DEVTOOLS__", asNamespace("duckplyr"))) {
    msg <- character()
    try_fetch(methods_restore(), message = function(cond) {
      msg <<- c(msg, conditionMessage(cond))
      zap()
    })
    packageStartupMessage(msg)
  }
}
