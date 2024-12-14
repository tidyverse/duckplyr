qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS (x == y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
df1 <- lineitem
"select"
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"select"
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
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
rel3 <- duckdb$rel_project(
  rel2,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
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
rel4 <- duckdb$rel_filter(
  rel3,
  list(
    duckdb$expr_comparison(
      "==",
      list(
        duckdb$expr_reference("l_returnflag"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("R", experimental = experimental)
        } else {
          duckdb$expr_constant("R")
        }
      )
    )
  )
)
"filter"
rel5 <- duckdb$rel_order(rel4, list(duckdb$expr_reference("___row_number")))
"filter"
rel6 <- duckdb$rel_project(
  rel5,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
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
"select"
rel7 <- duckdb$rel_project(
  rel6,
  list(
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
df2 <- orders
"select"
rel8 <- duckdb$rel_from_df(con, df2, experimental = experimental)
"select"
rel9 <- duckdb$rel_project(
  rel8,
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
rel10 <- duckdb$rel_project(
  rel9,
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
rel11 <- duckdb$rel_filter(
  rel10,
  list(
    duckdb$expr_comparison(
      ">=",
      list(
        duckdb$expr_reference("o_orderdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1993-10-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1993-10-01"))
        }
      )
    ),
    duckdb$expr_comparison(
      "<",
      list(
        duckdb$expr_reference("o_orderdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1994-01-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1994-01-01"))
        }
      )
    )
  )
)
"filter"
rel12 <- duckdb$rel_order(rel11, list(duckdb$expr_reference("___row_number")))
"filter"
rel13 <- duckdb$rel_project(
  rel12,
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
"select"
rel14 <- duckdb$rel_project(
  rel13,
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
"inner_join"
rel15 <- duckdb$rel_set_alias(rel7, "lhs")
"inner_join"
rel16 <- duckdb$rel_set_alias(rel14, "rhs")
"inner_join"
rel17 <- duckdb$rel_project(
  rel15,
  list(
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
"inner_join"
rel18 <- duckdb$rel_project(
  rel16,
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
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
"inner_join"
rel20 <- duckdb$rel_order(
  rel19,
  list(duckdb$expr_reference("___row_number_x", rel17), duckdb$expr_reference("___row_number_y", rel18))
)
"inner_join"
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
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    }
  )
)
"select"
rel22 <- duckdb$rel_project(
  rel21,
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
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    }
  )
)
"mutate"
rel23 <- duckdb$rel_project(
  rel22,
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
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
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
rel24 <- duckdb$rel_project(
  rel23,
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
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
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
rel25 <- duckdb$rel_aggregate(
  rel24,
  groups = list(duckdb$expr_reference("o_custkey")),
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
rel26 <- duckdb$rel_order(rel25, list(duckdb$expr_reference("___row_number")))
"summarise"
rel27 <- duckdb$rel_project(
  rel26,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
df3 <- customer
"select"
rel28 <- duckdb$rel_from_df(con, df3, experimental = experimental)
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
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    }
  )
)
"inner_join"
rel30 <- duckdb$rel_set_alias(rel29, "lhs")
"inner_join"
rel31 <- duckdb$rel_set_alias(rel27, "rhs")
"inner_join"
rel32 <- duckdb$rel_project(
  rel30,
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
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
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
rel33 <- duckdb$rel_project(
  rel31,
  list(
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
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
rel34 <- duckdb$rel_join(
  rel32,
  rel33,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("c_custkey", rel32), duckdb$expr_reference("o_custkey", rel33))
    )
  ),
  "inner"
)
"inner_join"
rel35 <- duckdb$rel_order(
  rel34,
  list(duckdb$expr_reference("___row_number_x", rel32), duckdb$expr_reference("___row_number_y", rel33))
)
"inner_join"
rel36 <- duckdb$rel_project(
  rel35,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("c_custkey", rel32), duckdb$expr_reference("o_custkey", rel33))
      )
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_nationkey")
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
df4 <- nation
"select"
rel37 <- duckdb$rel_from_df(con, df4, experimental = experimental)
"select"
rel38 <- duckdb$rel_project(
  rel37,
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
"inner_join"
rel39 <- duckdb$rel_set_alias(rel36, "lhs")
"inner_join"
rel40 <- duckdb$rel_set_alias(rel38, "rhs")
"inner_join"
rel41 <- duckdb$rel_project(
  rel39,
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
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
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
rel42 <- duckdb$rel_project(
  rel40,
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
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
rel43 <- duckdb$rel_join(
  rel41,
  rel42,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("c_nationkey", rel41), duckdb$expr_reference("n_nationkey", rel42))
    )
  ),
  "inner"
)
"inner_join"
rel44 <- duckdb$rel_order(
  rel43,
  list(duckdb$expr_reference("___row_number_x", rel41), duckdb$expr_reference("___row_number_y", rel42))
)
"inner_join"
rel45 <- duckdb$rel_project(
  rel44,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("c_nationkey", rel41), duckdb$expr_reference("n_nationkey", rel42))
      )
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
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
rel46 <- duckdb$rel_project(
  rel45,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    }
  )
)
"arrange"
rel47 <- duckdb$rel_project(
  rel46,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
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
rel48 <- duckdb$rel_order(rel47, list(duckdb$expr_reference("revenue"), duckdb$expr_reference("___row_number")))
"arrange"
rel49 <- duckdb$rel_project(
  rel48,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("revenue")
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    }
  )
)
"head"
rel50 <- duckdb$rel_limit(rel49, 20)
rel50
duckdb$rel_to_altrep(rel50)
