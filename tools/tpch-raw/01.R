load("tools/tpch/001.rda")
con <- DBI::dbConnect(duckdb::duckdb())
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(a, b) AS a < b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(a, b) AS a <= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">\"(a, b) AS a > b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"!=\"(a, b) AS a <> b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"is.na\"(a) AS (a IS NULL)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n\"() AS (COUNT(*))"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"sum\"(x) AS (CASE WHEN SUM(x) IS NULL THEN 0 ELSE SUM(x) END)")
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"log10\"(x) AS log(x)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"log\"(x) AS ln(x)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"grepl\"(pattern, x) AS regexp_matches(x, pattern)")
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.integer\"(x) AS CAST(x AS int32)"))
invisible(
  DBI::dbExecute(
    con,
    "CREATE MACRO \"ifelse\"(test, yes, no) AS (CASE WHEN test THEN yes ELSE no END)"
  )
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"|\"(x, y) AS (x OR y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"&\"(x, y) AS (x AND y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"!\"(x) AS (NOT x)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"any\"(x) AS (bool_or(x))"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"desc\"(x) AS (-x)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n_distinct\"(x) AS (COUNT(DISTINCT x))"))
invisible(
  DBI::dbExecute(
    con,
    "CREATE MACRO \"___eq_na_matches_na\"(a, b) AS ((a IS NULL AND b IS NULL) OR (a = b))"
  )
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
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
      tmp_expr <- duckdb:::expr_reference("l_returnflag")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linestatus")
      duckdb:::expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb:::expr_reference("l_tax")
      duckdb:::expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    }
  )
)
rel3 <- duckdb:::rel_filter(
  rel2,
  list(
    duckdb:::expr_function(
      "<=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1998-09-02"))))
    )
  )
)
rel4 <- duckdb:::rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_returnflag")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linestatus")
      duckdb:::expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb:::expr_reference("l_tax")
      duckdb:::expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    }
  )
)
rel5 <- duckdb:::rel_aggregate(
  rel4,
  list(duckdb:::expr_reference("l_returnflag"), duckdb:::expr_reference("l_linestatus")),
  list(
    sum_qty = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_quantity")))
      duckdb:::expr_set_alias(tmp_expr, "sum_qty")
      tmp_expr
    },
    sum_base_price = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_extendedprice")))
      duckdb:::expr_set_alias(tmp_expr, "sum_base_price")
      tmp_expr
    },
    sum_disc_price = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_reference("l_extendedprice"),
              duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "sum_disc_price")
      tmp_expr
    },
    sum_charge = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_function(
                "*",
                list(
                  duckdb:::expr_reference("l_extendedprice"),
                  duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
                )
              ),
              duckdb:::expr_function("+", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_tax")))
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "sum_charge")
      tmp_expr
    },
    avg_qty = {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_quantity")))
      duckdb:::expr_set_alias(tmp_expr, "avg_qty")
      tmp_expr
    },
    avg_price = {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_extendedprice")))
      duckdb:::expr_set_alias(tmp_expr, "avg_price")
      tmp_expr
    },
    avg_disc = {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_discount")))
      duckdb:::expr_set_alias(tmp_expr, "avg_disc")
      tmp_expr
    },
    count_order = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "count_order")
      tmp_expr
    }
  )
)
rel6 <- duckdb:::rel_order(
  rel5,
  list(duckdb:::expr_reference("l_returnflag"), duckdb:::expr_reference("l_linestatus"))
)
rel6
duckdb:::rel_to_altrep(rel6)
