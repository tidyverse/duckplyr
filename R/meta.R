code_cache <- collections::queue()
df_cache <- collections::dict()
rel_cache <- collections::dict()

meta_clear <- function() {
  code_cache$clear()
  df_cache$clear()
  rel_cache$clear()
}

meta_record <- function(code) {
  code_cache$push(code)
  invisible()
}

meta_replay <- function() {
  con_expr <- as.list(body(create_default_duckdb_connection))
  con_expr <- con_expr[seq2(2, length(con_expr) - 1)]
  con_code <- map(con_expr, constructive::deparse_call)

  # HACK
  count <- rel_cache$size()
  res_name <- sym(paste0("rel", count))
  res_mat_expr <- expr(duckdb:::rel_to_altrep(!!res_name))
  res_code <- map(list(res_name, res_mat_expr), constructive::deparse_call)

  walk(c(con_code, code_cache$as_list(), res_code), print)
}

meta_replay_to_file <- function(path, extra = character()) {
  code <- capture.output(meta_replay())
  writeLines(c(extra, code), path)
}

meta_replay_to_new_doc <- function() {
  code <- capture.output(meta_replay())
  rstudioapi::documentNew(code, execute = TRUE)
}

meta_eval <- function() {
  code <- capture.output(meta_replay())
  eval(parse(text = code))
}

meta_df_register <- function(df) {
  if (df_cache$has(df)) {
    return(invisible(df_cache$get(df)))
  }

  count <- df_cache$size()
  name <- sym(paste0("df", count + 1))

  global_dfs <- mget(ls(.GlobalEnv), .GlobalEnv, mode = "list", ifnotfound = list(NULL))

  df_expr <- NULL
  for (df_name in names(global_dfs)) {
    global_df <- global_dfs[[df_name]]
    if (identical(df, global_df)) {
      df_expr <- sym(df_name)
      break
    }
  }

  if (is.null(df_expr)) {
    meta_record(constructive::construct_multi(list2(!!name := df)))
  } else {
    meta_record(constructive::deparse_call(expr(!!name <- !!df_expr)))
  }

  df_cache$set(df, name)
  invisible(name)
}

meta_rel_register_df <- function(rel, df) {
  df_name <- meta_df_register(df)
  rel_expr <- expr(duckdb:::rel_from_df(con, !!df_name))
  meta_rel_register(rel, rel_expr)
}

meta_rel_register <- function(rel, rel_expr) {
  force(rel_expr)

  count <- rel_cache$size()
  name <- sym(paste0("rel", count + 1))

  # https://github.com/cynkra/constructive/issues/102

  expr <- constructive::deparse_call(expr(!!name <- !!rel_expr))
  meta_record(expr)

  obj <- list(rel = rel, name = name, df = df)
  hash <- deparse(rel)

  rel_cache$set(hash, obj)
  invisible()
}

meta_rel_get <- function(rel) {
  hash <- deparse(rel)

  if (!rel_cache$has(hash)) {
    abort(
      c(
        "duckplyr: internal: hash not found",
        i = paste0("hash: ", hash),
        i = paste0("relation: ", paste(capture.output(print(rel), type = "message"), collapse = "\n"))
      )
    )
  }

  rel_cache$get(hash)
}
