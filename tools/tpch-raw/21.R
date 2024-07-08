qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
invisible(DBI::dbExecute(con, 'CREATE MACRO "n"() AS CAST(COUNT(*) AS int32)'))
invisible(duckdb$rapi_load_rfuns(drv@database_ref))
invisible(DBI::dbExecute(con, 'CREATE MACRO ">"(x, y) AS "r_base::>"(x, y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS "r_base::=="(x, y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "any"(x) AS (bool_or(x))'))
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "if_else"(test, yes, no) AS (CASE WHEN test THEN yes ELSE no END)'
  )
)
invisible(DBI::dbExecute(con, 'CREATE MACRO "&"(x, y) AS (x AND y)'))
df1 <- lineitem
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb$rel_aggregate(
  rel1,
  groups = list(
    l_orderkey = {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    l_suppkey = {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    }
  ),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("n", list())
      duckdb$expr_set_alias(tmp_expr, "n")
      tmp_expr
    }
  )
)
rel3 <- duckdb$rel_order(
  rel2,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    }
  )
)
rel4 <- duckdb$rel_aggregate(
  rel3,
  groups = list(duckdb$expr_reference("l_orderkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("n", list())
      duckdb$expr_set_alias(tmp_expr, "n_supplier")
      tmp_expr
    }
  )
)
rel5 <- duckdb$rel_filter(
  rel4,
  list(
    duckdb$expr_function(
      ">",
      list(
        duckdb$expr_reference("n_supplier"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(1, experimental = experimental)
        } else {
          duckdb$expr_constant(1)
        }
      )
    )
  )
)
rel6 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel7 <- duckdb$rel_set_alias(rel6, "lhs")
rel8 <- duckdb$rel_set_alias(rel5, "rhs")
rel9 <- duckdb$rel_join(
  rel7,
  rel8,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_orderkey", rel7), duckdb$expr_reference("l_orderkey", rel8))
    )
  ),
  "semi"
)
rel10 <- duckdb$rel_set_alias(rel9, "lhs")
df2 <- orders
rel11 <- duckdb$rel_from_df(con, df2, experimental = experimental)
rel12 <- duckdb$rel_set_alias(rel11, "rhs")
rel13 <- duckdb$rel_join(
  rel10,
  rel12,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_orderkey", rel10), duckdb$expr_reference("o_orderkey", rel12))
    )
  ),
  "inner"
)
rel14 <- duckdb$rel_project(
  rel13,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_orderkey", rel10), duckdb$expr_reference("o_orderkey", rel12))
      )
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_partkey")
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linenumber")
      duckdb$expr_set_alias(tmp_expr, "l_linenumber")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb$expr_reference("l_tax")
      duckdb$expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
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
      tmp_expr <- duckdb$expr_reference("l_shipinstruct")
      duckdb$expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_shipmode")
      duckdb$expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_comment")
      duckdb$expr_set_alias(tmp_expr, "l_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_custkey")
      duckdb$expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderstatus")
      duckdb$expr_set_alias(tmp_expr, "o_orderstatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_totalprice")
      duckdb$expr_set_alias(tmp_expr, "o_totalprice")
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
      tmp_expr <- duckdb$expr_reference("o_clerk")
      duckdb$expr_set_alias(tmp_expr, "o_clerk")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_shippriority")
      duckdb$expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_comment")
      duckdb$expr_set_alias(tmp_expr, "o_comment")
      tmp_expr
    }
  )
)
rel15 <- duckdb$rel_filter(
  rel14,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference("o_orderstatus"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("F", experimental = experimental)
        } else {
          duckdb$expr_constant("F")
        }
      )
    )
  )
)
rel16 <- duckdb$rel_aggregate(
  rel15,
  groups = list(duckdb$expr_reference("l_orderkey"), duckdb$expr_reference("l_suppkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "any",
        list(
          duckdb$expr_function(
            ">",
            list(duckdb$expr_reference("l_receiptdate"), duckdb$expr_reference("l_commitdate"))
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "failed_delivery_commit")
      tmp_expr
    }
  )
)
rel17 <- duckdb$rel_aggregate(
  rel16,
  groups = list(duckdb$expr_reference("l_orderkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("n", list())
      duckdb$expr_set_alias(tmp_expr, "n_supplier")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "if_else",
            list(
              duckdb$expr_reference("failed_delivery_commit"),
              if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                duckdb$expr_constant(1, experimental = experimental)
              } else {
                duckdb$expr_constant(1)
              },
              if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                duckdb$expr_constant(0, experimental = experimental)
              } else {
                duckdb$expr_constant(0)
              }
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "num_failed")
      tmp_expr
    }
  )
)
rel18 <- duckdb$rel_filter(
  rel17,
  list(
    duckdb$expr_function(
      "&",
      list(
        duckdb$expr_function(
          ">",
          list(
            duckdb$expr_reference("n_supplier"),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant(1, experimental = experimental)
            } else {
              duckdb$expr_constant(1)
            }
          )
        ),
        duckdb$expr_function(
          "==",
          list(
            duckdb$expr_reference("num_failed"),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant(1, experimental = experimental)
            } else {
              duckdb$expr_constant(1)
            }
          )
        )
      )
    )
  )
)
rel19 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel20 <- duckdb$rel_set_alias(rel19, "lhs")
rel21 <- duckdb$rel_set_alias(rel18, "rhs")
rel22 <- duckdb$rel_join(
  rel20,
  rel21,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_orderkey", rel20), duckdb$expr_reference("l_orderkey", rel21))
    )
  ),
  "semi"
)
df3 <- supplier
rel23 <- duckdb$rel_from_df(con, df3, experimental = experimental)
rel24 <- duckdb$rel_set_alias(rel23, "lhs")
rel25 <- duckdb$rel_set_alias(rel22, "rhs")
rel26 <- duckdb$rel_join(
  rel24,
  rel25,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("s_suppkey", rel24), duckdb$expr_reference("l_suppkey", rel25))
    )
  ),
  "inner"
)
rel27 <- duckdb$rel_project(
  rel26,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("s_suppkey", rel24), duckdb$expr_reference("l_suppkey", rel25))
      )
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
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
    },
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_partkey")
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linenumber")
      duckdb$expr_set_alias(tmp_expr, "l_linenumber")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb$expr_reference("l_tax")
      duckdb$expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
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
      tmp_expr <- duckdb$expr_reference("l_shipinstruct")
      duckdb$expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_shipmode")
      duckdb$expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_comment")
      duckdb$expr_set_alias(tmp_expr, "l_comment")
      tmp_expr
    }
  )
)
rel28 <- duckdb$rel_filter(
  rel27,
  list(
    duckdb$expr_function(
      ">",
      list(duckdb$expr_reference("l_receiptdate"), duckdb$expr_reference("l_commitdate"))
    )
  )
)
rel29 <- duckdb$rel_set_alias(rel28, "lhs")
df4 <- nation
rel30 <- duckdb$rel_from_df(con, df4, experimental = experimental)
rel31 <- duckdb$rel_set_alias(rel30, "rhs")
rel32 <- duckdb$rel_join(
  rel29,
  rel31,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("s_nationkey", rel29), duckdb$expr_reference("n_nationkey", rel31))
    )
  ),
  "inner"
)
rel33 <- duckdb$rel_project(
  rel32,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
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
        list(duckdb$expr_reference("s_nationkey", rel29), duckdb$expr_reference("n_nationkey", rel31))
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
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_partkey")
      duckdb$expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linenumber")
      duckdb$expr_set_alias(tmp_expr, "l_linenumber")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
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
      tmp_expr <- duckdb$expr_reference("l_tax")
      duckdb$expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_returnflag")
      duckdb$expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_linestatus")
      duckdb$expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
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
      tmp_expr <- duckdb$expr_reference("l_shipinstruct")
      duckdb$expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_shipmode")
      duckdb$expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_comment")
      duckdb$expr_set_alias(tmp_expr, "l_comment")
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
rel34 <- duckdb$rel_filter(
  rel33,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference("n_name"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("SAUDI ARABIA", experimental = experimental)
        } else {
          duckdb$expr_constant("SAUDI ARABIA")
        }
      )
    )
  )
)
rel35 <- duckdb$rel_aggregate(
  rel34,
  groups = list(duckdb$expr_reference("s_name")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("n", list())
      duckdb$expr_set_alias(tmp_expr, "numwait")
      tmp_expr
    }
  )
)
rel36 <- duckdb$rel_order(rel35, list(duckdb$expr_reference("numwait"), duckdb$expr_reference("s_name")))
rel37 <- duckdb$rel_limit(rel36, 100)
rel37
duckdb$rel_to_altrep(rel37)
