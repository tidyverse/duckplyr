qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(a, b) AS a < b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(
  DBI::dbExecute(
    con,
    "CREATE MACRO \"___eq_na_matches_na\"(a, b) AS ((a IS NULL AND b IS NULL) OR (a = b))"
  )
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">\"(a, b) AS a > b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"desc\"(x) AS (-x)"))
df1 <- orders
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    }
  )
)
rel3 <- duckdb:::rel_filter(
  rel2,
  list(
    duckdb:::expr_function(
      "<",
      list(
        duckdb:::expr_reference("o_orderdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1995-03-15", experimental = experimental)
            } else {
              duckdb:::expr_constant("1995-03-15")
            }
          )
        )
      )
    )
  )
)
df2 <- customer
rel4 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel5 <- duckdb:::rel_project(
  rel4,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    }
  )
)
rel6 <- duckdb:::rel_filter(
  rel5,
  list(
    duckdb:::expr_function(
      "==",
      list(
        duckdb:::expr_reference("c_mktsegment"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant("BUILDING", experimental = experimental)
        } else {
          duckdb:::expr_constant("BUILDING")
        }
      )
    )
  )
)
rel7 <- duckdb:::rel_set_alias(rel3, "lhs")
rel8 <- duckdb:::rel_set_alias(rel6, "rhs")
rel9 <- duckdb:::rel_join(
  rel7,
  rel8,
  list(
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("o_custkey", rel7), duckdb:::expr_reference("c_custkey", rel8))
    )
  ),
  "inner"
)
rel10 <- duckdb:::rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("o_custkey", rel7), duckdb:::expr_reference("c_custkey", rel8))
      )
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    }
  )
)
rel11 <- duckdb:::rel_project(
  rel10,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    }
  )
)
df3 <- lineitem
rel12 <- duckdb:::rel_from_df(con, df3, experimental = experimental)
rel13 <- duckdb:::rel_project(
  rel12,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
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
    }
  )
)
rel14 <- duckdb:::rel_filter(
  rel13,
  list(
    duckdb:::expr_function(
      ">",
      list(
        duckdb:::expr_reference("l_shipdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1995-03-15", experimental = experimental)
            } else {
              duckdb:::expr_constant("1995-03-15")
            }
          )
        )
      )
    )
  )
)
rel15 <- duckdb:::rel_project(
  rel14,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
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
    }
  )
)
rel16 <- duckdb:::rel_set_alias(rel15, "lhs")
rel17 <- duckdb:::rel_set_alias(rel11, "rhs")
rel18 <- duckdb:::rel_join(
  rel16,
  rel17,
  list(
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("l_orderkey", rel16), duckdb:::expr_reference("o_orderkey", rel17))
    )
  ),
  "inner"
)
rel19 <- duckdb:::rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_orderkey", rel16), duckdb:::expr_reference("o_orderkey", rel17))
      )
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    }
  )
)
rel20 <- duckdb:::rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
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
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(
          duckdb:::expr_reference("l_extendedprice"),
          duckdb:::expr_function(
            "-",
            list(
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant(1, experimental = experimental)
              } else {
                duckdb:::expr_constant(1)
              },
              duckdb:::expr_reference("l_discount")
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel21 <- duckdb:::rel_aggregate(
  rel20,
  groups = list(duckdb:::expr_reference("l_orderkey"), duckdb:::expr_reference("o_orderdate"), duckdb:::expr_reference("o_shippriority")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
    duckdb:::expr_set_alias(tmp_expr, "revenue")
    tmp_expr
  })
)
rel22 <- duckdb:::rel_project(
  rel21,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("revenue")
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    }
  )
)
rel23 <- duckdb:::rel_order(
  rel22,
  list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("revenue"))), duckdb:::expr_reference("o_orderdate"))
)
rel24 <- duckdb:::rel_limit(rel23, 10)
rel24
duckdb:::rel_to_altrep(rel24)
