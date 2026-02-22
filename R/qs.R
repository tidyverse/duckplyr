qloadm <- function(file, envir = caller_env()) {
  data <- qs2::qs_read(file)
  .mapply(assign, list(names(data), data), list(pos = envir))
  invisible()
}
