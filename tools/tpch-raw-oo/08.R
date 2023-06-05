qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(a, b) AS a <= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.integer\"(x) AS CAST(x AS int32)"))
invisible(
  DBI::dbExecute(
    con,
    "CREATE MACRO \"ifelse\"(test, yes, no) AS (CASE WHEN test THEN yes ELSE no END)"
  )
)
df1 <- nation
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_regionkey")
      tmp_expr
    }
  )
)
df2 <- region
rel3 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel4 <- duckdb:::rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("r_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("r_name")
      duckdb:::expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    }
  )
)
rel5 <- duckdb:::rel_filter(
  rel4,
  list(
    duckdb:::expr_function(
      "==",
      list(
        duckdb:::expr_reference("r_name"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant("AMERICA", experimental = experimental)
        } else {
          duckdb:::expr_constant("AMERICA")
        }
      )
    )
  )
)
rel6 <- duckdb:::rel_project(
  rel5,
  list({
    tmp_expr <- duckdb:::expr_reference("r_regionkey")
    duckdb:::expr_set_alias(tmp_expr, "r_regionkey")
    tmp_expr
  })
)
rel7 <- duckdb:::rel_set_alias(rel2, "lhs")
rel8 <- duckdb:::rel_set_alias(rel6, "rhs")
rel9 <- duckdb:::rel_project(
  rel7,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n1_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel10 <- duckdb:::rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("r_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel11 <- duckdb:::rel_join(
  rel9,
  rel10,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("n1_regionkey", rel9), duckdb:::expr_reference("r_regionkey", rel10))
    )
  ),
  "inner"
)
rel12 <- duckdb:::rel_order(
  rel11,
  list(duckdb:::expr_reference("___row_number_x", rel9), duckdb:::expr_reference("___row_number_y", rel10))
)
rel13 <- duckdb:::rel_project(
  rel12,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n1_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("n1_regionkey", rel9), duckdb:::expr_reference("r_regionkey", rel10))
      )
      duckdb:::expr_set_alias(tmp_expr, "n1_regionkey")
      tmp_expr
    }
  )
)
rel14 <- duckdb:::rel_project(
  rel13,
  list({
    tmp_expr <- duckdb:::expr_reference("n1_nationkey")
    duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
    tmp_expr
  })
)
df3 <- customer
rel15 <- duckdb:::rel_from_df(con, df3, experimental = experimental)
rel16 <- duckdb:::rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    }
  )
)
rel17 <- duckdb:::rel_set_alias(rel16, "lhs")
rel18 <- duckdb:::rel_set_alias(rel14, "rhs")
rel19 <- duckdb:::rel_project(
  rel17,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel20 <- duckdb:::rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n1_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel21 <- duckdb:::rel_join(
  rel19,
  rel20,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_nationkey", rel19), duckdb:::expr_reference("n1_nationkey", rel20))
    )
  ),
  "inner"
)
rel22 <- duckdb:::rel_order(
  rel21,
  list(duckdb:::expr_reference("___row_number_x", rel19), duckdb:::expr_reference("___row_number_y", rel20))
)
rel23 <- duckdb:::rel_project(
  rel22,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("c_nationkey", rel19), duckdb:::expr_reference("n1_nationkey", rel20))
      )
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    }
  )
)
rel24 <- duckdb:::rel_project(
  rel23,
  list({
    tmp_expr <- duckdb:::expr_reference("c_custkey")
    duckdb:::expr_set_alias(tmp_expr, "c_custkey")
    tmp_expr
  })
)
df4 <- orders
rel25 <- duckdb:::rel_from_df(con, df4, experimental = experimental)
rel26 <- duckdb:::rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
rel27 <- duckdb:::rel_filter(
  rel26,
  list(
    duckdb:::expr_function(
      ">=",
      list(
        duckdb:::expr_reference("o_orderdate"),
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
    ),
    duckdb:::expr_function(
      "<=",
      list(
        duckdb:::expr_reference("o_orderdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1996-12-31", experimental = experimental)
            } else {
              duckdb:::expr_constant("1996-12-31")
            }
          )
        )
      )
    )
  )
)
rel28 <- duckdb:::rel_set_alias(rel27, "lhs")
rel29 <- duckdb:::rel_set_alias(rel24, "rhs")
rel30 <- duckdb:::rel_project(
  rel28,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel31 <- duckdb:::rel_project(
  rel29,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel32 <- duckdb:::rel_join(
  rel30,
  rel31,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_custkey", rel30), duckdb:::expr_reference("c_custkey", rel31))
    )
  ),
  "inner"
)
rel33 <- duckdb:::rel_order(
  rel32,
  list(duckdb:::expr_reference("___row_number_x", rel30), duckdb:::expr_reference("___row_number_y", rel31))
)
rel34 <- duckdb:::rel_project(
  rel33,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("o_custkey", rel30), duckdb:::expr_reference("c_custkey", rel31))
      )
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
rel35 <- duckdb:::rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
df5 <- lineitem
rel36 <- duckdb:::rel_from_df(con, df5, experimental = experimental)
rel37 <- duckdb:::rel_project(
  rel36,
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
rel38 <- duckdb:::rel_set_alias(rel37, "lhs")
rel39 <- duckdb:::rel_set_alias(rel35, "rhs")
rel40 <- duckdb:::rel_project(
  rel38,
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
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel41 <- duckdb:::rel_project(
  rel39,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel42 <- duckdb:::rel_join(
  rel40,
  rel41,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel40), duckdb:::expr_reference("o_orderkey", rel41))
    )
  ),
  "inner"
)
rel43 <- duckdb:::rel_order(
  rel42,
  list(duckdb:::expr_reference("___row_number_x", rel40), duckdb:::expr_reference("___row_number_y", rel41))
)
rel44 <- duckdb:::rel_project(
  rel43,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_orderkey", rel40), duckdb:::expr_reference("o_orderkey", rel41))
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
rel45 <- duckdb:::rel_project(
  rel44,
  list(
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
df6 <- part
rel46 <- duckdb:::rel_from_df(con, df6, experimental = experimental)
rel47 <- duckdb:::rel_project(
  rel46,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    }
  )
)
rel48 <- duckdb:::rel_filter(
  rel47,
  list(
    duckdb:::expr_function(
      "==",
      list(
        duckdb:::expr_reference("p_type"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant("ECONOMY ANODIZED STEEL", experimental = experimental)
        } else {
          duckdb:::expr_constant("ECONOMY ANODIZED STEEL")
        }
      )
    )
  )
)
rel49 <- duckdb:::rel_project(
  rel48,
  list({
    tmp_expr <- duckdb:::expr_reference("p_partkey")
    duckdb:::expr_set_alias(tmp_expr, "p_partkey")
    tmp_expr
  })
)
rel50 <- duckdb:::rel_set_alias(rel45, "lhs")
rel51 <- duckdb:::rel_set_alias(rel49, "rhs")
rel52 <- duckdb:::rel_project(
  rel50,
  list(
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel53 <- duckdb:::rel_project(
  rel51,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel54 <- duckdb:::rel_join(
  rel52,
  rel53,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel52), duckdb:::expr_reference("p_partkey", rel53))
    )
  ),
  "inner"
)
rel55 <- duckdb:::rel_order(
  rel54,
  list(duckdb:::expr_reference("___row_number_x", rel52), duckdb:::expr_reference("___row_number_y", rel53))
)
rel56 <- duckdb:::rel_project(
  rel55,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_partkey", rel52), duckdb:::expr_reference("p_partkey", rel53))
      )
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
rel57 <- duckdb:::rel_project(
  rel56,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
df7 <- supplier
rel58 <- duckdb:::rel_from_df(con, df7, experimental = experimental)
rel59 <- duckdb:::rel_project(
  rel58,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
rel60 <- duckdb:::rel_set_alias(rel57, "lhs")
rel61 <- duckdb:::rel_set_alias(rel59, "rhs")
rel62 <- duckdb:::rel_project(
  rel60,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel63 <- duckdb:::rel_project(
  rel61,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel64 <- duckdb:::rel_join(
  rel62,
  rel63,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel62), duckdb:::expr_reference("s_suppkey", rel63))
    )
  ),
  "inner"
)
rel65 <- duckdb:::rel_order(
  rel64,
  list(duckdb:::expr_reference("___row_number_x", rel62), duckdb:::expr_reference("___row_number_y", rel63))
)
rel66 <- duckdb:::rel_project(
  rel65,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_suppkey", rel62), duckdb:::expr_reference("s_suppkey", rel63))
      )
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
rel67 <- duckdb:::rel_project(
  rel66,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
rel68 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel69 <- duckdb:::rel_project(
  rel68,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel70 <- duckdb:::rel_set_alias(rel67, "lhs")
rel71 <- duckdb:::rel_set_alias(rel69, "rhs")
rel72 <- duckdb:::rel_project(
  rel70,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel73 <- duckdb:::rel_project(
  rel71,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n2_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel74 <- duckdb:::rel_join(
  rel72,
  rel73,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel72), duckdb:::expr_reference("n2_nationkey", rel73))
    )
  ),
  "inner"
)
rel75 <- duckdb:::rel_order(
  rel74,
  list(duckdb:::expr_reference("___row_number_x", rel72), duckdb:::expr_reference("___row_number_y", rel73))
)
rel76 <- duckdb:::rel_project(
  rel75,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("s_nationkey", rel72), duckdb:::expr_reference("n2_nationkey", rel73))
      )
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel77 <- duckdb:::rel_project(
  rel76,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel78 <- duckdb:::rel_project(
  rel77,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "as.integer",
        list(
          duckdb:::expr_function(
            "strftime",
            list(
              duckdb:::expr_reference("o_orderdate"),
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant("%Y", experimental = experimental)
              } else {
                duckdb:::expr_constant("%Y")
              }
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    }
  )
)
rel79 <- duckdb:::rel_project(
  rel78,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_year")
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
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
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel80 <- duckdb:::rel_project(
  rel79,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_year")
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("volume")
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "nation")
      tmp_expr
    }
  )
)
rel81 <- duckdb:::rel_project(
  rel80,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_year")
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("volume")
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("nation")
      duckdb:::expr_set_alias(tmp_expr, "nation")
      tmp_expr
    }
  )
)
rel82 <- duckdb:::rel_aggregate(
  rel81,
  groups = list(duckdb:::expr_reference("o_year")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function(
      "/",
      list(
        duckdb:::expr_function(
          "sum",
          list(
            duckdb:::expr_function(
              "ifelse",
              list(
                duckdb:::expr_function(
                  "==",
                  list(
                    duckdb:::expr_reference("nation"),
                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                      duckdb:::expr_constant("BRAZIL", experimental = experimental)
                    } else {
                      duckdb:::expr_constant("BRAZIL")
                    }
                  )
                ),
                duckdb:::expr_reference("volume"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant(0, experimental = experimental)
                } else {
                  duckdb:::expr_constant(0)
                }
              )
            )
          )
        ),
        duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
      )
    )
    duckdb:::expr_set_alias(tmp_expr, "mkt_share")
    tmp_expr
  })
)
rel83 <- duckdb:::rel_order(rel82, list(duckdb:::expr_reference("o_year")))
rel83
duckdb:::rel_to_altrep(rel83)
