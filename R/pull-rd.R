#' @title Extract a single column
#'
#' @description  This is a method for the [dplyr::pull()] generic.
#' See "Fallbacks" section for differences in implementation.
#' `pull()` is similar to `$`.
#' It's mostly useful because it looks a little nicer in pipes,
#' it also works with remote data frames, and it can optionally name the output.
#'
#' @inheritParams dplyr::pull
#' @seealso [dplyr::pull()]
#' @rdname pull.duckplyr_df
#' @name pull.duckplyr_df
NULL
