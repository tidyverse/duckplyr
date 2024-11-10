qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
invisible(DBI::dbExecute(con, 'CREATE MACRO "|"(x, y) AS (x OR y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "&"(x, y) AS (x AND y)'))
invisible(duckdb$rapi_load_rfuns(drv@database_ref))
df1 <- supplier
"select"
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"select"
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    }
  )
)
df2 <- nation
"select"
rel3 <- duckdb$rel_from_df(con, df2, experimental = experimental)
"select"
rel4 <- duckdb$rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
"filter"
rel5 <- duckdb$rel_project(
  rel4,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n1_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
"filter"
rel6 <- duckdb$rel_filter(
  rel5,
  list(
    duckdb$expr_function(
      "|",
      list(
        duckdb$expr_comparison(
          cmp_op = "==",
          exprs = list(
            duckdb$expr_reference("n1_name"),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant("FRANCE", experimental = experimental)
            } else {
              duckdb$expr_constant("FRANCE")
            }
          )
        ),
        duckdb$expr_comparison(
          cmp_op = "==",
          exprs = list(
            duckdb$expr_reference("n1_name"),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant("GERMANY", experimental = experimental)
            } else {
              duckdb$expr_constant("GERMANY")
            }
          )
        )
      )
    )
  )
)
"filter"
rel7 <- duckdb$rel_order(rel6, list(duckdb$expr_reference("___row_number")))
"filter"
rel8 <- duckdb$rel_project(
  rel7,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n1_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
"inner_join"
rel9 <- duckdb$rel_set_alias(rel2, "lhs")
"inner_join"
rel10 <- duckdb$rel_set_alias(rel8, "rhs")
"inner_join"
rel11 <- duckdb$rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
"inner_join"
rel12 <- duckdb$rel_project(
  rel10,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n1_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
rel13 <- duckdb$rel_join(
  rel11,
  rel12,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("s_nationkey", rel11), duckdb$expr_reference("n1_nationkey", rel12))
    )
  ),
  "inner"
)
"inner_join"
rel14 <- duckdb$rel_order(
  rel13,
  list(duckdb$expr_reference("___row_number_x", rel11), duckdb$expr_reference("___row_number_y", rel12))
)
"inner_join"
rel15 <- duckdb$rel_project(
  rel14,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("s_nationkey", rel11), duckdb$expr_reference("n1_nationkey", rel12))
      )
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
"select"
rel16 <- duckdb$rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
df3 <- customer
"select"
rel17 <- duckdb$rel_from_df(con, df3, experimental = experimental)
"select"
rel18 <- duckdb$rel_project(
  rel17,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_nationkey")
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    }
  )
)
"select"
rel19 <- duckdb$rel_from_df(con, df2, experimental = experimental)
"select"
rel20 <- duckdb$rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
"filter"
rel21 <- duckdb$rel_project(
  rel20,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n2_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
"filter"
rel22 <- duckdb$rel_filter(
  rel21,
  list(
    duckdb$expr_function(
      "|",
      list(
        duckdb$expr_comparison(
          cmp_op = "==",
          exprs = list(
            duckdb$expr_reference("n2_name"),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant("FRANCE", experimental = experimental)
            } else {
              duckdb$expr_constant("FRANCE")
            }
          )
        ),
        duckdb$expr_comparison(
          cmp_op = "==",
          exprs = list(
            duckdb$expr_reference("n2_name"),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant("GERMANY", experimental = experimental)
            } else {
              duckdb$expr_constant("GERMANY")
            }
          )
        )
      )
    )
  )
)
"filter"
rel23 <- duckdb$rel_order(rel22, list(duckdb$expr_reference("___row_number")))
"filter"
rel24 <- duckdb$rel_project(
  rel23,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n2_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
"inner_join"
rel25 <- duckdb$rel_set_alias(rel18, "lhs")
"inner_join"
rel26 <- duckdb$rel_set_alias(rel24, "rhs")
"inner_join"
rel27 <- duckdb$rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_nationkey")
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
"inner_join"
rel28 <- duckdb$rel_project(
  rel26,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n2_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
rel29 <- duckdb$rel_join(
  rel27,
  rel28,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("c_nationkey", rel27), duckdb$expr_reference("n2_nationkey", rel28))
    )
  ),
  "inner"
)
"inner_join"
rel30 <- duckdb$rel_order(
  rel29,
  list(duckdb$expr_reference("___row_number_x", rel27), duckdb$expr_reference("___row_number_y", rel28))
)
"inner_join"
rel31 <- duckdb$rel_project(
  rel30,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("c_nationkey", rel27), duckdb$expr_reference("n2_nationkey", rel28))
      )
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
"select"
rel32 <- duckdb$rel_project(
  rel31,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
df4 <- orders
"select"
rel33 <- duckdb$rel_from_df(con, df4, experimental = experimental)
"select"
rel34 <- duckdb$rel_project(
  rel33,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    }
  )
)
"inner_join"
rel35 <- duckdb$rel_set_alias(rel34, "lhs")
"inner_join"
rel36 <- duckdb$rel_set_alias(rel32, "rhs")
"inner_join"
rel37 <- duckdb$rel_project(
  rel35,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
"inner_join"
rel38 <- duckdb$rel_project(
  rel36,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
rel39 <- duckdb$rel_join(
  rel37,
  rel38,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("o_custkey", rel37), duckdb$expr_reference("c_custkey", rel38))
    )
  ),
  "inner"
)
"inner_join"
rel40 <- duckdb$rel_order(
  rel39,
  list(duckdb$expr_reference("___row_number_x", rel37), duckdb$expr_reference("___row_number_y", rel38))
)
"inner_join"
rel41 <- duckdb$rel_project(
  rel40,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("o_custkey", rel37), duckdb$expr_reference("c_custkey", rel38))
      )
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
"select"
rel42 <- duckdb$rel_project(
  rel41,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
df5 <- lineitem
"select"
rel43 <- duckdb$rel_from_df(con, df5, experimental = experimental)
"select"
rel44 <- duckdb$rel_project(
  rel43,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
    }
  )
)
"filter"
rel45 <- duckdb$rel_project(
  rel44,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
"filter"
rel46 <- duckdb$rel_filter(
  rel45,
  list(
    duckdb$expr_comparison(
      cmp_op = ">=",
      exprs = list(
        duckdb$expr_reference("l_shipdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1995-01-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1995-01-01"))
        }
      )
    ),
    duckdb$expr_comparison(
      cmp_op = "<=",
      exprs = list(
        duckdb$expr_reference("l_shipdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1996-12-31"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1996-12-31"))
        }
      )
    )
  )
)
"filter"
rel47 <- duckdb$rel_order(rel46, list(duckdb$expr_reference("___row_number")))
"filter"
rel48 <- duckdb$rel_project(
  rel47,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
    }
  )
)
"inner_join"
rel49 <- duckdb$rel_set_alias(rel48, "lhs")
"inner_join"
rel50 <- duckdb$rel_set_alias(rel42, "rhs")
"inner_join"
rel51 <- duckdb$rel_project(
  rel49,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
"inner_join"
rel52 <- duckdb$rel_project(
  rel50,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
rel53 <- duckdb$rel_join(
  rel51,
  rel52,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("l_orderkey", rel51), duckdb$expr_reference("o_orderkey", rel52))
    )
  ),
  "inner"
)
"inner_join"
rel54 <- duckdb$rel_order(
  rel53,
  list(duckdb$expr_reference("___row_number_x", rel51), duckdb$expr_reference("___row_number_y", rel52))
)
"inner_join"
rel55 <- duckdb$rel_project(
  rel54,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_orderkey", rel51), duckdb$expr_reference("o_orderkey", rel52))
      )
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
"select"
rel56 <- duckdb$rel_project(
  rel55,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
"inner_join"
rel57 <- duckdb$rel_set_alias(rel56, "lhs")
"inner_join"
rel58 <- duckdb$rel_set_alias(rel16, "rhs")
"inner_join"
rel59 <- duckdb$rel_project(
  rel57,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
"inner_join"
rel60 <- duckdb$rel_project(
  rel58,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
rel61 <- duckdb$rel_join(
  rel59,
  rel60,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("l_suppkey", rel59), duckdb$expr_reference("s_suppkey", rel60))
    )
  ),
  "inner"
)
"inner_join"
rel62 <- duckdb$rel_order(
  rel61,
  list(duckdb$expr_reference("___row_number_x", rel59), duckdb$expr_reference("___row_number_y", rel60))
)
"inner_join"
rel63 <- duckdb$rel_project(
  rel62,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_suppkey", rel59), duckdb$expr_reference("s_suppkey", rel60))
      )
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
"filter"
rel64 <- duckdb$rel_project(
  rel63,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
"filter"
rel65 <- duckdb$rel_filter(
  rel64,
  list(
    duckdb$expr_function(
      "|",
      list(
        duckdb$expr_function(
          "&",
          list(
            duckdb$expr_comparison(
              cmp_op = "==",
              exprs = list(
                duckdb$expr_reference("n1_name"),
                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                  duckdb$expr_constant("FRANCE", experimental = experimental)
                } else {
                  duckdb$expr_constant("FRANCE")
                }
              )
            ),
            duckdb$expr_comparison(
              cmp_op = "==",
              exprs = list(
                duckdb$expr_reference("n2_name"),
                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                  duckdb$expr_constant("GERMANY", experimental = experimental)
                } else {
                  duckdb$expr_constant("GERMANY")
                }
              )
            )
          )
        ),
        duckdb$expr_function(
          "&",
          list(
            duckdb$expr_comparison(
              cmp_op = "==",
              exprs = list(
                duckdb$expr_reference("n1_name"),
                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                  duckdb$expr_constant("GERMANY", experimental = experimental)
                } else {
                  duckdb$expr_constant("GERMANY")
                }
              )
            ),
            duckdb$expr_comparison(
              cmp_op = "==",
              exprs = list(
                duckdb$expr_reference("n2_name"),
                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                  duckdb$expr_constant("FRANCE", experimental = experimental)
                } else {
                  duckdb$expr_constant("FRANCE")
                }
              )
            )
          )
        )
      )
    )
  )
)
"filter"
rel66 <- duckdb$rel_order(rel65, list(duckdb$expr_reference("___row_number")))
"filter"
rel67 <- duckdb$rel_project(
  rel66,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
"mutate"
rel68 <- duckdb$rel_project(
  rel67,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    }
  )
)
"mutate"
rel69 <- duckdb$rel_project(
  rel68,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("supp_nation")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    }
  )
)
"mutate"
rel70 <- duckdb$rel_project(
  rel69,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("supp_nation")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cust_nation")
      duckdb$expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "r_base::as.integer",
        list(
          duckdb$expr_function(
            "strftime",
            list(
              duckdb$expr_reference("l_shipdate"),
              if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                duckdb$expr_constant("%Y", experimental = experimental)
              } else {
                duckdb$expr_constant("%Y")
              }
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    }
  )
)
"mutate"
rel71 <- duckdb$rel_project(
  rel70,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n1_name")
      duckdb$expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("supp_nation")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cust_nation")
      duckdb$expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_year")
      duckdb$expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
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
      duckdb$expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
"select"
rel72 <- duckdb$rel_project(
  rel71,
  list(
    {
      tmp_expr <- duckdb$expr_reference("supp_nation")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cust_nation")
      duckdb$expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_year")
      duckdb$expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("volume")
      duckdb$expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
"summarise"
rel73 <- duckdb$rel_project(
  rel72,
  list(
    {
      tmp_expr <- duckdb$expr_reference("supp_nation")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cust_nation")
      duckdb$expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_year")
      duckdb$expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("volume")
      duckdb$expr_set_alias(tmp_expr, "volume")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
"summarise"
rel74 <- duckdb$rel_aggregate(
  rel73,
  groups = list(duckdb$expr_reference("supp_nation"), duckdb$expr_reference("cust_nation"), duckdb$expr_reference("l_year")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("___row_number")))
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("sum", list(duckdb$expr_reference("volume")))
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
"summarise"
rel75 <- duckdb$rel_order(rel74, list(duckdb$expr_reference("___row_number")))
"summarise"
rel76 <- duckdb$rel_project(
  rel75,
  list(
    {
      tmp_expr <- duckdb$expr_reference("supp_nation")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cust_nation")
      duckdb$expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_year")
      duckdb$expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
"arrange"
rel77 <- duckdb$rel_project(
  rel76,
  list(
    {
      tmp_expr <- duckdb$expr_reference("supp_nation")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cust_nation")
      duckdb$expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_year")
      duckdb$expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
"arrange"
rel78 <- duckdb$rel_order(
  rel77,
  list(duckdb$expr_reference("supp_nation"), duckdb$expr_reference("cust_nation"), duckdb$expr_reference("l_year"), duckdb$expr_reference("___row_number"))
)
"arrange"
rel79 <- duckdb$rel_project(
  rel78,
  list(
    {
      tmp_expr <- duckdb$expr_reference("supp_nation")
      duckdb$expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cust_nation")
      duckdb$expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_year")
      duckdb$expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel79
duckdb$rel_to_altrep(rel79)
