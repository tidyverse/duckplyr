#' @export
select <- function(.data, ...) {
  UseMethod("select")
}

#' @export
select.duckplyr <- function(.data, ...) {
  # re-use tidyselect logic
  loc <- tidyselect::eval_select(
    dplyr::expr(c(...)),
    data = .data
  )
  rel_try(
     "Can't use relational with zero-column result set." = (length(loc) == 0),
     {

      # create duckdb expressions
      exprs <- mapply(function(name, alias) {
          expr <- duckdb:::expr_reference(name)
          duckdb:::expr_set_alias(expr, alias)
          expr
        }, names(.data)[loc], names(loc), SIMPLIFY=FALSE)
      # perform actual projection
      # TODO this clunky and can probably be generified

      if (rel_is_lazy(.data)) {
        rel <- duckdb:::rel_from_altrep_df(.data)
      } else {
        rel <- duckdb:::rel_from_df(get_default_duckdb_connection(), .data)
      }

      out_rel <- duckdb:::rel_project(rel, exprs)
      # TODO this can probably be generified
      out <- duckdb:::rel_to_altrep(out_rel)
      class(out) <- c("duckplyr", class(out))
        return(out)
     }, fallback = {
       out <- dplyr:::select.data.frame(.data, ...)
       class(out) <- c("duckplyr", class(out))
     }
   )
}

