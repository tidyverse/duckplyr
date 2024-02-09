qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
con <- DBI::dbConnect(duckdb::duckdb(config = list(allow_unsigned_extensions = "true")))
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(x, y) AS x >= y"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(x, y) AS x < y"))
invisible(
  DBI::dbExecute(con, "INSTALL 'rfuns' FROM 'http://duckdb-rfuns.s3.us-east-1.amazonaws.com'")
)
invisible(DBI::dbExecute(con, "LOAD 'rfuns'"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(x, y) AS \"r_base::==\"(x, y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(x, y) AS COALESCE(x, y)"))
df1 <- lineitem
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb$rel_project(
  rel1,
  list(
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel3 <- duckdb$rel_filter(
  rel2,
  list(
    duckdb$expr_function(
      ">=",
      list(
        duckdb$expr_reference("l_shipdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1996-01-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1996-01-01"))
        }
      )
    ),
    duckdb$expr_function(
      "<",
      list(
        duckdb$expr_reference("l_shipdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1996-04-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1996-04-01"))
        }
      )
    )
  )
)
rel4 <- duckdb$rel_order(rel3, list(duckdb$expr_reference("___row_number")))
rel5 <- duckdb$rel_project(
  rel4,
  list(
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
    }
  )
)
rel6 <- duckdb$rel_project(
  rel5,
  list(
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel7 <- duckdb$rel_aggregate(
  rel6,
  groups = list(duckdb$expr_reference("l_suppkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("___row_number")))
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "*",
            list(
              duckdb$expr_reference("l_extendedprice"),
              duckdb$expr_function(
                "-",
                list(
                  if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                    duckdb$expr_constant(1, experimental = experimental)
                  } else {
                    duckdb$expr_constant(1)
                  },
                  duckdb$expr_reference("l_discount")
                )
              )
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    }
  )
)
rel8 <- duckdb$rel_order(rel7, list(duckdb$expr_reference("___row_number")))
rel9 <- duckdb$rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    }
  )
)
rel10 <- duckdb$rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
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
rel11 <- duckdb$rel_project(
  rel10,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel12 <- duckdb$rel_aggregate(
  rel11,
  groups = list(duckdb$expr_reference("global_agr_key")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("___row_number")))
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("max", list(duckdb$expr_reference("total_revenue")))
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue")
      tmp_expr
    }
  )
)
rel13 <- duckdb$rel_order(rel12, list(duckdb$expr_reference("___row_number")))
rel14 <- duckdb$rel_project(
  rel13,
  list(
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("max_total_revenue")
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue")
      tmp_expr
    }
  )
)
rel15 <- duckdb$rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
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
rel16 <- duckdb$rel_set_alias(rel15, "lhs")
rel17 <- duckdb$rel_set_alias(rel14, "rhs")
rel18 <- duckdb$rel_project(
  rel16,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key_x")
      tmp_expr
    }
  )
)
rel19 <- duckdb$rel_project(
  rel17,
  list(
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("max_total_revenue")
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue_y")
      tmp_expr
    }
  )
)
rel20 <- duckdb$rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey_x")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue_x")
      duckdb$expr_set_alias(tmp_expr, "total_revenue_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key_x")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel21 <- duckdb$rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key_y")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("max_total_revenue_y")
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel22 <- duckdb$rel_join(
  rel20,
  rel21,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("global_agr_key_x", rel20), duckdb$expr_reference("global_agr_key_y", rel21))
    )
  ),
  "inner"
)
rel23 <- duckdb$rel_order(
  rel22,
  list(duckdb$expr_reference("___row_number_x", rel20), duckdb$expr_reference("___row_number_y", rel21))
)
rel24 <- duckdb$rel_project(
  rel23,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey_x")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue_x")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
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
      tmp_expr <- duckdb$expr_reference("max_total_revenue_y")
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue")
      tmp_expr
    }
  )
)
rel25 <- duckdb$rel_project(
  rel24,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("max_total_revenue")
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel26 <- duckdb$rel_filter(
  rel25,
  list(
    duckdb$expr_function(
      "<",
      list(
        duckdb$expr_function(
          "abs",
          list(
            duckdb$expr_function(
              "-",
              list(duckdb$expr_reference("total_revenue"), duckdb$expr_reference("max_total_revenue"))
            )
          )
        ),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(1e-09, experimental = experimental)
        } else {
          duckdb$expr_constant(1e-09)
        }
      )
    )
  )
)
rel27 <- duckdb$rel_order(rel26, list(duckdb$expr_reference("___row_number")))
rel28 <- duckdb$rel_project(
  rel27,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("max_total_revenue")
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue")
      tmp_expr
    }
  )
)
rel29 <- duckdb$rel_set_alias(rel28, "lhs")
df2 <- supplier
rel30 <- duckdb$rel_from_df(con, df2, experimental = experimental)
rel31 <- duckdb$rel_set_alias(rel30, "rhs")
rel32 <- duckdb$rel_project(
  rel29,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("max_total_revenue")
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel33 <- duckdb$rel_project(
  rel31,
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel34 <- duckdb$rel_join(
  rel32,
  rel33,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_suppkey", rel32), duckdb$expr_reference("s_suppkey", rel33))
    )
  ),
  "inner"
)
rel35 <- duckdb$rel_order(
  rel34,
  list(duckdb$expr_reference("___row_number_x", rel32), duckdb$expr_reference("___row_number_y", rel33))
)
rel36 <- duckdb$rel_project(
  rel35,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_suppkey", rel32), duckdb$expr_reference("s_suppkey", rel33))
      )
      duckdb$expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("global_agr_key")
      duckdb$expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("max_total_revenue")
      duckdb$expr_set_alias(tmp_expr, "max_total_revenue")
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
rel37 <- duckdb$rel_project(
  rel36,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_suppkey")
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
      tmp_expr <- duckdb$expr_reference("s_phone")
      duckdb$expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("total_revenue")
      duckdb$expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    }
  )
)
rel37
duckdb$rel_to_altrep(rel37)
