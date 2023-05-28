qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(a, b) AS a <= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n\"() AS (COUNT(*))"))
df1 <- lineitem
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
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
      list(
        duckdb:::expr_reference("l_shipdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1998-09-02", experimental = experimental)
            } else {
              duckdb:::expr_constant("1998-09-02")
            }
          )
        )
      )
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
  groups = list(duckdb:::expr_reference("l_returnflag"), duckdb:::expr_reference("l_linestatus")),
  aggregates = list(
    {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_quantity")))
      duckdb:::expr_set_alias(tmp_expr, "sum_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_extendedprice")))
      duckdb:::expr_set_alias(tmp_expr, "sum_base_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_reference("l_extendedprice"),
              duckdb:::expr_function(
                "-",
                list(
                  if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                    duckdb:::expr_constant(1, experimental = experimental)
                  } else {
                    duckdb:::expr_constant(1)
                  },
                  duckdb:::expr_reference("l_discount")
                )
              )
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "sum_disc_price")
      tmp_expr
    },
    {
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
                  duckdb:::expr_function(
                    "-",
                    list(
                      if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                        duckdb:::expr_constant(1, experimental = experimental)
                      } else {
                        duckdb:::expr_constant(1)
                      },
                      duckdb:::expr_reference("l_discount")
                    )
                  )
                )
              ),
              duckdb:::expr_function(
                "+",
                list(
                  if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                    duckdb:::expr_constant(1, experimental = experimental)
                  } else {
                    duckdb:::expr_constant(1)
                  },
                  duckdb:::expr_reference("l_tax")
                )
              )
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "sum_charge")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_quantity")))
      duckdb:::expr_set_alias(tmp_expr, "avg_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_extendedprice")))
      duckdb:::expr_set_alias(tmp_expr, "avg_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_discount")))
      duckdb:::expr_set_alias(tmp_expr, "avg_disc")
      tmp_expr
    },
    {
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
