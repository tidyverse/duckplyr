qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "___eq_na_matches_na"(x, y) AS (x IS NOT DISTINCT FROM y)'
  )
)
invisible(DBI::dbExecute(
  con,
  'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'
))
df1 <- orders
"select"
rel1 <- duckdb$rel_from_df(con, df1)
"select"
rel2 <- duckdb$rel_project(
  rel1,
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_shippriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_shippriority"
      )
      tmp_expr
    }
  )
)
"filter"
rel3 <- duckdb$rel_filter(
  rel2,
  list(
    duckdb$expr_comparison(
      "<",
      list(
        duckdb$expr_reference(
          "o_orderdate"
        ),
        duckdb$expr_constant(as.Date(
          "1995-03-15"
        ))
      )
    )
  )
)
df2 <- customer
"select"
rel4 <- duckdb$rel_from_df(con, df2)
"select"
rel5 <- duckdb$rel_project(
  rel4,
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
        "c_mktsegment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "c_mktsegment"
      )
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
        duckdb$expr_reference(
          "c_mktsegment"
        ),
        duckdb$expr_constant("BUILDING")
      )
    )
  )
)
"inner_join"
rel7 <- duckdb$rel_set_alias(
  rel3,
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
      "___eq_na_matches_na",
      list(
        duckdb$expr_reference(
          "o_custkey",
          rel7
        ),
        duckdb$expr_reference(
          "c_custkey",
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
            rel7
          ),
          duckdb$expr_reference(
            "c_custkey",
            rel8
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_shippriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_shippriority"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "c_mktsegment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "c_mktsegment"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_shippriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_shippriority"
      )
      tmp_expr
    }
  )
)
df3 <- lineitem
"select"
rel12 <- duckdb$rel_from_df(con, df3)
"select"
rel13 <- duckdb$rel_project(
  rel12,
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
        "l_shipdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipdate"
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
"filter"
rel14 <- duckdb$rel_filter(
  rel13,
  list(
    duckdb$expr_comparison(
      ">",
      list(
        duckdb$expr_reference(
          "l_shipdate"
        ),
        duckdb$expr_constant(as.Date(
          "1995-03-15"
        ))
      )
    )
  )
)
"select"
rel15 <- duckdb$rel_project(
  rel14,
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
rel16 <- duckdb$rel_set_alias(
  rel15,
  "lhs"
)
"inner_join"
rel17 <- duckdb$rel_set_alias(
  rel11,
  "rhs"
)
"inner_join"
rel18 <- duckdb$rel_join(
  rel16,
  rel17,
  list(
    duckdb$expr_function(
      "___eq_na_matches_na",
      list(
        duckdb$expr_reference(
          "l_orderkey",
          rel16
        ),
        duckdb$expr_reference(
          "o_orderkey",
          rel17
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel19 <- duckdb$rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "l_orderkey",
            rel16
          ),
          duckdb$expr_reference(
            "o_orderkey",
            rel17
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
        "o_shippriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_shippriority"
      )
      tmp_expr
    }
  )
)
"mutate"
rel20 <- duckdb$rel_project(
  rel19,
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
        "o_shippriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_shippriority"
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
"summarise"
rel21 <- duckdb$rel_aggregate(
  rel20,
  groups = list(
    duckdb$expr_reference("l_orderkey"),
    duckdb$expr_reference(
      "o_orderdate"
    ),
    duckdb$expr_reference(
      "o_shippriority"
    )
  ),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(duckdb$expr_reference(
          "volume"
        ))
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "revenue"
      )
      tmp_expr
    }
  )
)
"select"
rel22 <- duckdb$rel_project(
  rel21,
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
        "revenue"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "revenue"
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
        "o_shippriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_shippriority"
      )
      tmp_expr
    }
  )
)
"arrange"
rel23 <- duckdb$rel_order(
  rel22,
  list(
    duckdb$expr_reference("revenue"),
    duckdb$expr_reference("o_orderdate")
  )
)
"slice_head"
rel24 <- duckdb$rel_limit(rel23, 10)
rel24
duckdb$rel_to_altrep(rel24)
