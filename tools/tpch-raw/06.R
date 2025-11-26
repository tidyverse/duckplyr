qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
df1 <- lineitem
"select"
rel1 <- duckdb$rel_from_df(con, df1)
"select"
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_extendedprice")
      duckdb$expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_discount")
      duckdb$expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    }
  )
)
"filter"
rel3 <- duckdb$rel_filter(
  rel2,
  list(
    duckdb$expr_comparison(
      ">=",
      list(duckdb$expr_reference("l_shipdate"), duckdb$expr_constant(as.Date("1994-01-01")))
    ),
    duckdb$expr_comparison(
      "<",
      list(duckdb$expr_reference("l_shipdate"), duckdb$expr_constant(as.Date("1995-01-01")))
    ),
    duckdb$expr_comparison(">=", list(duckdb$expr_reference("l_discount"), duckdb$expr_constant(0.05))),
    duckdb$expr_comparison("<=", list(duckdb$expr_reference("l_discount"), duckdb$expr_constant(0.07))),
    duckdb$expr_comparison("<", list(duckdb$expr_reference("l_quantity"), duckdb$expr_constant(24)))
  )
)
"select"
rel4 <- duckdb$rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_extendedprice")
      duckdb$expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_discount")
      duckdb$expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    }
  )
)
"summarise"
rel5 <- duckdb$rel_aggregate(
  rel4,
  groups = list(),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "*",
            list(duckdb$expr_reference("l_extendedprice"), duckdb$expr_reference("l_discount"))
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
"summarise"
rel6 <- duckdb$rel_distinct(rel5)
rel6
duckdb$rel_to_altrep(rel6)
