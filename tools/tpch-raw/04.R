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
invisible(DBI::dbExecute(
  con,
  'CREATE MACRO "n"() AS CAST(COUNT(*) AS int32)'
))
df1 <- lineitem
"select"
rel1 <- duckdb$rel_from_df(con, df1)
"select"
rel2 <- duckdb$rel_project(
  rel1,
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
        "l_commitdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_commitdate"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_receiptdate"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_receiptdate"
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
          "l_commitdate"
        ),
        duckdb$expr_reference(
          "l_receiptdate"
        )
      )
    )
  )
)
"select"
rel4 <- duckdb$rel_project(
  rel3,
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
    }
  )
)
df2 <- orders
"select"
rel5 <- duckdb$rel_from_df(con, df2)
"select"
rel6 <- duckdb$rel_project(
  rel5,
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
        "o_orderpriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderpriority"
      )
      tmp_expr
    }
  )
)
"filter"
rel7 <- duckdb$rel_filter(
  rel6,
  list(
    duckdb$expr_comparison(
      ">=",
      list(
        duckdb$expr_reference(
          "o_orderdate"
        ),
        duckdb$expr_constant(as.Date(
          "1993-07-01"
        ))
      )
    ),
    duckdb$expr_comparison(
      "<",
      list(
        duckdb$expr_reference(
          "o_orderdate"
        ),
        duckdb$expr_constant(as.Date(
          "1993-10-01"
        ))
      )
    )
  )
)
"select"
rel8 <- duckdb$rel_project(
  rel7,
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
        "o_orderpriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderpriority"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel9 <- duckdb$rel_set_alias(
  rel4,
  "lhs"
)
"inner_join"
rel10 <- duckdb$rel_set_alias(
  rel8,
  "rhs"
)
"inner_join"
rel11 <- duckdb$rel_join(
  rel9,
  rel10,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "l_orderkey",
          rel9
        ),
        duckdb$expr_reference(
          "o_orderkey",
          rel10
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel12 <- duckdb$rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "l_orderkey",
            rel9
          ),
          duckdb$expr_reference(
            "o_orderkey",
            rel10
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
        "o_orderpriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderpriority"
      )
      tmp_expr
    }
  )
)
"distinct"
rel13 <- duckdb$rel_distinct(rel12)
"select"
rel14 <- duckdb$rel_project(
  rel13,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "o_orderpriority"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderpriority"
      )
      tmp_expr
    }
  )
)
"summarise"
rel15 <- duckdb$rel_aggregate(
  rel14,
  groups = list(duckdb$expr_reference(
    "o_orderpriority"
  )),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "n",
        list()
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "order_count"
      )
      tmp_expr
    }
  )
)
"arrange"
rel16 <- duckdb$rel_order(
  rel15,
  list(duckdb$expr_reference(
    "o_orderpriority"
  ))
)
rel16
duckdb$rel_to_altrep(rel16)
