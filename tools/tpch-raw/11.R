qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">\"(a, b) AS a > b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"desc\"(x) AS (-x)"))
df1 <- nation
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_filter(
  rel1,
  list(
    duckdb:::expr_function(
      "==",
      list(
        duckdb:::expr_reference("n_name"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant("GERMANY", experimental = experimental)
        } else {
          duckdb:::expr_constant("GERMANY")
        }
      )
    )
  )
)
df2 <- partsupp
rel3 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel4 <- duckdb:::rel_set_alias(rel3, "lhs")
df3 <- supplier
rel5 <- duckdb:::rel_from_df(con, df3, experimental = experimental)
rel6 <- duckdb:::rel_set_alias(rel5, "rhs")
rel7 <- duckdb:::rel_join(
  rel4,
  rel6,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_suppkey", rel4), duckdb:::expr_reference("s_suppkey", rel6))
    )
  ),
  "inner"
)
rel8 <- duckdb:::rel_project(
  rel7,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("ps_suppkey", rel4), duckdb:::expr_reference("s_suppkey", rel6))
      )
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_availqty")
      duckdb:::expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_comment")
      duckdb:::expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel9 <- duckdb:::rel_set_alias(rel8, "lhs")
rel10 <- duckdb:::rel_set_alias(rel2, "rhs")
rel11 <- duckdb:::rel_join(
  rel9,
  rel10,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel9), duckdb:::expr_reference("n_nationkey", rel10))
    )
  ),
  "inner"
)
rel12 <- duckdb:::rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_availqty")
      duckdb:::expr_set_alias(tmp_expr, "ps_availqty")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_comment")
      duckdb:::expr_set_alias(tmp_expr, "ps_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("s_nationkey", rel9), duckdb:::expr_reference("n_nationkey", rel10))
      )
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_comment")
      duckdb:::expr_set_alias(tmp_expr, "n_comment")
      tmp_expr
    }
  )
)
rel13 <- duckdb:::rel_aggregate(
  rel12,
  groups = list(),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function(
      "*",
      list(
        duckdb:::expr_function(
          "sum",
          list(
            duckdb:::expr_function(
              "*",
              list(duckdb:::expr_reference("ps_supplycost"), duckdb:::expr_reference("ps_availqty"))
            )
          )
        ),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant(1e-04, experimental = experimental)
        } else {
          duckdb:::expr_constant(1e-04)
        }
      )
    )
    duckdb:::expr_set_alias(tmp_expr, "global_value")
    tmp_expr
  })
)
rel14 <- duckdb:::rel_distinct(rel13)
rel15 <- duckdb:::rel_project(
  rel14,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("global_value")
      duckdb:::expr_set_alias(tmp_expr, "global_value")
      tmp_expr
    },
    {
      tmp_expr <- if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
        duckdb:::expr_constant(1L, experimental = experimental)
      } else {
        duckdb:::expr_constant(1L)
      }
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    }
  )
)
rel16 <- duckdb:::rel_aggregate(
  rel12,
  groups = list(duckdb:::expr_reference("ps_partkey")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function(
      "sum",
      list(
        duckdb:::expr_function(
          "*",
          list(duckdb:::expr_reference("ps_supplycost"), duckdb:::expr_reference("ps_availqty"))
        )
      )
    )
    duckdb:::expr_set_alias(tmp_expr, "value")
    tmp_expr
  })
)
rel17 <- duckdb:::rel_project(
  rel16,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("value")
      duckdb:::expr_set_alias(tmp_expr, "value")
      tmp_expr
    },
    {
      tmp_expr <- if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
        duckdb:::expr_constant(1L, experimental = experimental)
      } else {
        duckdb:::expr_constant(1L)
      }
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    }
  )
)
rel18 <- duckdb:::rel_set_alias(rel17, "lhs")
rel19 <- duckdb:::rel_set_alias(rel15, "rhs")
rel20 <- duckdb:::rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("value")
      duckdb:::expr_set_alias(tmp_expr, "value_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("global_agr_key")
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key_x")
      tmp_expr
    }
  )
)
rel21 <- duckdb:::rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("global_value")
      duckdb:::expr_set_alias(tmp_expr, "global_value_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("global_agr_key")
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key_y")
      tmp_expr
    }
  )
)
rel22 <- duckdb:::rel_join(
  rel20,
  rel21,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("global_agr_key_x", rel20), duckdb:::expr_reference("global_agr_key_y", rel21))
    )
  ),
  "inner"
)
rel23 <- duckdb:::rel_project(
  rel22,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey_x")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("value_x")
      duckdb:::expr_set_alias(tmp_expr, "value")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("global_agr_key_x", rel20), duckdb:::expr_reference("global_agr_key_y", rel21))
      )
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("global_value_y")
      duckdb:::expr_set_alias(tmp_expr, "global_value")
      tmp_expr
    }
  )
)
rel24 <- duckdb:::rel_filter(
  rel23,
  list(
    duckdb:::expr_function(">", list(duckdb:::expr_reference("value"), duckdb:::expr_reference("global_value")))
  )
)
rel25 <- duckdb:::rel_order(rel24, list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("value")))))
rel26 <- duckdb:::rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("value")
      duckdb:::expr_set_alias(tmp_expr, "value")
      tmp_expr
    }
  )
)
rel26
duckdb:::rel_to_altrep(rel26)
