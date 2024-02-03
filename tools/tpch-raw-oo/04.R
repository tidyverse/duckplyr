qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(x, y) AS x < y"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(x, y) AS x >= y"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(x, y) AS x = y"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(x, y) AS COALESCE(x, y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n\"() AS CAST(COUNT(*) AS int32)"))
df1 <- lineitem
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_commitdate")
      duckdb$expr_set_alias(tmp_expr, "l_commitdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_receiptdate")
      duckdb$expr_set_alias(tmp_expr, "l_receiptdate")
      tmp_expr
    }
  )
)
rel3 <- duckdb$rel_project(
  rel2,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_commitdate")
      duckdb$expr_set_alias(tmp_expr, "l_commitdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_receiptdate")
      duckdb$expr_set_alias(tmp_expr, "l_receiptdate")
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
      "<",
      list(duckdb$expr_reference("l_commitdate"), duckdb$expr_reference("l_receiptdate"))
    )
  )
)
rel5 <- duckdb$rel_order(rel4, list(duckdb$expr_reference("___row_number")))
rel6 <- duckdb$rel_project(
  rel5,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_commitdate")
      duckdb$expr_set_alias(tmp_expr, "l_commitdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_receiptdate")
      duckdb$expr_set_alias(tmp_expr, "l_receiptdate")
      tmp_expr
    }
  )
)
rel7 <- duckdb$rel_project(
  rel6,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    }
  )
)
df2 <- orders
rel8 <- duckdb$rel_from_df(con, df2, experimental = experimental)
rel9 <- duckdb$rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel10 <- duckdb$rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel11 <- duckdb$rel_filter(
  rel10,
  list(
    duckdb$expr_function(
      ">=",
      list(
        duckdb$expr_reference("o_orderdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1993-07-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1993-07-01"))
        }
      )
    ),
    duckdb$expr_function(
      "<",
      list(
        duckdb$expr_reference("o_orderdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1993-10-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1993-10-01"))
        }
      )
    )
  )
)
rel12 <- duckdb$rel_order(rel11, list(duckdb$expr_reference("___row_number")))
rel13 <- duckdb$rel_project(
  rel12,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel14 <- duckdb$rel_project(
  rel13,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel15 <- duckdb$rel_set_alias(rel7, "lhs")
rel16 <- duckdb$rel_set_alias(rel14, "rhs")
rel17 <- duckdb$rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel18 <- duckdb$rel_project(
  rel16,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel19 <- duckdb$rel_join(
  rel17,
  rel18,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_orderkey", rel17), duckdb$expr_reference("o_orderkey", rel18))
    )
  ),
  "inner"
)
rel20 <- duckdb$rel_order(
  rel19,
  list(duckdb$expr_reference("___row_number_x", rel17), duckdb$expr_reference("___row_number_y", rel18))
)
rel21 <- duckdb$rel_project(
  rel20,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_orderkey", rel17), duckdb$expr_reference("o_orderkey", rel18))
      )
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel22 <- duckdb$rel_project(
  rel21,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel23 <- duckdb$rel_project(
  rel22,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    duckdb$expr_reference("___row_number"),
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function("row_number", list()),
        list(
          l_orderkey = {
            tmp_expr <- duckdb$expr_reference("l_orderkey")
            duckdb$expr_set_alias(tmp_expr, "l_orderkey")
            tmp_expr
          },
          o_orderpriority = {
            tmp_expr <- duckdb$expr_reference("o_orderpriority")
            duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
            tmp_expr
          }
        ),
        list(duckdb$expr_reference("___row_number")),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(tmp_expr, "___row_number_by")
      tmp_expr
    }
  )
)
rel24 <- duckdb$rel_filter(
  rel23,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference("___row_number_by"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(1L, experimental = experimental)
        } else {
          duckdb$expr_constant(1L)
        }
      )
    )
  )
)
rel25 <- duckdb$rel_order(rel24, list(duckdb$expr_reference("___row_number")))
rel26 <- duckdb$rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel27 <- duckdb$rel_project(
  rel26,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel28 <- duckdb$rel_project(
  rel27,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel29 <- duckdb$rel_aggregate(
  rel28,
  groups = list(duckdb$expr_reference("o_orderpriority")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("___row_number")))
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("n", list())
      duckdb$expr_set_alias(tmp_expr, "order_count")
      tmp_expr
    }
  )
)
rel30 <- duckdb$rel_order(rel29, list(duckdb$expr_reference("___row_number")))
rel31 <- duckdb$rel_project(
  rel30,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("order_count")
      duckdb$expr_set_alias(tmp_expr, "order_count")
      tmp_expr
    }
  )
)
rel32 <- duckdb$rel_project(
  rel31,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("order_count")
      duckdb$expr_set_alias(tmp_expr, "order_count")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel33 <- duckdb$rel_order(
  rel32,
  list(duckdb$expr_reference("o_orderpriority"), duckdb$expr_reference("___row_number"))
)
rel34 <- duckdb$rel_project(
  rel33,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("order_count")
      duckdb$expr_set_alias(tmp_expr, "order_count")
      tmp_expr
    }
  )
)
rel34
duckdb$rel_to_altrep(rel34)
