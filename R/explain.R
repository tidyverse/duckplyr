#' @export
explain <- function(x, ...) {
  UseMethod("explain")
}

#' @export
explain.duckplyr <- function(x, ...) {
   rel_try(
     {

       rel <- duckdb:::rel_from_altrep_df(x)

       duckdb:::rel_explain(rel)
     },
     fallback = {
       writeLines("Can't convert to relational, fallback implementation will be used.")
     }
   )
   invisible()
 }
