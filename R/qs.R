qloadm <- function(file, envir = caller_env()) {
  data <- qs::qread(file)
  .mapply(assign, list(names(data), data), list(pos = envir))
  invisible()
}
