qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
df1 <- nation
"filter"
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"filter"
rel2 <- duckdb$rel_filter(
  rel1,
  list(
    duckdb$expr_comparison(
      cmp_op = "==",
      exprs = list(
        duckdb$expr_reference("n_name"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("GERMANY", experimental = experimental)
        } else {
          duckdb$expr_constant("GERMANY")
        }
      )
    )
  )
)
df2 <- partsupp
"inner_join"
rel3 <- duckdb$rel_from_df(con, df2, experimental = experimental)
"inner_join"
rel4 <- duckdb$rel_set_alias(rel3, "lhs")
df3 <- supplier
"inner_join"
rel5 <- duckdb$rel_from_df(con, df3, experimental = experimental)
"inner_join"
rel6 <- duckdb$rel_set_alias(rel5, "rhs")
"inner_join"
rel7 <- duckdb$rel_join(
  rel4,
  rel6,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("ps_suppkey", rel4), duckdb$expr_reference("s_suppkey", rel6))
    )
  ),
  "inner"
)
"inner_join"
rel8 <- duckdb$rel_project(
  rel7,
  list(
    {
      tmp_expr <- duckdb$expr_reference("ps_partkey")
      duckdb$expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("ps_suppkey", rel4), duckdb$expr_reference("s_suppkey", rel6))
      )
      duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_availqty")
      duckdb$expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_comment")
      duckdb$expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_name")
      duckdb$expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_address")
      duckdb$expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_phone")
      duckdb$expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
"inner_join"
rel9 <- duckdb$rel_set_alias(rel8, "lhs")
"inner_join"
rel10 <- duckdb$rel_set_alias(rel2, "rhs")
"inner_join"
rel11 <- duckdb$rel_join(
  rel9,
  rel10,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("s_nationkey", rel9), duckdb$expr_reference("n_nationkey", rel10))
    )
  ),
  "inner"
)
"inner_join"
rel12 <- duckdb$rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb$expr_reference("ps_partkey")
      duckdb$expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_suppkey")
      duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_availqty")
      duckdb$expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_comment")
      duckdb$expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_name")
      duckdb$expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_address")
      duckdb$expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("s_nationkey", rel9), duckdb$expr_reference("n_nationkey", rel10))
      )
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_phone")
      duckdb$expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_regionkey")
      duckdb$expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_comment")
      duckdb$expr_set_alias(tmp_expr, "n_comment")
      tmp_expr
    }
  )
)
"summarise"
rel13 <- duckdb$rel_aggregate(
  rel12,
  groups = list(),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "*",
        list(
          duckdb$expr_function(
            "sum",
            list(
              duckdb$expr_function(
                "*",
                list(duckdb$expr_reference("ps_supplycost"), duckdb$expr_reference("ps_availqty"))
              )
            )
          ),
          if ("experimental" %in% names(formals(duckdb$expr_constant))) {
            duckdb$expr_constant(1e-04, experimental = experimental)
          } else {
            duckdb$expr_constant(1e-04)
          }
        )
      )
      duckdb$expr_set_alias(tmp_expr, "global_value")
      tmp_expr
    }
  )
)
"summarise"
rel14 <- duckdb$rel_distinct(rel13)
"mutate"
rel15 <- duckdb$rel_project(
  rel14,
  list(
    {
      tmp_expr <- duckdb$expr_reference("global_value")
      duckdb$expr_set_alias(tmp_expr, "global_value")
      tmp_expr
    },
    {
      tmp_expr <- if ("experimental" %in% names(formals(duckdb$expr_constant))) {
        duckdb$expr_constant(1L, experimental = experimental)
      } else {
        duckdb$expr_constant(1L)
      }
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    }
  )
)
"summarise"
rel16 <- duckdb$rel_aggregate(
  rel12,
  groups = list(duckdb$expr_reference("ps_partkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "*",
            list(duckdb$expr_reference("ps_supplycost"), duckdb$expr_reference("ps_availqty"))
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "value")
      tmp_expr
    }
  )
)
"mutate"
rel17 <- duckdb$rel_project(
  rel16,
  list(
    {
      tmp_expr <- duckdb$expr_reference("ps_partkey")
      duckdb$expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("value")
      duckdb$expr_set_alias(tmp_expr, "value")
      tmp_expr
    },
    {
      tmp_expr <- if ("experimental" %in% names(formals(duckdb$expr_constant))) {
        duckdb$expr_constant(1L, experimental = experimental)
      } else {
        duckdb$expr_constant(1L)
      }
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    }
  )
)
"inner_join"
rel18 <- duckdb$rel_set_alias(rel17, "lhs")
"inner_join"
rel19 <- duckdb$rel_set_alias(rel15, "rhs")
"inner_join"
rel20 <- duckdb$rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb$expr_reference("ps_partkey")
      duckdb$expr_set_alias(tmp_expr, "ps_partkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("value")
      duckdb$expr_set_alias(tmp_expr, "value_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key_x")
      tmp_expr
    }
  )
)
"inner_join"
rel21 <- duckdb$rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb$expr_reference("global_value")
      duckdb$expr_set_alias(tmp_expr, "global_value_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key_y")
      tmp_expr
    }
  )
)
"inner_join"
rel22 <- duckdb$rel_join(
  rel20,
  rel21,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("global_agr_key_x", rel20), duckdb$expr_reference("global_agr_key_y", rel21))
    )
  ),
  "inner"
)
"inner_join"
rel23 <- duckdb$rel_project(
  rel22,
  list(
    {
      tmp_expr <- duckdb$expr_reference("ps_partkey_x")
      duckdb$expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("value_x")
      duckdb$expr_set_alias(tmp_expr, "value")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("global_agr_key_x", rel20), duckdb$expr_reference("global_agr_key_y", rel21))
      )
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_value_y")
      duckdb$expr_set_alias(tmp_expr, "global_value")
      tmp_expr
    }
  )
)
"filter"
rel24 <- duckdb$rel_filter(
  rel23,
  list(
    duckdb$expr_comparison(
      cmp_op = ">",
      exprs = list(duckdb$expr_reference("value"), duckdb$expr_reference("global_value"))
    )
  )
)
"arrange"
rel25 <- duckdb$rel_order(rel24, list(duckdb$expr_reference("value")))
"select"
rel26 <- duckdb$rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb$expr_reference("ps_partkey")
      duckdb$expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("value")
      duckdb$expr_set_alias(tmp_expr, "value")
      tmp_expr
    }
  )
)
rel26
duckdb$rel_to_altrep(rel26)
