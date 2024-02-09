#' Install duckdb extension
#'
#' This package requires a duckdb extension to be installed.
#' These function give control over the installation process.
#' The installation is tied to the R installation.
#'
#' @param force Force installation.
#' @export
#' @examples
#' if (FALSE) {
#'   ext_install(force = TRUE)
#' }
ext_install <- function(force = FALSE) {
  con <- DBI::dbConnect(duckdb::duckdb(config = list("allow_unsigned_extensions" = "true")))
  on.exit(DBI::dbDisconnect(con))

  do_ext_install(con, force)
  invisible()
}

sql_ext_install <- "INSTALL 'rfuns' FROM 'http://duckdb-rfuns.s3.us-east-1.amazonaws.com'"

do_ext_install <- function(con, force = FALSE) {
  DBI::dbExecute(con, paste0(if (isTRUE(force)) "FORCE ", sql_ext_install))
}

sql_ext_load <- "LOAD 'rfuns'"
