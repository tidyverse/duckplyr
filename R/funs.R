#' @export
duck <- NULL

on_load({
  env <- environment()
  env_bind_lazy(env, duck = get_duckdb_funs())
})

new_empty_pairlist <- function(names) {
  out <- pairlist2(x = )
  out <- out[rep_along(names, 1)]
  names(out) <- names
  out
}

get_duckdb_funs <- function() {
  env <- environment()

  con <- get_default_duckdb_connection()

  funs <- DBI::dbGetQuery(con, "SELECT function_name, parameters FROM duckdb_functions()")
  # FIXME: this is a workaround for the fact that the same function can have multiple signatures
  # Unify the signatures
  funs <- funs[!duplicated(funs$function_name), ]

  imap(set_names(funs$parameters, funs$function_name), ~ {
    args <- new_empty_pairlist(.x)
    new_function(args, expr({ abort("duckdb functions are not implemented") }), env)
  })
}
