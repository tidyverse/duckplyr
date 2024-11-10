qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS (x == y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
df1 <- nation
"select"
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"select"
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_regionkey")
      duckdb$expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
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
rel5 <- duckdb$rel_filter(
  rel4,
  list(
    duckdb$expr_comparison(
      "==",
      list(
        duckdb$expr_reference("r_name"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("ASIA", experimental = experimental)
        } else {
          duckdb$expr_constant("ASIA")
        }
      )
    )
  )
)
"inner_join"
rel6 <- duckdb$rel_set_alias(rel2, "lhs")
"inner_join"
rel7 <- duckdb$rel_set_alias(rel5, "rhs")
"inner_join"
rel8 <- duckdb$rel_join(
  rel6,
  rel7,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("n_regionkey", rel6), duckdb$expr_reference("r_regionkey", rel7))
    )
  ),
  "inner"
)
"inner_join"
rel9 <- duckdb$rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("n_regionkey", rel6), duckdb$expr_reference("r_regionkey", rel7))
      )
      duckdb$expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
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
rel10 <- duckdb$rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb$expr_reference("n_nationkey")
      duckdb$expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
df3 <- supplier
"select"
rel11 <- duckdb$rel_from_df(con, df3, experimental = experimental)
"select"
rel12 <- duckdb$rel_project(
  rel11,
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
rel13 <- duckdb$rel_set_alias(rel12, "lhs")
"inner_join"
rel14 <- duckdb$rel_set_alias(rel10, "rhs")
"inner_join"
rel15 <- duckdb$rel_join(
  rel13,
  rel14,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("s_nationkey", rel13), duckdb$expr_reference("n_nationkey", rel14))
    )
  ),
  "inner"
)
"inner_join"
rel16 <- duckdb$rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("s_nationkey", rel13), duckdb$expr_reference("n_nationkey", rel14))
      )
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
"select"
rel17 <- duckdb$rel_project(
  rel16,
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
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
df4 <- lineitem
"select"
rel18 <- duckdb$rel_from_df(con, df4, experimental = experimental)
"select"
rel19 <- duckdb$rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
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
rel20 <- duckdb$rel_set_alias(rel19, "lhs")
"inner_join"
rel21 <- duckdb$rel_set_alias(rel17, "rhs")
"inner_join"
rel22 <- duckdb$rel_join(
  rel20,
  rel21,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_suppkey", rel20), duckdb$expr_reference("s_suppkey", rel21))
    )
  ),
  "inner"
)
"inner_join"
rel23 <- duckdb$rel_project(
  rel22,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_suppkey", rel20), duckdb$expr_reference("s_suppkey", rel21))
      )
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
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
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
df5 <- orders
"select"
rel24 <- duckdb$rel_from_df(con, df5, experimental = experimental)
"select"
rel25 <- duckdb$rel_project(
  rel24,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderdate")
      duckdb$expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    }
  )
)
"filter"
rel26 <- duckdb$rel_filter(
  rel25,
  list(
    duckdb$expr_comparison(
      ">=",
      list(
        duckdb$expr_reference("o_orderdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1994-01-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1994-01-01"))
        }
      )
    ),
    duckdb$expr_comparison(
      "<",
      list(
        duckdb$expr_reference("o_orderdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1995-01-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1995-01-01"))
        }
      )
    )
  )
)
"select"
rel27 <- duckdb$rel_project(
  rel26,
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
    }
  )
)
df6 <- customer
"select"
rel28 <- duckdb$rel_from_df(con, df6, experimental = experimental)
"select"
rel29 <- duckdb$rel_project(
  rel28,
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
rel30 <- duckdb$rel_set_alias(rel27, "lhs")
"inner_join"
rel31 <- duckdb$rel_set_alias(rel29, "rhs")
"inner_join"
rel32 <- duckdb$rel_join(
  rel30,
  rel31,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("o_custkey", rel30), duckdb$expr_reference("c_custkey", rel31))
    )
  ),
  "inner"
)
"inner_join"
rel33 <- duckdb$rel_project(
  rel32,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("o_custkey", rel30), duckdb$expr_reference("c_custkey", rel31))
      )
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
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
rel34 <- duckdb$rel_project(
  rel33,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
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
rel35 <- duckdb$rel_set_alias(rel23, "lhs")
"inner_join"
rel36 <- duckdb$rel_set_alias(rel34, "rhs")
"inner_join"
rel37 <- duckdb$rel_join(
  rel35,
  rel36,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_orderkey", rel35), duckdb$expr_reference("o_orderkey", rel36))
    ),
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("s_nationkey", rel35), duckdb$expr_reference("c_nationkey", rel36))
    )
  ),
  "inner"
)
"inner_join"
rel38 <- duckdb$rel_project(
  rel37,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_orderkey", rel35), duckdb$expr_reference("o_orderkey", rel36))
      )
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
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
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("s_nationkey", rel35), duckdb$expr_reference("c_nationkey", rel36))
      )
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
"select"
rel39 <- duckdb$rel_project(
  rel38,
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
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
"mutate"
rel40 <- duckdb$rel_project(
  rel39,
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
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
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
"summarise"
rel41 <- duckdb$rel_aggregate(
  rel40,
  groups = list(duckdb$expr_reference("n_name")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("sum", list(duckdb$expr_reference("volume")))
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
"arrange"
rel42 <- duckdb$rel_order(rel41, list(duckdb$expr_reference("revenue")))
rel42
duckdb$rel_to_altrep(rel42)
