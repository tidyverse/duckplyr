% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ducktbl.R
\name{duck_tbl}
\alias{duck_tbl}
\alias{as_duck_tbl}
\alias{is_duck_tbl}
\title{duckplyr data frames}
\usage{
duck_tbl(..., .lazy = FALSE)

as_duck_tbl(x, ..., .lazy = FALSE)

is_duck_tbl(x)
}
\arguments{
\item{...}{For \code{duck_tbl()}, passed on to \code{\link[tibble:tibble]{tibble::tibble()}}.
For \code{as_duck_tbl()}, passed on to methods.}

\item{.lazy}{Logical, whether to create a lazy duckplyr frame.
If \code{TRUE}, \code{\link[dplyr:compute]{dplyr::collect()}} must be called before the data can be accessed.}

\item{x}{The object to convert or to test.}
}
\value{
For \code{duck_tbl()} and \code{as_duck_tbl()}, an object with the following classes:
\itemize{
\item \code{"lazy_duckplyr_df"} if \code{.lazy} is \code{TRUE}
\item \code{"duckplyr_df"}
\item Classes of a \link[tibble:tibble]{tibble::tibble}
}

For \code{is_duck_tbl()}, a scalar logical.
}
\description{
Data frames backed by duckplyr have a special class, \code{"duckplyr_df"},
in addition to the default classes.
This ensures that dplyr methods are dispatched correctly.
For such objects,
dplyr verbs such as \code{\link[dplyr:mutate]{dplyr::mutate()}}, \code{\link[dplyr:select]{dplyr::select()}} or \code{\link[dplyr:filter]{dplyr::filter()}}  will attempt to use DuckDB.
If this is not possible, the original dplyr implementation is used.

\code{duck_tbl()} works like \code{\link[tibble:tibble]{tibble::tibble()}}.
In contrast to dbplyr, duckplyr data frames are "eager" by default.
To avoid unwanted expensive computation, they can be converted to "lazy" duckplyr frames
on which \code{\link[dplyr:compute]{dplyr::collect()}} needs to be called explicitly.

\code{as_duck_tbl()} converts a data frame or a dplyr lazy table to a duckplyr data frame.
This is a generic function that can be overridden for custom classes.

\code{is_duck_tbl()} returns \code{TRUE} if \code{x} is a duckplyr data frame.
}
\details{
Set the \code{DUCKPLYR_FALLBACK_INFO} and \code{DUCKPLYR_FORCE} environment variables
for more control over the behavior, see \link{config} for more details.
}
\examples{
x <- duck_tbl(a = 1)
x

library(dplyr)
x \%>\%
  mutate(b = 2)

x$a

y <- duck_tbl(a = 1, .lazy = TRUE)
y
try(length(y$a))
length(collect(y)$a)
}
