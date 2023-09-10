#' Forward all dplyr methods to duckplyr
#'
#' After calling `methods_overwrite()`, all dplyr methods are redirected to duckplyr
#' for the duraton of the session, or until a call to `methods_restore()`.
#'
#' @return Called for their side effects.
#' @aliases methods_restore
"methods_overwrite"
