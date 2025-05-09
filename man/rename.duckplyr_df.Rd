% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rename-rd.R, R/rename.R
\name{rename.duckplyr_df}
\alias{rename.duckplyr_df}
\title{Rename columns}
\usage{
\method{rename}{duckplyr_df}(.data, ...)
}
\arguments{
\item{.data}{A data frame, data frame extension (e.g. a tibble), or a
lazy data frame (e.g. from dbplyr or dtplyr). See \emph{Methods}, below, for
more details.}

\item{...}{For \code{rename()}: <\code{\link[dplyr:dplyr_tidy_select]{tidy-select}}> Use
\code{new_name = old_name} to rename selected variables.

For \code{rename_with()}: additional arguments passed onto \code{.fn}.}
}
\description{
This is a method for the \code{\link[dplyr:rename]{dplyr::rename()}} generic.
See "Fallbacks" section for differences in implementation.
\code{rename()} changes the names of individual variables
using \code{new_name = old_name} syntax.
}
\section{Fallbacks}{

There is no DuckDB translation in \code{rename.duckplyr_df()}
\itemize{
\item with a selection that returns no columns.
}

These features fall back to \code{\link[dplyr:rename]{dplyr::rename()}}, see \code{vignette("fallback")} for details.
}

\examples{
library(duckplyr)
rename(mtcars, thing = mpg)
}
\seealso{
\code{\link[dplyr:rename]{dplyr::rename()}}
}
