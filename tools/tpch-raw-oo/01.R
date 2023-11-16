qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(x, y) AS x <= y"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n\"() AS CAST(COUNT(*) AS int32)"))
df1 <- lineitem
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb$expr_reference("l_tax")
      duckdb$expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    }
  )
)
rel3 <- duckdb$rel_project(
  rel2,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb$expr_reference("l_tax")
      duckdb$expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel4 <- duckdb$rel_filter(
  rel3,
  list(
    duckdb$expr_function(
      "<=",
      list(
        duckdb$expr_reference("l_shipdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1998-09-02"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1998-09-02"))
        }
      )
    )
  )
)
rel5 <- duckdb$rel_order(rel4, list(duckdb$expr_reference("___row_number")))
rel6 <- duckdb$rel_project(
  rel5,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb$expr_reference("l_tax")
      duckdb$expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    }
  )
)
rel7 <- duckdb$rel_project(
  rel6,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb$expr_reference("l_tax")
      duckdb$expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    }
  )
)
rel8 <- duckdb$rel_project(
  rel7,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb$expr_reference("l_tax")
      duckdb$expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel9 <- duckdb$rel_aggregate(
  rel8,
  groups = list(duckdb$expr_reference("l_returnflag"), duckdb$expr_reference("l_linestatus")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("___row_number")))
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("sum", list(duckdb$expr_reference("l_quantity")))
      duckdb$expr_set_alias(tmp_expr, "sum_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("sum", list(duckdb$expr_reference("l_extendedprice")))
      duckdb$expr_set_alias(tmp_expr, "sum_base_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "*",
            list(
              duckdb$expr_reference("l_extendedprice"),
              duckdb$expr_function(
                "-",
                list(
                  if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                    duckdb$expr_constant(1, experimental = experimental)
                  } else {
                    duckdb$expr_constant(1)
                  },
                  duckdb$expr_reference("l_discount")
                )
              )
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "sum_disc_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "*",
            list(
              duckdb$expr_function(
                "*",
                list(
                  duckdb$expr_reference("l_extendedprice"),
                  duckdb$expr_function(
                    "-",
                    list(
                      if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                        duckdb$expr_constant(1, experimental = experimental)
                      } else {
                        duckdb$expr_constant(1)
                      },
                      duckdb$expr_reference("l_discount")
                    )
                  )
                )
              ),
              duckdb$expr_function(
                "+",
                list(
                  if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                    duckdb$expr_constant(1, experimental = experimental)
                  } else {
                    duckdb$expr_constant(1)
                  },
                  duckdb$expr_reference("l_tax")
                )
              )
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "sum_charge")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("mean", list(duckdb$expr_reference("l_quantity")))
      duckdb$expr_set_alias(tmp_expr, "avg_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("mean", list(duckdb$expr_reference("l_extendedprice")))
      duckdb$expr_set_alias(tmp_expr, "avg_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("mean", list(duckdb$expr_reference("l_discount")))
      duckdb$expr_set_alias(tmp_expr, "avg_disc")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("n", list())
      duckdb$expr_set_alias(tmp_expr, "count_order")
      tmp_expr
    }
  )
)
rel10 <- duckdb$rel_order(rel9, list(duckdb$expr_reference("___row_number")))
rel11 <- duckdb$rel_project(
  rel10,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_qty")
      duckdb$expr_set_alias(tmp_expr, "sum_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_base_price")
      duckdb$expr_set_alias(tmp_expr, "sum_base_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_disc_price")
      duckdb$expr_set_alias(tmp_expr, "sum_disc_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_charge")
      duckdb$expr_set_alias(tmp_expr, "sum_charge")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_qty")
      duckdb$expr_set_alias(tmp_expr, "avg_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_price")
      duckdb$expr_set_alias(tmp_expr, "avg_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_disc")
      duckdb$expr_set_alias(tmp_expr, "avg_disc")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("count_order")
      duckdb$expr_set_alias(tmp_expr, "count_order")
      tmp_expr
    }
  )
)
rel12 <- duckdb$rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_qty")
      duckdb$expr_set_alias(tmp_expr, "sum_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_base_price")
      duckdb$expr_set_alias(tmp_expr, "sum_base_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_disc_price")
      duckdb$expr_set_alias(tmp_expr, "sum_disc_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_charge")
      duckdb$expr_set_alias(tmp_expr, "sum_charge")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_qty")
      duckdb$expr_set_alias(tmp_expr, "avg_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_price")
      duckdb$expr_set_alias(tmp_expr, "avg_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_disc")
      duckdb$expr_set_alias(tmp_expr, "avg_disc")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("count_order")
      duckdb$expr_set_alias(tmp_expr, "count_order")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel13 <- duckdb$rel_order(
  rel12,
  list(duckdb$expr_reference("l_returnflag"), duckdb$expr_reference("l_linestatus"), duckdb$expr_reference("___row_number"))
)
rel14 <- duckdb$rel_project(
  rel13,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_qty")
      duckdb$expr_set_alias(tmp_expr, "sum_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_base_price")
      duckdb$expr_set_alias(tmp_expr, "sum_base_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_disc_price")
      duckdb$expr_set_alias(tmp_expr, "sum_disc_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("sum_charge")
      duckdb$expr_set_alias(tmp_expr, "sum_charge")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_qty")
      duckdb$expr_set_alias(tmp_expr, "avg_qty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_price")
      duckdb$expr_set_alias(tmp_expr, "avg_price")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("avg_disc")
      duckdb$expr_set_alias(tmp_expr, "avg_disc")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("count_order")
      duckdb$expr_set_alias(tmp_expr, "count_order")
      tmp_expr
    }
  )
)
rel14
duckdb$rel_to_altrep(rel14)
