qloadm <- function(file, envir = caller_env()) {
  data <- qs::qread(file)
  mapply(FUN = assign, names(data), data, MoreArgs = list(pos = envir))
}
