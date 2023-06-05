qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"|\"(x, y) AS (x OR y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(a, b) AS a < b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(
  DBI::dbExecute(
    con,
    "CREATE MACRO \"ifelse\"(test, yes, no) AS (CASE WHEN test THEN yes ELSE no END)"
  )
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"&\"(x, y) AS (x AND y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"!=\"(a, b) AS a <> b"))
df1 <- lineitem
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_filter(
  rel1,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "==",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("MAIL", experimental = experimental)
            } else {
              duckdb:::expr_constant("MAIL")
            },
            duckdb:::expr_reference("l_shipmode")
          )
        ),
        duckdb:::expr_function(
          "==",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("SHIP", experimental = experimental)
            } else {
              duckdb:::expr_constant("SHIP")
            },
            duckdb:::expr_reference("l_shipmode")
          )
        )
      )
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_commitdate"), duckdb:::expr_reference("l_receiptdate"))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_reference("l_commitdate"))
    ),
    duckdb:::expr_function(
      ">=",
      list(
        duckdb:::expr_reference("l_receiptdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1994-01-01", experimental = experimental)
            } else {
              duckdb:::expr_constant("1994-01-01")
            }
          )
        )
      )
    ),
    duckdb:::expr_function(
      "<",
      list(
        duckdb:::expr_reference("l_receiptdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1995-01-01", experimental = experimental)
            } else {
              duckdb:::expr_constant("1995-01-01")
            }
          )
        )
      )
    )
  )
)
rel3 <- duckdb:::rel_set_alias(rel2, "lhs")
df2 <- orders
rel4 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel5 <- duckdb:::rel_set_alias(rel4, "rhs")
rel6 <- duckdb:::rel_join(
  rel3,
  rel5,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel3), duckdb:::expr_reference("o_orderkey", rel5))
    )
  ),
  "inner"
)
rel7 <- duckdb:::rel_project(
  rel6,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_orderkey", rel3), duckdb:::expr_reference("o_orderkey", rel5))
      )
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linenumber")
      duckdb:::expr_set_alias(tmp_expr, "l_linenumber")
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
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_commitdate")
      duckdb:::expr_set_alias(tmp_expr, "l_commitdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_receiptdate")
      duckdb:::expr_set_alias(tmp_expr, "l_receiptdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipinstruct")
      duckdb:::expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipmode")
      duckdb:::expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_comment")
      duckdb:::expr_set_alias(tmp_expr, "l_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderstatus")
      duckdb:::expr_set_alias(tmp_expr, "o_orderstatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_totalprice")
      duckdb:::expr_set_alias(tmp_expr, "o_totalprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderpriority")
      duckdb:::expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_clerk")
      duckdb:::expr_set_alias(tmp_expr, "o_clerk")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_comment")
      duckdb:::expr_set_alias(tmp_expr, "o_comment")
      tmp_expr
    }
  )
)
rel8 <- duckdb:::rel_aggregate(
  rel7,
  groups = list(duckdb:::expr_reference("l_shipmode")),
  aggregates = list(
    {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "ifelse",
            list(
              duckdb:::expr_function(
                "|",
                list(
                  duckdb:::expr_function(
                    "==",
                    list(
                      duckdb:::expr_reference("o_orderpriority"),
                      if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                        duckdb:::expr_constant("1-URGENT", experimental = experimental)
                      } else {
                        duckdb:::expr_constant("1-URGENT")
                      }
                    )
                  ),
                  duckdb:::expr_function(
                    "==",
                    list(
                      duckdb:::expr_reference("o_orderpriority"),
                      if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                        duckdb:::expr_constant("2-HIGH", experimental = experimental)
                      } else {
                        duckdb:::expr_constant("2-HIGH")
                      }
                    )
                  )
                )
              ),
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant(1L, experimental = experimental)
              } else {
                duckdb:::expr_constant(1L)
              },
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant(0L, experimental = experimental)
              } else {
                duckdb:::expr_constant(0L)
              }
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "high_line_count")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "ifelse",
            list(
              duckdb:::expr_function(
                "&",
                list(
                  duckdb:::expr_function(
                    "!=",
                    list(
                      duckdb:::expr_reference("o_orderpriority"),
                      if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                        duckdb:::expr_constant("1-URGENT", experimental = experimental)
                      } else {
                        duckdb:::expr_constant("1-URGENT")
                      }
                    )
                  ),
                  duckdb:::expr_function(
                    "!=",
                    list(
                      duckdb:::expr_reference("o_orderpriority"),
                      if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                        duckdb:::expr_constant("2-HIGH", experimental = experimental)
                      } else {
                        duckdb:::expr_constant("2-HIGH")
                      }
                    )
                  )
                )
              ),
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant(1L, experimental = experimental)
              } else {
                duckdb:::expr_constant(1L)
              },
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant(0L, experimental = experimental)
              } else {
                duckdb:::expr_constant(0L)
              }
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "low_line_count")
      tmp_expr
    }
  )
)
rel9 <- duckdb:::rel_order(rel8, list(duckdb:::expr_reference("l_shipmode")))
rel9
duckdb:::rel_to_altrep(rel9)
