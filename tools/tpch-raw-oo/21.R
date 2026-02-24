qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(DBI::dbExecute(
  con,
  'CREATE MACRO "n"() AS CAST(COUNT(*) AS int32)'
))
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "___min_na"(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE MIN(x) END)'
  )
)
invisible(DBI::dbExecute(
  con,
  'CREATE MACRO "=="(x, y) AS (x == y)'
))
invisible(DBI::dbExecute(
  con,
  'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'
))
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "___any_na"(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE bool_or(x) END)'
  )
)
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "if_else"(test, yes, no) AS (CASE WHEN test IS NULL THEN NULL ELSE CASE WHEN test THEN yes ELSE no END END)'
  )
)
invisible(DBI::dbExecute(
  con,
  'CREATE MACRO "&"(x, y) AS (x AND y)'
))
df1 <- lineitem
"count"
rel1 <- duckdb$rel_from_df(con, df1)
"count"
rel2 <- duckdb$rel_aggregate(
  rel1,
  groups = list(
    l_orderkey = {
      tmp_expr <- duckdb$expr_reference(
        "l_orderkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_orderkey"
      )
      tmp_expr
    },
    l_suppkey = {
      tmp_expr <- duckdb$expr_reference(
        "l_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_suppkey"
      )
      tmp_expr
    }
  ),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "n",
        list()
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n"
      )
      tmp_expr
    }
  )
)
"count"
rel3 <- duckdb$rel_order(
  rel2,
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
        "l_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_suppkey"
      )
      tmp_expr
    }
  )
)
"summarise"
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
        "n"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"summarise"
