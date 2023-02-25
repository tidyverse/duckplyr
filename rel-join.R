partsupp <- tibble::tibble(
  ps_partkey = integer(0),
  ps_suppkey = integer(0),
)

part <- tibble::tibble(
  p_partkey = integer(0),
)

supplier <- tibble::tibble(
  s_suppkey = integer(0),
  s_nationkey = integer(0),
)

nation <- tibble::tibble(
  n_nationkey = integer(0),
  n_regionkey = integer(0),
)

region <- tibble::tibble(
  r_regionkey = integer(0),
)

con <- DBI::dbConnect(duckdb::duckdb())
DBI::dbExecute(con, 'CREATE MACRO "=="(a, b) AS a = b')

rel_partsupp <- duckdb:::rel_from_df(con, partsupp)
rel_part <- duckdb:::rel_from_df(con, part)
rel_supplier <- duckdb:::rel_from_df(con, supplier)
rel_nation <- duckdb:::rel_from_df(con, nation)
rel_region <- duckdb:::rel_from_df(con, region)

join_expr_psp <- duckdb:::expr_function(
  "==", list(duckdb:::expr_reference("ps_partkey"), duckdb:::expr_reference("p_partkey"))
)

proj_expr_psp <- list(
  duckdb:::expr_reference("ps_partkey"),
  duckdb:::expr_reference("ps_suppkey"),
  duckdb:::expr_reference("p_partkey")
)

rel_psp <-
  duckdb:::rel_join(
    duckdb:::rel_set_alias(rel_partsupp, "lhs"),
    duckdb:::rel_set_alias(rel_part, "rhs"),
    list(join_expr_psp)
  ) |>
  duckdb:::rel_project(proj_expr_psp)

join_expr_psps <- duckdb:::expr_function(
  "==", list(duckdb:::expr_reference("ps_suppkey"), duckdb:::expr_reference("s_suppkey"))
)

proj_expr_psps <- c(
  proj_expr_psp, list(
  duckdb:::expr_reference("s_suppkey"),
  duckdb:::expr_reference("s_nationkey")
))

rel_psps <-
  duckdb:::rel_join(
    duckdb:::rel_set_alias(rel_psp, "lhs"),
    duckdb:::rel_set_alias(rel_supplier, "rhs"),
    list(join_expr_psps)
  ) |>
  duckdb:::rel_project(proj_expr_psps)

join_expr_nr <- duckdb:::expr_function(
  "==", list(duckdb:::expr_reference("n_regionkey"), duckdb:::expr_reference("r_regionkey"))
)

proj_expr_nr <- list(
  duckdb:::expr_reference("n_nationkey"),
  duckdb:::expr_reference("n_regionkey"),
  duckdb:::expr_reference("r_regionkey")
)

rel_nr <-
  duckdb:::rel_join(
    duckdb:::rel_set_alias(rel_nation, "lhs"),
    duckdb:::rel_set_alias(rel_region, "rhs"),
    list(join_expr_nr)
  ) |>
  duckdb:::rel_project(proj_expr_nr)

join_expr_out <- duckdb:::expr_function(
  "==", list(duckdb:::expr_reference("s_nationkey"), duckdb:::expr_reference("n_nationkey"))
)

duckdb:::rel_join(
  duckdb:::rel_set_alias(rel_psps, "lhs"),
  duckdb:::rel_set_alias(rel_nr, "rhs"),
  list(join_expr_out)
)

# duckplyr equivalent:

# psp <- duckplyr_inner_join(partsupp, part, by = c("ps_partkey" = "p_partkey"), keep = TRUE)
# psps <- duckplyr_inner_join(psp, supplier, by = c("ps_suppkey" = "s_suppkey"), keep = TRUE)
# nr <- duckplyr_inner_join(nation, region, by = c("n_regionkey" = "r_regionkey"), keep = TRUE)
# duckplyr_inner_join(psps, nr, by = c("s_nationkey" = "n_nationkey"), keep = TRUE)
