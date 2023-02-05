df <- data.frame(x = 0)

rel <- relational::duckdb_rel_from_df(df)
# exprs <- purrr::map2("x", "x", ~ relational::expr_reference(.x, alias = .y))
# out_rel <- relational::rel_project(rel, exprs)
#
# out <- relational::rel_to_df(out_rel)
#
# gc()
