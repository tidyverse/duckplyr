can_load_extension <- function(name) {
  tryCatch(
    callr::r(args = list(name), function(name) {
      con <- DBI::dbConnect(duckdb::duckdb())
      DBI::dbExecute(con, paste0("INSTALL ", name))
      DBI::dbExecute(con, paste0("LOAD ", name))
      TRUE
    }),
    error = function(e) FALSE
  )
}

on_load({
  env <- environment()
  assign("can_load_extension", memoise::memoise(can_load_extension), envir = env)
})
