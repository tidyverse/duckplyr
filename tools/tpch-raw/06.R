load("tools/tpch/001.rda")
con <- DBI::dbConnect(duckdb::duckdb())
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(a, b) AS a < b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(a, b) AS a <= b"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"sum\"(x) AS (CASE WHEN SUM(x) IS NULL THEN 0 ELSE SUM(x) END)")
)
df1 <- lineitem
rel1 <- duckdb:::rel_from_df(con, df1)
rel2 <- duckdb:::rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    }
  )
)
rel3 <- duckdb:::rel_filter(
  rel2,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1994-01-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-01-01"))))
    ),
    duckdb:::expr_function(">=", list(duckdb:::expr_reference("l_discount"), duckdb:::expr_constant(0.05))),
    duckdb:::expr_function("<=", list(duckdb:::expr_reference("l_discount"), duckdb:::expr_constant(0.07))),
    duckdb:::expr_function("<", list(duckdb:::expr_reference("l_quantity"), duckdb:::expr_constant(24)))
  )
)
rel4 <- duckdb:::rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    }
  )
)
rel5 <- duckdb:::rel_aggregate(
  rel4,
  list(),
  list(
    revenue = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(duckdb:::expr_reference("l_extendedprice"), duckdb:::expr_reference("l_discount"))
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel5
duckdb:::rel_to_altrep(rel5)
