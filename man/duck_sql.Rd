% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sql.R
\name{duck_sql}
\alias{duck_sql}
\title{Return SQL query as duck_tbl}
\usage{
duck_sql(sql, ..., lazy = TRUE, con = NULL)
}
\arguments{
\item{sql}{The SQL to run.}

\item{...}{These dots are for future extensions and must be empty.}

\item{lazy}{Logical, whether to create a lazy duckplyr frame.
If \code{TRUE} (the default), \code{\link[dplyr:compute]{dplyr::collect()}} must be called before the data can be accessed.}

\item{con}{The connection, defaults to the default connection.}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

Runs a query and returns it as a duckplyr frame.
}
\details{
Using data frames from the calling environment is not supported yet,
see \url{https://github.com/duckdb/duckdb-r/issues/645} for details.
}
\examples{
duck_sql("FROM duckdb_settings()")
}
\seealso{
\code{\link[=duck_exec]{duck_exec()}}
}
