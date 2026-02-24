qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "grepl"(pattern, x) AS (CASE WHEN x IS NULL THEN FALSE ELSE regexp_matches(x, pattern) END)'
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
invisible(duckdb$rapi_load_rfuns(
  drv@database_ref
))
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "___min_na"(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE MIN(x) END)'
  )
)
df1 <- part
"select"
rel1 <- duckdb$rel_from_df(con, df1)
"select"
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "p_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "p_name"
      )
      tmp_expr
    },
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
"filter"
rel3 <- duckdb$rel_project(
  rel2,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "p_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "p_name"
      )
      tmp_expr
    },
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
rel4 <- duckdb$rel_filter(
  rel3,
  list(
    duckdb$expr_function(
      "grepl",
      list(
        duckdb$expr_constant("green"),
        duckdb$expr_reference("p_name")
      )
    )
  )
)
"filter"
rel5 <- duckdb$rel_order(
  rel4,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"filter"
rel6 <- duckdb$rel_project(
  rel5,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "p_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "p_name"
      )
      tmp_expr
    },
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
"select"
rel7 <- duckdb$rel_project(
  rel6,
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
df2 <- partsupp
"select"
rel8 <- duckdb$rel_from_df(con, df2)
"select"
rel9 <- duckdb$rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel10 <- duckdb$rel_set_alias(
  rel9,
  "lhs"
)
"inner_join"
rel11 <- duckdb$rel_set_alias(
  rel7,
  "rhs"
)
"inner_join"
rel12 <- duckdb$rel_project(
  rel10,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
rel13 <- duckdb$rel_project(
  rel11,
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
rel14 <- duckdb$rel_join(
  rel12,
  rel13,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "ps_partkey",
          rel12
        ),
        duckdb$expr_reference(
          "p_partkey",
          rel13
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel15 <- duckdb$rel_order(
  rel14,
  list(
    duckdb$expr_reference(
      "___row_number_x",
      rel12
    ),
    duckdb$expr_reference(
      "___row_number_y",
      rel13
    )
  )
)
"inner_join"
rel16 <- duckdb$rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "ps_partkey",
            rel12
          ),
          duckdb$expr_reference(
            "p_partkey",
            rel13
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
      )
      tmp_expr
    }
  )
)
df3 <- supplier
"select"
rel17 <- duckdb$rel_from_df(con, df3)
"select"
rel18 <- duckdb$rel_project(
  rel17,
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
df4 <- nation
"select"
rel19 <- duckdb$rel_from_df(con, df4)
"select"
rel20 <- duckdb$rel_project(
  rel19,
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
    }
  )
)
"inner_join"
rel21 <- duckdb$rel_set_alias(
  rel18,
  "lhs"
)
"inner_join"
rel22 <- duckdb$rel_set_alias(
  rel20,
  "rhs"
)
"inner_join"
rel23 <- duckdb$rel_project(
  rel21,
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
rel24 <- duckdb$rel_project(
  rel22,
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
rel25 <- duckdb$rel_join(
  rel23,
  rel24,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "s_nationkey",
          rel23
        ),
        duckdb$expr_reference(
          "n_nationkey",
          rel24
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel26 <- duckdb$rel_order(
  rel25,
  list(
    duckdb$expr_reference(
      "___row_number_x",
      rel23
    ),
    duckdb$expr_reference(
      "___row_number_y",
      rel24
    )
  )
)
"inner_join"
rel27 <- duckdb$rel_project(
  rel26,
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
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "s_nationkey",
            rel23
          ),
          duckdb$expr_reference(
            "n_nationkey",
            rel24
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
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_name"
      )
      tmp_expr
    }
  )
)
"select"
rel28 <- duckdb$rel_project(
  rel27,
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
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_name"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel29 <- duckdb$rel_set_alias(
  rel16,
  "lhs"
)
"inner_join"
rel30 <- duckdb$rel_set_alias(
  rel28,
  "rhs"
)
"inner_join"
rel31 <- duckdb$rel_project(
  rel29,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
rel32 <- duckdb$rel_project(
  rel30,
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
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "n_name"
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
rel33 <- duckdb$rel_join(
  rel31,
  rel32,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "ps_suppkey",
          rel31
        ),
        duckdb$expr_reference(
          "s_suppkey",
          rel32
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel34 <- duckdb$rel_order(
  rel33,
  list(
    duckdb$expr_reference(
      "___row_number_x",
      rel31
    ),
    duckdb$expr_reference(
      "___row_number_y",
      rel32
    )
  )
)
"inner_join"
rel35 <- duckdb$rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "ps_suppkey",
            rel31
          ),
          duckdb$expr_reference(
            "s_suppkey",
            rel32
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
    }
  )
)
df5 <- lineitem
"select"
rel36 <- duckdb$rel_from_df(con, df5)
"select"
rel37 <- duckdb$rel_project(
  rel36,
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
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
      )
      tmp_expr
    }
  )
)
"inner_join"
rel38 <- duckdb$rel_set_alias(
  rel37,
  "lhs"
)
"inner_join"
rel39 <- duckdb$rel_set_alias(
  rel35,
  "rhs"
)
"inner_join"
rel40 <- duckdb$rel_project(
  rel38,
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
        "l_quantity"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "l_quantity"
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
rel41 <- duckdb$rel_project(
  rel39,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_suppkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_suppkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_partkey"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_partkey"
      )
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference(
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
rel42 <- duckdb$rel_join(
  rel40,
  rel41,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "l_suppkey",
          rel40
        ),
        duckdb$expr_reference(
          "ps_suppkey",
          rel41
        )
      )
    ),
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "l_partkey",
          rel40
        ),
        duckdb$expr_reference(
          "ps_partkey",
          rel41
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel43 <- duckdb$rel_order(
  rel42,
  list(
    duckdb$expr_reference(
      "___row_number_x",
      rel40
    ),
    duckdb$expr_reference(
      "___row_number_y",
      rel41
    )
  )
)
"inner_join"
rel44 <- duckdb$rel_project(
  rel43,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "l_suppkey",
            rel40
          ),
          duckdb$expr_reference(
            "ps_suppkey",
            rel41
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
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "l_partkey",
            rel40
          ),
          duckdb$expr_reference(
            "ps_partkey",
            rel41
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
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
    }
  )
)
"select"
rel45 <- duckdb$rel_project(
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
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
    }
  )
)
df6 <- orders
"select"
rel46 <- duckdb$rel_from_df(con, df6)
"select"
rel47 <- duckdb$rel_project(
  rel46,
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
"inner_join"
rel48 <- duckdb$rel_set_alias(
  rel47,
  "lhs"
)
"inner_join"
rel49 <- duckdb$rel_set_alias(
  rel45,
  "rhs"
)
"inner_join"
rel50 <- duckdb$rel_project(
  rel48,
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
rel51 <- duckdb$rel_project(
  rel49,
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
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
rel52 <- duckdb$rel_join(
  rel50,
  rel51,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference(
          "o_orderkey",
          rel50
        ),
        duckdb$expr_reference(
          "l_orderkey",
          rel51
        )
      )
    )
  ),
  "inner"
)
"inner_join"
rel53 <- duckdb$rel_order(
  rel52,
  list(
    duckdb$expr_reference(
      "___row_number_x",
      rel50
    ),
    duckdb$expr_reference(
      "___row_number_y",
      rel51
    )
  )
)
"inner_join"
rel54 <- duckdb$rel_project(
  rel53,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(
          duckdb$expr_reference(
            "o_orderkey",
            rel50
          ),
          duckdb$expr_reference(
            "l_orderkey",
            rel51
          )
        )
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
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
    }
  )
)
"select"
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
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
"mutate"
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
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
        "n_name"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
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
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
        "nation"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
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
        "ps_supplycost"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "ps_supplycost"
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
        "nation"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
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
        "-",
        list(
          duckdb$expr_function(
            "*",
            list(
              duckdb$expr_reference(
                "l_extendedprice"
              ),
              duckdb$expr_function(
                "-",
                list(
                  duckdb$expr_constant(
                    1
                  ),
                  duckdb$expr_reference(
                    "l_discount"
                  )
                )
              )
            )
          ),
          duckdb$expr_function(
            "*",
            list(
              duckdb$expr_reference(
                "ps_supplycost"
              ),
              duckdb$expr_reference(
                "l_quantity"
              )
            )
          )
        )
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "amount"
      )
      tmp_expr
    }
  )
)
"select"
rel59 <- duckdb$rel_project(
  rel58,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "nation"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
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
        "amount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "amount"
      )
      tmp_expr
    }
  )
)
"summarise"
rel60 <- duckdb$rel_project(
  rel59,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "nation"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
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
        "amount"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "amount"
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
rel61 <- duckdb$rel_aggregate(
  rel60,
  groups = list(
    duckdb$expr_reference("nation"),
    duckdb$expr_reference("o_year")
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
        "sum",
        list(duckdb$expr_reference(
          "amount"
        ))
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "sum_profit"
      )
      tmp_expr
    }
  )
)
"summarise"
rel62 <- duckdb$rel_order(
  rel61,
  list(duckdb$expr_reference(
    "___row_number"
  ))
)
"summarise"
rel63 <- duckdb$rel_project(
  rel62,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "nation"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
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
        "sum_profit"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "sum_profit"
      )
      tmp_expr
    }
  )
)
"arrange"
rel64 <- duckdb$rel_project(
  rel63,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "nation"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
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
        "sum_profit"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "sum_profit"
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
rel65 <- duckdb$rel_order(
  rel64,
  list(
    duckdb$expr_reference("nation"),
    duckdb$expr_reference("o_year"),
    duckdb$expr_reference(
      "___row_number"
    )
  )
)
"arrange"
rel66 <- duckdb$rel_project(
  rel65,
  list(
    {
      tmp_expr <- duckdb$expr_reference(
        "nation"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "nation"
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
        "sum_profit"
      )
      duckdb$expr_set_alias(
        tmp_expr,
        "sum_profit"
      )
      tmp_expr
    }
  )
)
rel66
duckdb$rel_to_altrep(rel66)
