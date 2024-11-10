qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS (x == y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(duckdb$rapi_load_rfuns(drv@database_ref))
invisible(
  DBI::dbExecute(
    con,
    r"[CREATE MACRO "___divide"(x, y) AS CASE WHEN y = 0 THEN CASE WHEN x = 0 THEN CAST('NaN' AS double) WHEN x > 0 THEN CAST('+Infinity' AS double) ELSE CAST('-Infinity' AS double) END ELSE CAST(x AS double) / y END]"
  )
)
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "if_else"(test, yes, no) AS (CASE WHEN test IS NULL THEN NULL ELSE CASE WHEN test THEN yes ELSE no END END)'
  )
)
df1 <- nation
"select"
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"select"
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_regionkey")
      duckdb$expr_set_alias(tmp_expr, "n1_regionkey")
      tmp_expr
    }
  )
)
df2 <- region
"select"
rel3 <- duckdb$rel_from_df(con, df2, experimental = experimental)
"select"
rel4 <- duckdb$rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb$expr_reference("r_regionkey")
      duckdb$expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_name")
      duckdb$expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    }
  )
)
"filter"
rel5 <- duckdb$rel_project(
  rel4,
  list(
    {
      tmp_expr <- duckdb$expr_reference("r_regionkey")
      duckdb$expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_name")
      duckdb$expr_set_alias(tmp_expr, "r_name")
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
    duckdb$expr_comparison(
      "==",
      list(
        duckdb$expr_reference("r_name"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("AMERICA", experimental = experimental)
        } else {
          duckdb$expr_constant("AMERICA")
        }
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
      tmp_expr <- duckdb$expr_reference("r_regionkey")
      duckdb$expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_name")
      duckdb$expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    }
  )
)
"select"
rel9 <- duckdb$rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb$expr_reference("r_regionkey")
      duckdb$expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    }
  )
)
"inner_join"
rel10 <- duckdb$rel_set_alias(rel2, "lhs")
"inner_join"
rel11 <- duckdb$rel_set_alias(rel9, "rhs")
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
      tmp_expr <- duckdb$expr_reference("n1_regionkey")
      duckdb$expr_set_alias(tmp_expr, "n1_regionkey")
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
rel13 <- duckdb$rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb$expr_reference("r_regionkey")
      duckdb$expr_set_alias(tmp_expr, "r_regionkey")
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
rel14 <- duckdb$rel_join(
  rel12,
  rel13,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("n1_regionkey", rel12), duckdb$expr_reference("r_regionkey", rel13))
    )
  ),
  "inner"
)
"inner_join"
rel15 <- duckdb$rel_order(
  rel14,
  list(duckdb$expr_reference("___row_number_x", rel12), duckdb$expr_reference("___row_number_y", rel13))
)
"inner_join"
rel16 <- duckdb$rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n1_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("n1_regionkey", rel12), duckdb$expr_reference("r_regionkey", rel13))
      )
      duckdb$expr_set_alias(tmp_expr, "n1_regionkey")
      tmp_expr
    }
  )
)
"select"
rel17 <- duckdb$rel_project(
  rel16,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n1_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    }
  )
)
df3 <- customer
"select"
rel18 <- duckdb$rel_from_df(con, df3, experimental = experimental)
"select"
rel19 <- duckdb$rel_project(
  rel18,
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
"inner_join"
rel20 <- duckdb$rel_set_alias(rel19, "lhs")
"inner_join"
rel21 <- duckdb$rel_set_alias(rel17, "rhs")
"inner_join"
rel22 <- duckdb$rel_project(
  rel20,
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
rel23 <- duckdb$rel_project(
  rel21,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n1_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n1_nationkey")
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
rel24 <- duckdb$rel_join(
  rel22,
  rel23,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("c_nationkey", rel22), duckdb$expr_reference("n1_nationkey", rel23))
    )
  ),
  "inner"
)
"inner_join"
rel25 <- duckdb$rel_order(
  rel24,
  list(duckdb$expr_reference("___row_number_x", rel22), duckdb$expr_reference("___row_number_y", rel23))
)
"inner_join"
rel26 <- duckdb$rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("c_nationkey", rel22), duckdb$expr_reference("n1_nationkey", rel23))
      )
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    }
  )
)
"select"
rel27 <- duckdb$rel_project(
  rel26,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    }
  )
)
df4 <- orders
"select"
rel28 <- duckdb$rel_from_df(con, df4, experimental = experimental)
"select"
rel29 <- duckdb$rel_project(
  rel28,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
"filter"
rel30 <- duckdb$rel_project(
  rel29,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
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
rel31 <- duckdb$rel_filter(
  rel30,
  list(
    duckdb$expr_comparison(
      ">=",
      list(
        duckdb$expr_reference("o_orderdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1995-01-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1995-01-01"))
        }
      )
    ),
    duckdb$expr_comparison(
      "<=",
      list(
        duckdb$expr_reference("o_orderdate"),
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
rel32 <- duckdb$rel_order(rel31, list(duckdb$expr_reference("___row_number")))
"filter"
rel33 <- duckdb$rel_project(
  rel32,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
"inner_join"
rel34 <- duckdb$rel_set_alias(rel33, "lhs")
"inner_join"
rel35 <- duckdb$rel_set_alias(rel27, "rhs")
"inner_join"
rel36 <- duckdb$rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
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
rel37 <- duckdb$rel_project(
  rel35,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
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
rel38 <- duckdb$rel_join(
  rel36,
  rel37,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("o_custkey", rel36), duckdb$expr_reference("c_custkey", rel37))
    )
  ),
  "inner"
)
"inner_join"
rel39 <- duckdb$rel_order(
  rel38,
  list(duckdb$expr_reference("___row_number_x", rel36), duckdb$expr_reference("___row_number_y", rel37))
)
"inner_join"
rel40 <- duckdb$rel_project(
  rel39,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("o_custkey", rel36), duckdb$expr_reference("c_custkey", rel37))
      )
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
"select"
rel41 <- duckdb$rel_project(
  rel40,
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
    }
  )
)
df5 <- lineitem
"select"
rel42 <- duckdb$rel_from_df(con, df5, experimental = experimental)
"select"
rel43 <- duckdb$rel_project(
  rel42,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_partkey")
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
rel44 <- duckdb$rel_set_alias(rel43, "lhs")
"inner_join"
rel45 <- duckdb$rel_set_alias(rel41, "rhs")
"inner_join"
rel46 <- duckdb$rel_project(
  rel44,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_partkey")
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
rel47 <- duckdb$rel_project(
  rel45,
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
rel48 <- duckdb$rel_join(
  rel46,
  rel47,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_orderkey", rel46), duckdb$expr_reference("o_orderkey", rel47))
    )
  ),
  "inner"
)
"inner_join"
rel49 <- duckdb$rel_order(
  rel48,
  list(duckdb$expr_reference("___row_number_x", rel46), duckdb$expr_reference("___row_number_y", rel47))
)
"inner_join"
rel50 <- duckdb$rel_project(
  rel49,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_orderkey", rel46), duckdb$expr_reference("o_orderkey", rel47))
      )
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_partkey")
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
"select"
rel51 <- duckdb$rel_project(
  rel50,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_partkey")
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
df6 <- part
"select"
rel52 <- duckdb$rel_from_df(con, df6, experimental = experimental)
"select"
rel53 <- duckdb$rel_project(
  rel52,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_type")
      duckdb$expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    }
  )
)
"filter"
rel54 <- duckdb$rel_project(
  rel53,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_type")
      duckdb$expr_set_alias(tmp_expr, "p_type")
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
rel55 <- duckdb$rel_filter(
  rel54,
  list(
    duckdb$expr_comparison(
      "==",
      list(
        duckdb$expr_reference("p_type"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("ECONOMY ANODIZED STEEL", experimental = experimental)
        } else {
          duckdb$expr_constant("ECONOMY ANODIZED STEEL")
        }
      )
    )
  )
)
"filter"
rel56 <- duckdb$rel_order(rel55, list(duckdb$expr_reference("___row_number")))
"filter"
rel57 <- duckdb$rel_project(
  rel56,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_type")
      duckdb$expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    }
  )
)
"select"
rel58 <- duckdb$rel_project(
  rel57,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    }
  )
)
"inner_join"
rel59 <- duckdb$rel_set_alias(rel51, "lhs")
"inner_join"
rel60 <- duckdb$rel_set_alias(rel58, "rhs")
"inner_join"
rel61 <- duckdb$rel_project(
  rel59,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_partkey")
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
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
rel62 <- duckdb$rel_project(
  rel60,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
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
rel63 <- duckdb$rel_join(
  rel61,
  rel62,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_partkey", rel61), duckdb$expr_reference("p_partkey", rel62))
    )
  ),
  "inner"
)
"inner_join"
rel64 <- duckdb$rel_order(
  rel63,
  list(duckdb$expr_reference("___row_number_x", rel61), duckdb$expr_reference("___row_number_y", rel62))
)
"inner_join"
rel65 <- duckdb$rel_project(
  rel64,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_partkey", rel61), duckdb$expr_reference("p_partkey", rel62))
      )
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
"select"
rel66 <- duckdb$rel_project(
  rel65,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
df7 <- supplier
"select"
rel67 <- duckdb$rel_from_df(con, df7, experimental = experimental)
"select"
rel68 <- duckdb$rel_project(
  rel67,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
"inner_join"
rel69 <- duckdb$rel_set_alias(rel66, "lhs")
"inner_join"
rel70 <- duckdb$rel_set_alias(rel68, "rhs")
"inner_join"
rel71 <- duckdb$rel_project(
  rel69,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
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
rel72 <- duckdb$rel_project(
  rel70,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
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
rel73 <- duckdb$rel_join(
  rel71,
  rel72,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_suppkey", rel71), duckdb$expr_reference("s_suppkey", rel72))
    )
  ),
  "inner"
)
"inner_join"
rel74 <- duckdb$rel_order(
  rel73,
  list(duckdb$expr_reference("___row_number_x", rel71), duckdb$expr_reference("___row_number_y", rel72))
)
"inner_join"
rel75 <- duckdb$rel_project(
  rel74,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_suppkey", rel71), duckdb$expr_reference("s_suppkey", rel72))
      )
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
"select"
rel76 <- duckdb$rel_project(
  rel75,
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
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
"select"
rel77 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"select"
rel78 <- duckdb$rel_project(
  rel77,
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
"inner_join"
rel79 <- duckdb$rel_set_alias(rel76, "lhs")
"inner_join"
rel80 <- duckdb$rel_set_alias(rel78, "rhs")
"inner_join"
rel81 <- duckdb$rel_project(
  rel79,
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
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
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
rel82 <- duckdb$rel_project(
  rel80,
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
rel83 <- duckdb$rel_join(
  rel81,
  rel82,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("s_nationkey", rel81), duckdb$expr_reference("n2_nationkey", rel82))
    )
  ),
  "inner"
)
"inner_join"
rel84 <- duckdb$rel_order(
  rel83,
  list(duckdb$expr_reference("___row_number_x", rel81), duckdb$expr_reference("___row_number_y", rel82))
)
"inner_join"
rel85 <- duckdb$rel_project(
  rel84,
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
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("s_nationkey", rel81), duckdb$expr_reference("n2_nationkey", rel82))
      )
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
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
rel86 <- duckdb$rel_project(
  rel85,
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
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
"mutate"
rel87 <- duckdb$rel_project(
  rel86,
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
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "r_base::as.integer",
        list(
          duckdb$expr_function(
            "strftime",
            list(
              duckdb$expr_reference("o_orderdate"),
              if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                duckdb$expr_constant("%Y", experimental = experimental)
              } else {
                duckdb$expr_constant("%Y")
              }
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    }
  )
)
"mutate"
rel88 <- duckdb$rel_project(
  rel87,
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
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_year")
      duckdb$expr_set_alias(tmp_expr, "o_year")
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
"mutate"
rel89 <- duckdb$rel_project(
  rel88,
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
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_year")
      duckdb$expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("volume")
      duckdb$expr_set_alias(tmp_expr, "volume")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n2_name")
      duckdb$expr_set_alias(tmp_expr, "nation")
      tmp_expr
    }
  )
)
"select"
rel90 <- duckdb$rel_project(
  rel89,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_year")
      duckdb$expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("volume")
      duckdb$expr_set_alias(tmp_expr, "volume")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("nation")
      duckdb$expr_set_alias(tmp_expr, "nation")
      tmp_expr
    }
  )
)
"summarise"
rel91 <- duckdb$rel_project(
  rel90,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_year")
      duckdb$expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("volume")
      duckdb$expr_set_alias(tmp_expr, "volume")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("nation")
      duckdb$expr_set_alias(tmp_expr, "nation")
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
rel92 <- duckdb$rel_aggregate(
  rel91,
  groups = list(duckdb$expr_reference("o_year")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("___row_number")))
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___divide",
        list(
          duckdb$expr_function(
            "sum",
            list(
              duckdb$expr_function(
                "if_else",
                list(
                  duckdb$expr_comparison(
                    "==",
                    list(
                      duckdb$expr_reference("nation"),
                      if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                        duckdb$expr_constant("BRAZIL", experimental = experimental)
                      } else {
                        duckdb$expr_constant("BRAZIL")
                      }
                    )
                  ),
                  duckdb$expr_reference("volume"),
                  if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                    duckdb$expr_constant(0, experimental = experimental)
                  } else {
                    duckdb$expr_constant(0)
                  }
                )
              )
            )
          ),
          duckdb$expr_function("sum", list(duckdb$expr_reference("volume")))
        )
      )
      duckdb$expr_set_alias(tmp_expr, "mkt_share")
      tmp_expr
    }
  )
)
"summarise"
rel93 <- duckdb$rel_order(rel92, list(duckdb$expr_reference("___row_number")))
"summarise"
rel94 <- duckdb$rel_project(
  rel93,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_year")
      duckdb$expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("mkt_share")
      duckdb$expr_set_alias(tmp_expr, "mkt_share")
      tmp_expr
    }
  )
)
"arrange"
rel95 <- duckdb$rel_project(
  rel94,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_year")
      duckdb$expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("mkt_share")
      duckdb$expr_set_alias(tmp_expr, "mkt_share")
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
rel96 <- duckdb$rel_order(rel95, list(duckdb$expr_reference("o_year"), duckdb$expr_reference("___row_number")))
"arrange"
rel97 <- duckdb$rel_project(
  rel96,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_year")
      duckdb$expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("mkt_share")
      duckdb$expr_set_alias(tmp_expr, "mkt_share")
      tmp_expr
    }
  )
)
rel97
duckdb$rel_to_altrep(rel97)
