qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"|\"(x, y) AS (x OR y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(a, b) AS a <= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"&\"(x, y) AS (x AND y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.integer\"(x) AS CAST(x AS int32)"))
df1 <- supplier
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    }
  )
)
df2 <- nation
rel3 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel4 <- duckdb:::rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
rel5 <- duckdb:::rel_filter(
  rel4,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("n1_name"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("FRANCE", experimental = experimental)
            } else {
              duckdb:::expr_constant("FRANCE")
            }
          )
        ),
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("n1_name"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("GERMANY", experimental = experimental)
            } else {
              duckdb:::expr_constant("GERMANY")
            }
          )
        )
      )
    )
  )
)
rel6 <- duckdb:::rel_set_alias(rel2, "lhs")
rel7 <- duckdb:::rel_set_alias(rel5, "rhs")
rel8 <- duckdb:::rel_join(
  rel6,
  rel7,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel6), duckdb:::expr_reference("n1_nationkey", rel7))
    )
  ),
  "inner"
)
rel9 <- duckdb:::rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("s_nationkey", rel6), duckdb:::expr_reference("n1_nationkey", rel7))
      )
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
rel10 <- duckdb:::rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
df3 <- customer
rel11 <- duckdb:::rel_from_df(con, df3, experimental = experimental)
rel12 <- duckdb:::rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    }
  )
)
rel13 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel14 <- duckdb:::rel_project(
  rel13,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel15 <- duckdb:::rel_filter(
  rel14,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("n2_name"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("FRANCE", experimental = experimental)
            } else {
              duckdb:::expr_constant("FRANCE")
            }
          )
        ),
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("n2_name"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("GERMANY", experimental = experimental)
            } else {
              duckdb:::expr_constant("GERMANY")
            }
          )
        )
      )
    )
  )
)
rel16 <- duckdb:::rel_set_alias(rel12, "lhs")
rel17 <- duckdb:::rel_set_alias(rel15, "rhs")
rel18 <- duckdb:::rel_join(
  rel16,
  rel17,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_nationkey", rel16), duckdb:::expr_reference("n2_nationkey", rel17))
    )
  ),
  "inner"
)
rel19 <- duckdb:::rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("c_nationkey", rel16), duckdb:::expr_reference("n2_nationkey", rel17))
      )
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel20 <- duckdb:::rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
df4 <- orders
rel21 <- duckdb:::rel_from_df(con, df4, experimental = experimental)
rel22 <- duckdb:::rel_project(
  rel21,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    }
  )
)
rel23 <- duckdb:::rel_set_alias(rel22, "lhs")
rel24 <- duckdb:::rel_set_alias(rel20, "rhs")
rel25 <- duckdb:::rel_join(
  rel23,
  rel24,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_custkey", rel23), duckdb:::expr_reference("c_custkey", rel24))
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
        list(duckdb:::expr_reference("o_custkey", rel23), duckdb:::expr_reference("c_custkey", rel24))
      )
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel27 <- duckdb:::rel_project(
  rel26,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
df5 <- lineitem
rel28 <- duckdb:::rel_from_df(con, df5, experimental = experimental)
rel29 <- duckdb:::rel_project(
  rel28,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
rel30 <- duckdb:::rel_filter(
  rel29,
  list(
    duckdb:::expr_function(
      ">=",
      list(
        duckdb:::expr_reference("l_shipdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1995-01-01", experimental = experimental)
            } else {
              duckdb:::expr_constant("1995-01-01")
            }
          )
        )
      )
    ),
    duckdb:::expr_function(
      "<=",
      list(
        duckdb:::expr_reference("l_shipdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1996-12-31", experimental = experimental)
            } else {
              duckdb:::expr_constant("1996-12-31")
            }
          )
        )
      )
    )
  )
)
rel31 <- duckdb:::rel_set_alias(rel30, "lhs")
rel32 <- duckdb:::rel_set_alias(rel27, "rhs")
rel33 <- duckdb:::rel_join(
  rel31,
  rel32,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel31), duckdb:::expr_reference("o_orderkey", rel32))
    )
  ),
  "inner"
)
rel34 <- duckdb:::rel_project(
  rel33,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_orderkey", rel31), duckdb:::expr_reference("o_orderkey", rel32))
      )
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel35 <- duckdb:::rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel36 <- duckdb:::rel_set_alias(rel35, "lhs")
rel37 <- duckdb:::rel_set_alias(rel10, "rhs")
rel38 <- duckdb:::rel_join(
  rel36,
  rel37,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel36), duckdb:::expr_reference("s_suppkey", rel37))
    )
  ),
  "inner"
)
rel39 <- duckdb:::rel_project(
  rel38,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_suppkey", rel36), duckdb:::expr_reference("s_suppkey", rel37))
      )
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
rel40 <- duckdb:::rel_filter(
  rel39,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "&",
          list(
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("n1_name"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("FRANCE", experimental = experimental)
                } else {
                  duckdb:::expr_constant("FRANCE")
                }
              )
            ),
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("n2_name"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("GERMANY", experimental = experimental)
                } else {
                  duckdb:::expr_constant("GERMANY")
                }
              )
            )
          )
        ),
        duckdb:::expr_function(
          "&",
          list(
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("n1_name"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("GERMANY", experimental = experimental)
                } else {
                  duckdb:::expr_constant("GERMANY")
                }
              )
            ),
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("n2_name"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("FRANCE", experimental = experimental)
                } else {
                  duckdb:::expr_constant("FRANCE")
                }
              )
            )
          )
        )
      )
    )
  )
)
rel41 <- duckdb:::rel_project(
  rel40,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    }
  )
)
rel42 <- duckdb:::rel_project(
  rel41,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    }
  )
)
rel43 <- duckdb:::rel_project(
  rel42,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("cust_nation")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "as.integer",
        list(
          duckdb:::expr_function(
            "strftime",
            list(
              duckdb:::expr_reference("l_shipdate"),
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant("%Y", experimental = experimental)
              } else {
                duckdb:::expr_constant("%Y")
              }
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    }
  )
)
rel44 <- duckdb:::rel_project(
  rel43,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("cust_nation")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_year")
      duckdb:::expr_set_alias(tmp_expr, "l_year")
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
rel45 <- duckdb:::rel_project(
  rel44,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("cust_nation")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_year")
      duckdb:::expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("volume")
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel46 <- duckdb:::rel_aggregate(
  rel45,
  groups = list(duckdb:::expr_reference("supp_nation"), duckdb:::expr_reference("cust_nation"), duckdb:::expr_reference("l_year")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
    duckdb:::expr_set_alias(tmp_expr, "revenue")
    tmp_expr
  })
)
rel47 <- duckdb:::rel_order(
  rel46,
  list(duckdb:::expr_reference("supp_nation"), duckdb:::expr_reference("cust_nation"), duckdb:::expr_reference("l_year"))
)
rel47
duckdb:::rel_to_altrep(rel47)
