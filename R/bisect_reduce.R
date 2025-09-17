bisect_reduce <- function(x, fun) {
  n <- length(x)
  if (n == 1) {
    return(x[[1]])
  }
  mid <- floor(n / 2)
  incl <- seq_len(mid)
  left <- bisect_reduce(x[incl], fun)
  right <- bisect_reduce(x[-incl], fun)
  fun(left, right)
}
