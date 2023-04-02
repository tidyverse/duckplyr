load("tools/tpch/001.rda")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"sum\"(x) AS (CASE WHEN SUM(x) IS NULL THEN 0 ELSE SUM(x) END)")
)
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
  list(),
  list(
    global_value = {
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
    }
  )
)
rel14 <- duckdb:::rel_project(
  rel13,
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
rel15 <- duckdb:::rel_aggregate(
  rel12,
  list(duckdb:::expr_reference("ps_partkey")),
  list(
    value = {
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
    }
  )
)
rel16 <- duckdb:::rel_project(
  rel15,
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
rel17 <- duckdb:::rel_set_alias(rel16, "lhs")
rel18 <- duckdb:::rel_set_alias(rel14, "rhs")
rel19 <- duckdb:::rel_project(
  rel17,
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
rel20 <- duckdb:::rel_project(
  rel18,
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
rel21 <- duckdb:::rel_join(
  rel19,
  rel20,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("global_agr_key_x", rel19), duckdb:::expr_reference("global_agr_key_y", rel20))
    )
  ),
  "inner"
)
rel22 <- duckdb:::rel_project(
  rel21,
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
      tmp_expr <- duckdb:::expr_reference("global_agr_key_x")
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
rel23 <- duckdb:::rel_filter(
  rel22,
  list(
    duckdb:::expr_function(">", list(duckdb:::expr_reference("value"), duckdb:::expr_reference("global_value")))
  )
)
rel24 <- duckdb:::rel_order(rel23, list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("value")))))
rel25 <- duckdb:::rel_project(
  rel24,
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
rel25
duckdb:::rel_to_altrep(rel25)