rel5 <- duckdb$rel_aggregate(
  rel4,
  groups = list(duckdb$expr_reference(
    "l_orderkey"
  )),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "___min_na",
        list(duckdb$expr_reference(
          "___row_number"
        ))
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "n",
        list()
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_supplier"
      )
      tmp_expr
    }
  )
)
"summarise"
rel6 <- duckdb$rel_order(
  rel5,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"summarise"
rel7 <- duckdb$rel_project(
  rel6,
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
        "n_supplier"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_supplier"
      )
      tmp_expr
    }
  )
)
"filter"
rel8 <- duckdb$rel_project(
  rel7,
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
        "n_supplier"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_supplier"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"filter"
rel9 <- duckdb$rel_filter(
  rel8,
  list(
    duckdb$expr_comparison(
      ">",
      list(
        duckdb$expr_reference(
          "n_supplier"
        ),
        duckdb$expr_constant(1)
      )
    )
  )
)
"filter"
rel10 <- duckdb$rel_order(
  rel9,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"filter"
rel11 <- duckdb$rel_project(
  rel10,
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
        "n_supplier"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_supplier"
      )
      tmp_expr
    }
  )
)
"semi_join"
rel12 <- duckdb$rel_from_df(con, df1)
"semi_join"
rel13 <- duckdb$rel_set_alias(
  rel12,
  "lhs"
)
"semi_join"
rel14 <- duckdb$rel_set_alias(
  rel11,
  "rhs"
)
"semi_join"
rel15 <- duckdb$rel_project(
  rel13,
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number_x"
      )
      tmp_expr
    }
  )
)
"semi_join"
rel16 <- duckdb$rel_join(
  rel15,
  rel14,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "l_orderkey",
          rel15
        ),
        duckdb$expr_reference(
          "l_orderkey",
          rel14
        )
      )
    )
  ),
  "semi"
)
"semi_join"
rel17 <- duckdb$rel_order(
  rel16,
  list(duckdb$expr_reference(
    "___row_number_x",
    rel15
  ))
)
"semi_join"
rel18 <- duckdb$rel_project(
  rel17,
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel19 <- duckdb$rel_set_alias(
  rel18,
  "lhs"
)
df2 <- orders
"inner_join"
rel20 <- duckdb$rel_from_df(con, df2)
"inner_join"
rel21 <- duckdb$rel_set_alias(
  rel20,
  "rhs"
)
"inner_join"
rel22 <- duckdb$rel_project(
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number_x"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel23 <- duckdb$rel_project(
  rel21,
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
        "o_orderstatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderstatus"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_totalprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_totalprice"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_clerk"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_clerk"
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
        "o_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number_y"
      )
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
      list(
        duckdb$expr_reference(
          "l_orderkey",
          rel22
        ),
        duckdb$expr_reference(
          "o_orderkey",
          rel23
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel25 <- duckdb$rel_order(
  rel24,
  list(
    duckdb$expr_reference(
      "___row_number_x",
      rel22
    ),
    duckdb$expr_reference(
      "___row_number_y",
      rel23
    )
  )
)
"inner_join"
rel26 <- duckdb$rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "l_orderkey",
            rel22
          ),
          duckdb$expr_reference(
            "o_orderkey",
            rel23
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
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
        "o_orderstatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderstatus"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_totalprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_totalprice"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_clerk"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_clerk"
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
        "o_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_comment"
      )
      tmp_expr
    }
  )
)
"filter"
rel27 <- duckdb$rel_project(
  rel26,
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
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
        "o_orderstatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderstatus"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_totalprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_totalprice"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_clerk"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_clerk"
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
        "o_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"filter"
rel28 <- duckdb$rel_filter(
  rel27,
  list(
    duckdb$expr_comparison(
      "==",
      list(
        duckdb$expr_reference(
          "o_orderstatus"
        ),
        duckdb$expr_constant("F")
      )
    )
  )
)
"filter"
rel29 <- duckdb$rel_order(
  rel28,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"filter"
rel30 <- duckdb$rel_project(
  rel29,
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
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
        "o_orderstatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderstatus"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_totalprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_totalprice"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_clerk"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_clerk"
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
        "o_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_comment"
      )
      tmp_expr
    }
  )
)
"summarise"
rel31 <- duckdb$rel_project(
  rel30,
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
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
        "o_orderstatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_orderstatus"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_totalprice"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_totalprice"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "o_clerk"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_clerk"
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
        "o_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "o_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"summarise"
rel32 <- duckdb$rel_aggregate(
  rel31,
  groups = list(
    duckdb$expr_reference("l_orderkey"),
    duckdb$expr_reference("l_suppkey")
  ),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "___min_na",
        list(duckdb$expr_reference(
          "___row_number"
        ))
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___any_na",
        list(
          duckdb$expr_comparison(
            ">",
            list(
              duckdb$expr_reference(
                "l_receiptdate"
              ),
              duckdb$expr_reference(
                "l_commitdate"
              )
            )
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "failed_delivery_commit"
      )
      tmp_expr
    }
  )
)
"summarise"
rel33 <- duckdb$rel_order(
  rel32,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"summarise"
rel34 <- duckdb$rel_project(
  rel33,
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
        "failed_delivery_commit"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "failed_delivery_commit"
      )
      tmp_expr
    }
  )
)
"summarise"
rel35 <- duckdb$rel_project(
  rel34,
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
        "failed_delivery_commit"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "failed_delivery_commit"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"summarise"
rel36 <- duckdb$rel_aggregate(
  rel35,
  groups = list(duckdb$expr_reference(
    "l_orderkey"
  )),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "___min_na",
        list(duckdb$expr_reference(
          "___row_number"
        ))
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "n",
        list()
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_supplier"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "if_else",
            list(
              duckdb$expr_reference(
                "failed_delivery_commit"
              ),
              duckdb$expr_constant(1),
              duckdb$expr_constant(0)
            )
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "num_failed"
      )
      tmp_expr
    }
  )
)
"summarise"
rel37 <- duckdb$rel_order(
  rel36,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"summarise"
rel38 <- duckdb$rel_project(
  rel37,
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
        "n_supplier"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_supplier"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "num_failed"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "num_failed"
      )
      tmp_expr
    }
  )
)
"filter"
rel39 <- duckdb$rel_project(
  rel38,
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
        "n_supplier"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_supplier"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "num_failed"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "num_failed"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"filter"
rel40 <- duckdb$rel_filter(
  rel39,
  list(
    duckdb$expr_function(
      "&",
      list(
        duckdb$expr_comparison(
          ">",
          list(
            duckdb$expr_reference(
              "n_supplier"
            ),
            duckdb$expr_constant(1)
          )
        ),
        duckdb$expr_comparison(
          "==",
          list(
            duckdb$expr_reference(
              "num_failed"
            ),
            duckdb$expr_constant(1)
          )
        )
      )
    )
  )
)
"filter"
rel41 <- duckdb$rel_order(
  rel40,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"filter"
rel42 <- duckdb$rel_project(
  rel41,
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
        "n_supplier"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_supplier"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "num_failed"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "num_failed"
      )
      tmp_expr
    }
  )
)
"semi_join"
rel43 <- duckdb$rel_from_df(con, df1)
"semi_join"
rel44 <- duckdb$rel_set_alias(
  rel43,
  "lhs"
)
"semi_join"
rel45 <- duckdb$rel_set_alias(
  rel42,
  "rhs"
)
"semi_join"
rel46 <- duckdb$rel_project(
  rel44,
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number_x"
      )
      tmp_expr
    }
  )
)
"semi_join"
rel47 <- duckdb$rel_join(
  rel46,
  rel45,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "l_orderkey",
          rel46
        ),
        duckdb$expr_reference(
          "l_orderkey",
          rel45
        )
      )
    )
  ),
  "semi"
)
"semi_join"
rel48 <- duckdb$rel_order(
  rel47,
  list(duckdb$expr_reference(
    "___row_number_x",
    rel46
  ))
)
"semi_join"
rel49 <- duckdb$rel_project(
  rel48,
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    }
  )
)
df3 <- supplier
"inner_join"
rel50 <- duckdb$rel_from_df(con, df3)
"inner_join"
rel51 <- duckdb$rel_set_alias(
  rel50,
  "lhs"
)
"inner_join"
rel52 <- duckdb$rel_set_alias(
  rel49,
  "rhs"
)
"inner_join"
rel53 <- duckdb$rel_project(
  rel51,
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
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number_x"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel54 <- duckdb$rel_project(
  rel52,
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number_y"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel55 <- duckdb$rel_join(
  rel53,
  rel54,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "s_suppkey",
          rel53
        ),
        duckdb$expr_reference(
          "l_suppkey",
          rel54
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel56 <- duckdb$rel_order(
  rel55,
  list(
    duckdb$expr_reference(
      "___row_number_x",
      rel53
    ),
    duckdb$expr_reference(
      "___row_number_y",
      rel54
    )
  )
)
"inner_join"
rel57 <- duckdb$rel_project(
  rel56,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "s_suppkey",
            rel53
          ),
          duckdb$expr_reference(
            "l_suppkey",
            rel54
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    }
  )
)
"filter"
rel58 <- duckdb$rel_project(
  rel57,
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
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"filter"
rel59 <- duckdb$rel_filter(
  rel58,
  list(
    duckdb$expr_comparison(
      ">",
      list(
        duckdb$expr_reference(
          "l_receiptdate"
        ),
        duckdb$expr_reference(
          "l_commitdate"
        )
      )
    )
  )
)
"filter"
rel60 <- duckdb$rel_order(
  rel59,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"filter"
rel61 <- duckdb$rel_project(
  rel60,
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
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel62 <- duckdb$rel_set_alias(
  rel61,
  "lhs"
)
df4 <- nation
"inner_join"
rel63 <- duckdb$rel_from_df(con, df4)
"inner_join"
rel64 <- duckdb$rel_set_alias(
  rel63,
  "rhs"
)
"inner_join"
rel65 <- duckdb$rel_project(
  rel62,
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
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number_x"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel66 <- duckdb$rel_project(
  rel64,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "n_nationkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_nationkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_regionkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_regionkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number_y"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel67 <- duckdb$rel_join(
  rel65,
  rel66,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "s_nationkey",
          rel65
        ),
        duckdb$expr_reference(
          "n_nationkey",
          rel66
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel68 <- duckdb$rel_order(
  rel67,
  list(
    duckdb$expr_reference(
      "___row_number_x",
      rel65
    ),
    duckdb$expr_reference(
      "___row_number_y",
      rel66
    )
  )
)
"inner_join"
rel69 <- duckdb$rel_project(
  rel68,
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
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "s_nationkey",
            rel65
          ),
          duckdb$expr_reference(
            "n_nationkey",
            rel66
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
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_regionkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_regionkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_comment"
      )
      tmp_expr
    }
  )
)
"filter"
rel70 <- duckdb$rel_project(
  rel69,
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
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_regionkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_regionkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"filter"
rel71 <- duckdb$rel_filter(
  rel70,
  list(
    duckdb$expr_comparison(
      "==",
      list(
        duckdb$expr_reference("n_name"),
        duckdb$expr_constant(
          "SAUDI ARABIA"
        )
      )
    )
  )
)
"filter"
rel72 <- duckdb$rel_order(
  rel71,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"filter"
rel73 <- duckdb$rel_project(
  rel72,
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
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_regionkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_regionkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_comment"
      )
      tmp_expr
    }
  )
)
"summarise"
rel74 <- duckdb$rel_project(
  rel73,
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
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_address"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_address"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_phone"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_phone"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_acctbal"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_acctbal"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "s_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_comment"
      )
      tmp_expr
    },
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
        "l_linenumber"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linenumber"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
        "l_tax"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_tax"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_returnflag"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_returnflag"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_linestatus"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_linestatus"
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
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipinstruct"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipinstruct"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_shipmode"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_shipmode"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "l_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_regionkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_regionkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "n_comment"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_comment"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"summarise"
rel75 <- duckdb$rel_aggregate(
  rel74,
  groups = list(duckdb$expr_reference(
    "s_name"
  )),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "___min_na",
        list(duckdb$expr_reference(
          "___row_number"
        ))
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "n",
        list()
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "numwait"
      )
      tmp_expr
    }
  )
)
"summarise"
rel76 <- duckdb$rel_order(
  rel75,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"summarise"
rel77 <- duckdb$rel_project(
  rel76,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "numwait"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "numwait"
      )
      tmp_expr
    }
  )
)
"arrange"
rel78 <- duckdb$rel_project(
  rel77,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "numwait"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "numwait"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(
        duckdb$expr_function(
          "row_number",
          list()
        ),
        list(),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "___row_number"
      )
      tmp_expr
    }
  )
)
"arrange"
rel79 <- duckdb$rel_order(
  rel78,
  list(
    duckdb$expr_reference("numwait"),
    duckdb$expr_reference("s_name"),
    duckdb$expr_reference(
      "___row_number"
    )
  )
)
"arrange"
rel80 <- duckdb$rel_project(
  rel79,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "s_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "s_name"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "numwait"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "numwait"
      )
      tmp_expr
    }
  )
)
"slice_head"
rel81 <- duckdb$rel_limit(rel80, 100)
rel81
duckdb$rel_to_altrep(rel81)
