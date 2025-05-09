qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS (x == y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "___min_na"(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE MIN(x) END)'
  )
)
invisible(DBI::dbExecute(con, 'CREATE MACRO "n"() AS CAST(COUNT(*) AS int32)'))
df1 <- lineitem
"select"
rel1 <- duckdb$rel_from_df(con, df1)
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
"filter"
rel4 <- duckdb$rel_filter(
  rel3,
  list(
    duckdb$expr_comparison(
      "<",
      list(duckdb$expr_reference("l_commitdate"), duckdb$expr_reference("l_receiptdate"))
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
"select"
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
"select"
rel8 <- duckdb$rel_from_df(con, df2)
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
"filter"
rel11 <- duckdb$rel_filter(
  rel10,
  list(
    duckdb$expr_comparison(
      ">=",
      list(duckdb$expr_reference("o_orderdate"), duckdb$expr_constant(as.Date("1993-07-01")))
    ),
    duckdb$expr_comparison(
      "<",
      list(duckdb$expr_reference("o_orderdate"), duckdb$expr_constant(as.Date("1993-10-01")))
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
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
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
      tmp_expr <- duckdb$expr_reference("o_orderpriority")
      duckdb$expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
"distinct"
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
"distinct"
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
"distinct"
rel24 <- duckdb$rel_filter(
  rel23,
  list(
    duckdb$expr_comparison("==", list(duckdb$expr_reference("___row_number_by"), duckdb$expr_constant(1L)))
  )
)
"distinct"
rel25 <- duckdb$rel_order(rel24, list(duckdb$expr_reference("___row_number")))
"distinct"
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
"select"
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
"summarise"
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
"summarise"
rel29 <- duckdb$rel_aggregate(
  rel28,
  groups = list(duckdb$expr_reference("o_orderpriority")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("___min_na", list(duckdb$expr_reference("___row_number")))
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
"summarise"
rel30 <- duckdb$rel_order(rel29, list(duckdb$expr_reference("___row_number")))
"summarise"
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
"arrange"
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
"arrange"
rel33 <- duckdb$rel_order(
  rel32,
  list(duckdb$expr_reference("o_orderpriority"), duckdb$expr_reference("___row_number"))
)
"arrange"
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
