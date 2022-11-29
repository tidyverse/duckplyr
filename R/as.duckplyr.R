#' @export
as.duckplyr <- function(.data, ...) {
	class(.data) <- c("duckplyr", class(.data))
	.data
}

