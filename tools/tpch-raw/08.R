qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(DBI::dbExecute(
  con,
  'CREATE MACRO "=="(x, y) AS (x == y)'
))
invisible(DBI::dbExecute(
  con,
  'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'
))
invisible(duckdb$rapi_load_rfuns(
  drv@database_ref
))
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
rel1 <- duckdb$rel_from_df(con, df1)
"select"
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "n_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n1_nationkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_regionkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n1_regionkey"
      )
      tmp_expr
    }
  )
)
df2 <- region
"select"
rel3 <- duckdb$rel_from_df(con, df2)
"select"
rel4 <- duckdb$rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "r_regionkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "r_regionkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "r_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "r_name"
      )
      tmp_expr
    }
  )
)
"filter"
rel5 <- duckdb$rel_filter(
  rel4,
  list(
    duckdb$expr_comparison(
      "==",
      list(
        duckdb$expr_reference("r_name"),
        duckdb$expr_constant("AMERICA")
      )
    )
  )
)
"select"
rel6 <- duckdb$rel_project(
  rel5,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "r_regionkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "r_regionkey"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel7 <- duckdb$rel_set_alias(
  rel2,
  "lhs"
)
"inner_join"
rel8 <- duckdb$rel_set_alias(
  rel6,
  "rhs"
)
"inner_join"
rel9 <- duckdb$rel_join(
  rel7,
  rel8,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "n1_regionkey",
          rel7
        ),
        duckdb$expr_reference(
          "r_regionkey",
          rel8
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel10 <- duckdb$rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "n1_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n1_nationkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "n1_regionkey",
            rel7
          ),
          duckdb$expr_reference(
            "r_regionkey",
            rel8
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n1_regionkey"
      )
      tmp_expr
    }
  )
)
"select"
rel11 <- duckdb$rel_project(
  rel10,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "n1_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n1_nationkey"
      )
      tmp_expr
    }
  )
)
df3 <- customer
"select"
rel12 <- duckdb$rel_from_df(con, df3)
"select"
rel13 <- duckdb$rel_project(
  rel12,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "c_custkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "c_custkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "c_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "c_nationkey"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel14 <- duckdb$rel_set_alias(
  rel13,
  "lhs"
)
"inner_join"
rel15 <- duckdb$rel_set_alias(
  rel11,
  "rhs"
)
"inner_join"
rel16 <- duckdb$rel_join(
  rel14,
  rel15,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "c_nationkey",
          rel14
        ),
        duckdb$expr_reference(
          "n1_nationkey",
          rel15
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel17 <- duckdb$rel_project(
  rel16,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "c_custkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "c_custkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "c_nationkey",
            rel14
          ),
          duckdb$expr_reference(
            "n1_nationkey",
            rel15
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "c_nationkey"
      )
      tmp_expr
    }
  )
)
"select"
rel18 <- duckdb$rel_project(
  rel17,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "c_custkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "c_custkey"
      )
      tmp_expr
    }
  )
)
df4 <- orders
"select"
rel19 <- duckdb$rel_from_df(con, df4)
"select"
rel20 <- duckdb$rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_custkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_custkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    }
  )
)
"filter"
rel21 <- duckdb$rel_filter(
  rel20,
  list(
    duckdb$expr_comparison(
      ">=",
      list(
        duckdb$expr_reference(
          "o_orderdate"
        ),
        duckdb$expr_constant(as.Date(
          "1995-01-01"
        ))
      )
    ),
    duckdb$expr_comparison(
      "<=",
      list(
        duckdb$expr_reference(
          "o_orderdate"
        ),
        duckdb$expr_constant(as.Date(
          "1996-12-31"
        ))
      )
    )
  )
)
"inner_join"
rel22 <- duckdb$rel_set_alias(
  rel21,
  "lhs"
)
"inner_join"
rel23 <- duckdb$rel_set_alias(
  rel18,
  "rhs"
)
"inner_join"
rel24 <- duckdb$rel_join(
  rel22,
  rel23,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "o_custkey",
          rel22
        ),
        duckdb$expr_reference(
          "c_custkey",
          rel23
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel25 <- duckdb$rel_project(
  rel24,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "o_custkey",
            rel22
          ),
          duckdb$expr_reference(
            "c_custkey",
            rel23
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_custkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    }
  )
)
"select"
rel26 <- duckdb$rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    }
  )
)
df5 <- lineitem
"select"
rel27 <- duckdb$rel_from_df(con, df5)
"select"
rel28 <- duckdb$rel_project(
  rel27,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_orderkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_orderkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel29 <- duckdb$rel_set_alias(
  rel28,
  "lhs"
)
"inner_join"
rel30 <- duckdb$rel_set_alias(
  rel26,
  "rhs"
)
"inner_join"
rel31 <- duckdb$rel_join(
  rel29,
  rel30,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "l_orderkey",
          rel29
        ),
        duckdb$expr_reference(
          "o_orderkey",
          rel30
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel32 <- duckdb$rel_project(
  rel31,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "l_orderkey",
            rel29
          ),
          duckdb$expr_reference(
            "o_orderkey",
            rel30
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_orderkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    }
  )
)
"select"
rel33 <- duckdb$rel_project(
  rel32,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    }
  )
)
df6 <- part
"select"
rel34 <- duckdb$rel_from_df(con, df6)
"select"
rel35 <- duckdb$rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "p_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "p_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "p_type"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "p_type"
      )
      tmp_expr
    }
  )
)
"filter"
rel36 <- duckdb$rel_filter(
  rel35,
  list(
    duckdb$expr_comparison(
      "==",
      list(
        duckdb$expr_reference("p_type"),
        duckdb$expr_constant(
          "ECONOMY ANODIZED STEEL"
        )
      )
    )
  )
)
"select"
rel37 <- duckdb$rel_project(
  rel36,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "p_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "p_partkey"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel38 <- duckdb$rel_set_alias(
  rel33,
  "lhs"
)
"inner_join"
rel39 <- duckdb$rel_set_alias(
  rel37,
  "rhs"
)
"inner_join"
rel40 <- duckdb$rel_join(
  rel38,
  rel39,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "l_partkey",
          rel38
        ),
        duckdb$expr_reference(
          "p_partkey",
          rel39
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel41 <- duckdb$rel_project(
  rel40,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "l_partkey",
            rel38
          ),
          duckdb$expr_reference(
            "p_partkey",
            rel39
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    }
  )
)
"select"
rel42 <- duckdb$rel_project(
  rel41,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    }
  )
)
df7 <- supplier
"select"
rel43 <- duckdb$rel_from_df(con, df7)
"select"
rel44 <- duckdb$rel_project(
  rel43,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "s_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_nationkey"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel45 <- duckdb$rel_set_alias(
  rel42,
  "lhs"
)
"inner_join"
rel46 <- duckdb$rel_set_alias(
  rel44,
  "rhs"
)
"inner_join"
rel47 <- duckdb$rel_join(
  rel45,
  rel46,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "l_suppkey",
          rel45
        ),
        duckdb$expr_reference(
          "s_suppkey",
          rel46
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel48 <- duckdb$rel_project(
  rel47,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "l_suppkey",
            rel45
          ),
          duckdb$expr_reference(
            "s_suppkey",
            rel46
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_nationkey"
      )
      tmp_expr
    }
  )
)
"select"
rel49 <- duckdb$rel_project(
  rel48,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_nationkey"
      )
      tmp_expr
    }
  )
)
"select"
rel50 <- duckdb$rel_from_df(con, df1)
"select"
rel51 <- duckdb$rel_project(
  rel50,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "n_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n2_nationkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n2_name"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel52 <- duckdb$rel_set_alias(
  rel49,
  "lhs"
)
"inner_join"
rel53 <- duckdb$rel_set_alias(
  rel51,
  "rhs"
)
"inner_join"
rel54 <- duckdb$rel_join(
  rel52,
  rel53,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "s_nationkey",
          rel52
        ),
        duckdb$expr_reference(
          "n2_nationkey",
          rel53
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel55 <- duckdb$rel_project(
  rel54,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "s_nationkey",
            rel52
          ),
          duckdb$expr_reference(
            "n2_nationkey",
            rel53
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_nationkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n2_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n2_name"
      )
      tmp_expr
    }
  )
)
"select"
rel56 <- duckdb$rel_project(
  rel55,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n2_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n2_name"
      )
      tmp_expr
    }
  )
)
"mutate"
rel57 <- duckdb$rel_project(
  rel56,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n2_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n2_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "r_base::as.integer",
        list(
          duckdb$expr_function(
            "strftime",
            list(
              duckdb$expr_reference(
                "o_orderdate"
              ),
              duckdb$expr_constant("%Y")
            )
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_year"
      )
      tmp_expr
    }
  )
)
"mutate"
rel58 <- duckdb$rel_project(
  rel57,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n2_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n2_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_year"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_year"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "*",
        list(
          duckdb$expr_reference(
            "l_extendedprice"
          ),
          duckdb$expr_function(
            "-",
            list(
              duckdb$expr_constant(1),
              duckdb$expr_reference(
                "l_discount"
              )
            )
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "volume"
      )
      tmp_expr
    }
  )
)
"mutate"
rel59 <- duckdb$rel_project(
  rel58,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "l_extendedprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_extendedprice"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_discount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_discount"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderdate"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n2_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n2_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_year"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_year"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "volume"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "volume"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n2_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
      )
      tmp_expr
    }
  )
)
"select"
rel60 <- duckdb$rel_project(
  rel59,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "o_year"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_year"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "volume"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "volume"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "nation"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
      )
      tmp_expr
    }
  )
)
"summarise"
rel61 <- duckdb$rel_aggregate(
  rel60,
  groups = list(duckdb$expr_reference(
    "o_year"
  )),
  aggregates = list(
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
                      duckdb$expr_reference(
                        "nation"
                      ),
                      duckdb$expr_constant(
                        "BRAZIL"
                      )
                    )
                  ),
                  duckdb$expr_reference(
                    "volume"
                  ),
                  duckdb$expr_constant(
                    0
                  )
                )
              )
            )
          ),
          duckdb$expr_function(
            "sum",
            list(duckdb$expr_reference(
              "volume"
            ))
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "mkt_share"
      )
      tmp_expr
    }
  )
)
"arrange"
rel62 <- duckdb$rel_order(
  rel61,
  list(duckdb$expr_reference("o_year"))
)
rel62
duckdb$rel_to_altrep(rel62)
