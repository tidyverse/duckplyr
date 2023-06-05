qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"grepl\"(pattern, x) AS regexp_matches(x, pattern)")
)
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(a, b) AS a < b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">\"(a, b) AS a > b"))
df1 <- nation
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_filter(
  rel1,
  list(
    duckdb:::expr_function(
      "==",
      list(
        duckdb:::expr_reference("n_name"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant("CANADA", experimental = experimental)
        } else {
          duckdb:::expr_constant("CANADA")
        }
      )
    )
  )
)
df2 <- supplier
rel3 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel4 <- duckdb:::rel_set_alias(rel3, "lhs")
rel5 <- duckdb:::rel_set_alias(rel2, "rhs")
rel6 <- duckdb:::rel_project(
  rel4,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel7 <- duckdb:::rel_project(
  rel5,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_comment")
      duckdb:::expr_set_alias(tmp_expr, "n_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel8 <- duckdb:::rel_join(
  rel6,
  rel7,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel6), duckdb:::expr_reference("n_nationkey", rel7))
    )
  ),
  "inner"
)
rel9 <- duckdb:::rel_order(
  rel8,
  list(duckdb:::expr_reference("___row_number_x", rel6), duckdb:::expr_reference("___row_number_y", rel7))
)
rel10 <- duckdb:::rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("s_nationkey", rel6), duckdb:::expr_reference("n_nationkey", rel7))
      )
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_comment")
      duckdb:::expr_set_alias(tmp_expr, "n_comment")
      tmp_expr
    }
  )
)
rel11 <- duckdb:::rel_project(
  rel10,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    }
  )
)
df3 <- part
rel12 <- duckdb:::rel_from_df(con, df3, experimental = experimental)
rel13 <- duckdb:::rel_filter(
  rel12,
  list(
    duckdb:::expr_function(
      "grepl",
      list(
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant("^forest", experimental = experimental)
        } else {
          duckdb:::expr_constant("^forest")
        },
        duckdb:::expr_reference("p_name")
      )
    )
  )
)
df4 <- partsupp
rel14 <- duckdb:::rel_from_df(con, df4, experimental = experimental)
rel15 <- duckdb:::rel_set_alias(rel14, "lhs")
rel16 <- duckdb:::rel_set_alias(rel11, "rhs")
rel17 <- duckdb:::rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_availqty")
      duckdb:::expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_comment")
      duckdb:::expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel18 <- duckdb:::rel_join(
  rel17,
  rel16,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_suppkey", rel17), duckdb:::expr_reference("s_suppkey", rel16))
    )
  ),
  "semi"
)
rel19 <- duckdb:::rel_order(rel18, list(duckdb:::expr_reference("___row_number_x", rel17)))
rel20 <- duckdb:::rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_availqty")
      duckdb:::expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_comment")
      duckdb:::expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    }
  )
)
rel21 <- duckdb:::rel_set_alias(rel20, "lhs")
rel22 <- duckdb:::rel_set_alias(rel13, "rhs")
rel23 <- duckdb:::rel_project(
  rel21,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_availqty")
      duckdb:::expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_comment")
      duckdb:::expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel24 <- duckdb:::rel_join(
  rel23,
  rel22,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_partkey", rel23), duckdb:::expr_reference("p_partkey", rel22))
    )
  ),
  "semi"
)
rel25 <- duckdb:::rel_order(rel24, list(duckdb:::expr_reference("___row_number_x", rel23)))
rel26 <- duckdb:::rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_availqty")
      duckdb:::expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_comment")
      duckdb:::expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    }
  )
)
df5 <- lineitem
rel27 <- duckdb:::rel_from_df(con, df5, experimental = experimental)
rel28 <- duckdb:::rel_filter(
  rel27,
  list(
    duckdb:::expr_function(
      ">=",
      list(
        duckdb:::expr_reference("l_shipdate"),
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
        duckdb:::expr_reference("l_shipdate"),
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
rel29 <- duckdb:::rel_set_alias(rel28, "lhs")
rel30 <- duckdb:::rel_set_alias(rel26, "rhs")
rel31 <- duckdb:::rel_project(
  rel29,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
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
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel32 <- duckdb:::rel_join(
  rel31,
  rel30,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel31), duckdb:::expr_reference("ps_partkey", rel30))
    ),
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel31), duckdb:::expr_reference("ps_suppkey", rel30))
    )
  ),
  "semi"
)
rel33 <- duckdb:::rel_order(rel32, list(duckdb:::expr_reference("___row_number_x", rel31)))
rel34 <- duckdb:::rel_project(
  rel33,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
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
    }
  )
)
rel35 <- duckdb:::rel_aggregate(
  rel34,
  groups = list(duckdb:::expr_reference("l_suppkey")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function(
      "*",
      list(
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant(0.5, experimental = experimental)
        } else {
          duckdb:::expr_constant(0.5)
        },
        duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_quantity")))
      )
    )
    duckdb:::expr_set_alias(tmp_expr, "qty_threshold")
    tmp_expr
  })
)
rel36 <- duckdb:::rel_set_alias(rel26, "lhs")
rel37 <- duckdb:::rel_set_alias(rel35, "rhs")
rel38 <- duckdb:::rel_project(
  rel36,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_availqty")
      duckdb:::expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_comment")
      duckdb:::expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel39 <- duckdb:::rel_project(
  rel37,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("qty_threshold")
      duckdb:::expr_set_alias(tmp_expr, "qty_threshold")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel40 <- duckdb:::rel_join(
  rel38,
  rel39,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_suppkey", rel38), duckdb:::expr_reference("l_suppkey", rel39))
    )
  ),
  "inner"
)
rel41 <- duckdb:::rel_order(
  rel40,
  list(duckdb:::expr_reference("___row_number_x", rel38), duckdb:::expr_reference("___row_number_y", rel39))
)
rel42 <- duckdb:::rel_project(
  rel41,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("ps_suppkey", rel38), duckdb:::expr_reference("l_suppkey", rel39))
      )
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_availqty")
      duckdb:::expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_comment")
      duckdb:::expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("qty_threshold")
      duckdb:::expr_set_alias(tmp_expr, "qty_threshold")
      tmp_expr
    }
  )
)
rel43 <- duckdb:::rel_filter(
  rel42,
  list(
    duckdb:::expr_function(
      ">",
      list(duckdb:::expr_reference("ps_availqty"), duckdb:::expr_reference("qty_threshold"))
    )
  )
)
rel44 <- duckdb:::rel_set_alias(rel11, "lhs")
rel45 <- duckdb:::rel_set_alias(rel43, "rhs")
rel46 <- duckdb:::rel_project(
  rel44,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel47 <- duckdb:::rel_join(
  rel46,
  rel45,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_suppkey", rel46), duckdb:::expr_reference("ps_suppkey", rel45))
    )
  ),
  "semi"
)
rel48 <- duckdb:::rel_order(rel47, list(duckdb:::expr_reference("___row_number_x", rel46)))
rel49 <- duckdb:::rel_project(
  rel48,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    }
  )
)
rel50 <- duckdb:::rel_project(
  rel49,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    }
  )
)
rel51 <- duckdb:::rel_order(rel50, list(duckdb:::expr_reference("s_name")))
rel51
duckdb:::rel_to_altrep(rel51)
