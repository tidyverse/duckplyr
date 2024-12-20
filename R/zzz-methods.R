#' Forward all dplyr methods to duckplyr
#'
#' After calling `methods_overwrite()`, all dplyr methods are redirected to duckplyr
#' for the duraton of the session, or until a call to `methods_restore()`.
#' The `methods_overwrite()` function is called automatically when the package is loaded
#' if the environment variable `DUCKPLYR_METHODS_OVERWRITE` is set to `TRUE`.
#'
#' @return Called for their side effects.
#' @export
#' @examples
#' tibble(a = 1:3) %>%
#'   mutate(b = a + 1)
#'
#' methods_overwrite()
#'
#' tibble(a = 1:3) %>%
#'   mutate(b = a + 1)
#'
#' methods_restore()
#'
#' tibble(a = 1:3) %>%
#'   mutate(b = a + 1)
methods_overwrite <- function() {
  cli::cli_inform(
    c(
      v = "Overwriting {.pkg dplyr} methods with {.pkg duckplyr} methods.",
      i = "Turn off with {.run duckplyr::methods_restore()}."
    )
  )
  methods_overwrite_impl()
}

#' @rdname methods_overwrite
#' @export
methods_restore <- function() {
  cli::cli_inform(c(i = "Restoring {.pkg dplyr} methods."))
  methods_restore_impl()
}
