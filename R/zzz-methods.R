#' Forward all dplyr methods to duckplyr
#'
#' After calling `methods_overwrite()`, all dplyr methods are redirected to duckplyr
#' for the duraton of the session, or until a call to `methods_restore()`.
#'
#' @return Called for their side effects.
methods_overwrite <- methods_overwrite

#' @rdname methods_overwrite
methods_restore <- methods_restore
