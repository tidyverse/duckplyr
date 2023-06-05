qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"n\"() AS (COUNT(*))"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">\"(a, b) AS a > b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"any\"(x) AS (bool_or(x))"))
invisible(
  DBI::dbExecute(
    con,
    "CREATE MACRO \"ifelse\"(test, yes, no) AS (CASE WHEN test THEN yes ELSE no END)"
  )
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"&\"(x, y) AS (x AND y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"desc\"(x) AS (-x)"))
df1 <- lineitem
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_aggregate(
  rel1,
  groups = list(duckdb:::expr_reference("l_orderkey"), duckdb:::expr_reference("l_suppkey")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function("n", list())
    duckdb:::expr_set_alias(tmp_expr, "n")
    tmp_expr
  })
)
rel3 <- duckdb:::rel_aggregate(
  rel2,
  groups = list(duckdb:::expr_reference("l_orderkey")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function("n", list())
    duckdb:::expr_set_alias(tmp_expr, "n_supplier")
    tmp_expr
  })
)
rel4 <- duckdb:::rel_filter(
  rel3,
  list(
    duckdb:::expr_function(
      ">",
      list(
        duckdb:::expr_reference("n_supplier"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant(1, experimental = experimental)
        } else {
          duckdb:::expr_constant(1)
        }
      )
    )
  )
)
rel5 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel6 <- duckdb:::rel_set_alias(rel5, "lhs")
rel7 <- duckdb:::rel_set_alias(rel4, "rhs")
rel8 <- duckdb:::rel_join(
  rel6,
  rel7,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel6), duckdb:::expr_reference("l_orderkey", rel7))
    )
  ),
  "semi"
)
rel9 <- duckdb:::rel_set_alias(rel8, "lhs")
df2 <- orders
rel10 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel11 <- duckdb:::rel_set_alias(rel10, "rhs")
rel12 <- duckdb:::rel_join(
  rel9,
  rel11,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel9), duckdb:::expr_reference("o_orderkey", rel11))
    )
  ),
  "inner"
)
rel13 <- duckdb:::rel_project(
  rel12,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_orderkey", rel9), duckdb:::expr_reference("o_orderkey", rel11))
      )
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linenumber")
      duckdb:::expr_set_alias(tmp_expr, "l_linenumber")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_tax")
      duckdb:::expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_returnflag")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linestatus")
      duckdb:::expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_commitdate")
      duckdb:::expr_set_alias(tmp_expr, "l_commitdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_receiptdate")
      duckdb:::expr_set_alias(tmp_expr, "l_receiptdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipinstruct")
      duckdb:::expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipmode")
      duckdb:::expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_comment")
      duckdb:::expr_set_alias(tmp_expr, "l_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderstatus")
      duckdb:::expr_set_alias(tmp_expr, "o_orderstatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_totalprice")
      duckdb:::expr_set_alias(tmp_expr, "o_totalprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderpriority")
      duckdb:::expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_clerk")
      duckdb:::expr_set_alias(tmp_expr, "o_clerk")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_comment")
      duckdb:::expr_set_alias(tmp_expr, "o_comment")
      tmp_expr
    }
  )
)
rel14 <- duckdb:::rel_filter(
  rel13,
  list(
    duckdb:::expr_function(
      "==",
      list(
        duckdb:::expr_reference("o_orderstatus"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant("F", experimental = experimental)
        } else {
          duckdb:::expr_constant("F")
        }
      )
    )
  )
)
rel15 <- duckdb:::rel_aggregate(
  rel14,
  groups = list(duckdb:::expr_reference("l_orderkey"), duckdb:::expr_reference("l_suppkey")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function(
      "any",
      list(
        duckdb:::expr_function(
          ">",
          list(duckdb:::expr_reference("l_receiptdate"), duckdb:::expr_reference("l_commitdate"))
        )
      )
    )
    duckdb:::expr_set_alias(tmp_expr, "failed_delivery_commit")
    tmp_expr
  })
)
rel16 <- duckdb:::rel_aggregate(
  rel15,
  groups = list(duckdb:::expr_reference("l_orderkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "n_supplier")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "ifelse",
            list(
              duckdb:::expr_reference("failed_delivery_commit"),
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant(1, experimental = experimental)
              } else {
                duckdb:::expr_constant(1)
              },
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant(0, experimental = experimental)
              } else {
                duckdb:::expr_constant(0)
              }
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "num_failed")
      tmp_expr
    }
  )
)
rel17 <- duckdb:::rel_filter(
  rel16,
  list(
    duckdb:::expr_function(
      "&",
      list(
        duckdb:::expr_function(
          ">",
          list(
            duckdb:::expr_reference("n_supplier"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant(1, experimental = experimental)
            } else {
              duckdb:::expr_constant(1)
            }
          )
        ),
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("num_failed"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant(1, experimental = experimental)
            } else {
              duckdb:::expr_constant(1)
            }
          )
        )
      )
    )
  )
)
rel18 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel19 <- duckdb:::rel_set_alias(rel18, "lhs")
rel20 <- duckdb:::rel_set_alias(rel17, "rhs")
rel21 <- duckdb:::rel_join(
  rel19,
  rel20,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel19), duckdb:::expr_reference("l_orderkey", rel20))
    )
  ),
  "semi"
)
df3 <- supplier
rel22 <- duckdb:::rel_from_df(con, df3, experimental = experimental)
rel23 <- duckdb:::rel_set_alias(rel22, "lhs")
rel24 <- duckdb:::rel_set_alias(rel21, "rhs")
rel25 <- duckdb:::rel_join(
  rel23,
  rel24,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_suppkey", rel23), duckdb:::expr_reference("l_suppkey", rel24))
    )
  ),
  "inner"
)
rel26 <- duckdb:::rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("s_suppkey", rel23), duckdb:::expr_reference("l_suppkey", rel24))
      )
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
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
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linenumber")
      duckdb:::expr_set_alias(tmp_expr, "l_linenumber")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_tax")
      duckdb:::expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_returnflag")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linestatus")
      duckdb:::expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_commitdate")
      duckdb:::expr_set_alias(tmp_expr, "l_commitdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_receiptdate")
      duckdb:::expr_set_alias(tmp_expr, "l_receiptdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipinstruct")
      duckdb:::expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipmode")
      duckdb:::expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_comment")
      duckdb:::expr_set_alias(tmp_expr, "l_comment")
      tmp_expr
    }
  )
)
rel27 <- duckdb:::rel_filter(
  rel26,
  list(
    duckdb:::expr_function(
      ">",
      list(duckdb:::expr_reference("l_receiptdate"), duckdb:::expr_reference("l_commitdate"))
    )
  )
)
rel28 <- duckdb:::rel_set_alias(rel27, "lhs")
df4 <- nation
rel29 <- duckdb:::rel_from_df(con, df4, experimental = experimental)
rel30 <- duckdb:::rel_set_alias(rel29, "rhs")
rel31 <- duckdb:::rel_join(
  rel28,
  rel30,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel28), duckdb:::expr_reference("n_nationkey", rel30))
    )
  ),
  "inner"
)
rel32 <- duckdb:::rel_project(
  rel31,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
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
        list(duckdb:::expr_reference("s_nationkey", rel28), duckdb:::expr_reference("n_nationkey", rel30))
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
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linenumber")
      duckdb:::expr_set_alias(tmp_expr, "l_linenumber")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_tax")
      duckdb:::expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_returnflag")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linestatus")
      duckdb:::expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_commitdate")
      duckdb:::expr_set_alias(tmp_expr, "l_commitdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_receiptdate")
      duckdb:::expr_set_alias(tmp_expr, "l_receiptdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipinstruct")
      duckdb:::expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipmode")
      duckdb:::expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_comment")
      duckdb:::expr_set_alias(tmp_expr, "l_comment")
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
rel33 <- duckdb:::rel_filter(
  rel32,
  list(
    duckdb:::expr_function(
      "==",
      list(
        duckdb:::expr_reference("n_name"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant("SAUDI ARABIA", experimental = experimental)
        } else {
          duckdb:::expr_constant("SAUDI ARABIA")
        }
      )
    )
  )
)
rel34 <- duckdb:::rel_aggregate(
  rel33,
  groups = list(duckdb:::expr_reference("s_name")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function("n", list())
    duckdb:::expr_set_alias(tmp_expr, "numwait")
    tmp_expr
  })
)
rel35 <- duckdb:::rel_order(
  rel34,
  list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("numwait"))), duckdb:::expr_reference("s_name"))
)
rel36 <- duckdb:::rel_limit(rel35, 100)
rel36
duckdb:::rel_to_altrep(rel36)
