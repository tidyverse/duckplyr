load("tools/tpch/001.rda")
con <- DBI::dbConnect(duckdb::duckdb())
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(a, b) AS a < b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(a, b) AS a <= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">\"(a, b) AS a > b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"!=\"(a, b) AS a <> b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"is.na\"(a) AS (a IS NULL)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n\"() AS (COUNT(*))"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"sum\"(x) AS (CASE WHEN SUM(x) IS NULL THEN 0 ELSE SUM(x) END)")
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"log10\"(x) AS log(x)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"log\"(x) AS ln(x)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"grepl\"(pattern, x) AS regexp_matches(x, pattern)")
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.integer\"(x) AS CAST(x AS int32)"))
invisible(
  DBI::dbExecute(
    con,
    "CREATE MACRO \"ifelse\"(test, yes, no) AS (CASE WHEN test THEN yes ELSE no END)"
  )
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"|\"(x, y) AS (x OR y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"&\"(x, y) AS (x AND y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"!\"(x) AS (NOT x)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"any\"(x) AS (bool_or(x))"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"desc\"(x) AS (-x)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n_distinct\"(x) AS (COUNT(DISTINCT x))"))
invisible(
  DBI::dbExecute(
    con,
    "CREATE MACRO \"___eq_na_matches_na\"(a, b) AS ((a IS NULL AND b IS NULL) OR (a = b))"
  )
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
df1 <- lineitem
rel1 <- duckdb:::rel_from_df(con, df1)
rel2 <- duckdb:::rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
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
    }
  )
)
rel3 <- duckdb:::rel_filter(
  rel2,
  list(
    duckdb:::expr_function(
      "<=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1998-09-02"))))
    )
  )
)
rel4 <- duckdb:::rel_project(
  rel3,
  list(
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
    }
  )
)
rel5 <- duckdb:::rel_aggregate(
  rel4,
  list(duckdb:::expr_reference("l_returnflag"), duckdb:::expr_reference("l_linestatus")),
  list(
    sum_qty = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_quantity")))
      duckdb:::expr_set_alias(tmp_expr, "sum_qty")
      tmp_expr
    },
    sum_base_price = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_extendedprice")))
      duckdb:::expr_set_alias(tmp_expr, "sum_base_price")
      tmp_expr
    },
    sum_disc_price = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_reference("l_extendedprice"),
              duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "sum_disc_price")
      tmp_expr
    },
    sum_charge = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_function(
                "*",
                list(
                  duckdb:::expr_reference("l_extendedprice"),
                  duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
                )
              ),
              duckdb:::expr_function("+", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_tax")))
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "sum_charge")
      tmp_expr
    },
    avg_qty = {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_quantity")))
      duckdb:::expr_set_alias(tmp_expr, "avg_qty")
      tmp_expr
    },
    avg_price = {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_extendedprice")))
      duckdb:::expr_set_alias(tmp_expr, "avg_price")
      tmp_expr
    },
    avg_disc = {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_discount")))
      duckdb:::expr_set_alias(tmp_expr, "avg_disc")
      tmp_expr
    },
    count_order = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "count_order")
      tmp_expr
    }
  )
)
rel6 <- duckdb:::rel_order(
  rel5,
  list(duckdb:::expr_reference("l_returnflag"), duckdb:::expr_reference("l_linestatus"))
)
df2 <- partsupp
rel7 <- duckdb:::rel_from_df(con, df2)
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
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    }
  )
)
df3 <- part
rel9 <- duckdb:::rel_from_df(con, df3)
rel10 <- duckdb:::rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size")
      duckdb:::expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    }
  )
)
rel11 <- duckdb:::rel_filter(
  rel10,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("p_size"), duckdb:::expr_constant(15))),
    duckdb:::expr_function("grepl", list(duckdb:::expr_constant("BRASS$"), duckdb:::expr_reference("p_type")))
  )
)
rel12 <- duckdb:::rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    }
  )
)
rel13 <- duckdb:::rel_set_alias(rel12, "lhs")
rel14 <- duckdb:::rel_set_alias(rel8, "rhs")
rel15 <- duckdb:::rel_join(
  rel13,
  rel14,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("p_partkey", rel13), duckdb:::expr_reference("ps_partkey", rel14))
    )
  ),
  "inner"
)
rel16 <- duckdb:::rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    }
  )
)
df4 <- supplier
rel17 <- duckdb:::rel_from_df(con, df4)
rel18 <- duckdb:::rel_project(
  rel17,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel19 <- duckdb:::rel_set_alias(rel16, "lhs")
rel20 <- duckdb:::rel_set_alias(rel18, "rhs")
rel21 <- duckdb:::rel_join(
  rel19,
  rel20,
  list(
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("ps_suppkey", rel19), duckdb:::expr_reference("s_suppkey", rel20))
    )
  ),
  "inner"
)
rel22 <- duckdb:::rel_project(
  rel21,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel23 <- duckdb:::rel_project(
  rel22,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
df5 <- region
rel24 <- duckdb:::rel_from_df(con, df5)
rel25 <- duckdb:::rel_filter(
  rel24,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("r_name"), duckdb:::expr_constant("EUROPE")))
  )
)
df6 <- nation
rel26 <- duckdb:::rel_from_df(con, df6)
rel27 <- duckdb:::rel_set_alias(rel26, "lhs")
rel28 <- duckdb:::rel_set_alias(rel25, "rhs")
rel29 <- duckdb:::rel_join(
  rel27,
  rel28,
  list(
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("n_regionkey", rel27), duckdb:::expr_reference("r_regionkey", rel28))
    )
  ),
  "inner"
)
rel30 <- duckdb:::rel_project(
  rel29,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n_nationkey")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("r_name")
      duckdb:::expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("r_comment")
      duckdb:::expr_set_alias(tmp_expr, "r_comment")
      tmp_expr
    }
  )
)
rel31 <- duckdb:::rel_project(
  rel30,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel32 <- duckdb:::rel_set_alias(rel23, "lhs")
rel33 <- duckdb:::rel_set_alias(rel31, "rhs")
rel34 <- duckdb:::rel_join(
  rel32,
  rel33,
  list(
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("s_nationkey", rel32), duckdb:::expr_reference("n_nationkey", rel33))
    )
  ),
  "inner"
)
rel35 <- duckdb:::rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
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
    }
  )
)
rel36 <- duckdb:::rel_project(
  rel35,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel37 <- duckdb:::rel_aggregate(
  rel36,
  list(duckdb:::expr_reference("p_partkey")),
  list(
    min_ps_supplycost = {
      tmp_expr <- duckdb:::expr_function("min", list(duckdb:::expr_reference("ps_supplycost")))
      duckdb:::expr_set_alias(tmp_expr, "min_ps_supplycost")
      tmp_expr
    }
  )
)
rel38 <- duckdb:::rel_set_alias(rel36, "lhs")
rel39 <- duckdb:::rel_set_alias(rel37, "rhs")
rel40 <- duckdb:::rel_project(
  rel38,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment_x")
      tmp_expr
    }
  )
)
rel41 <- duckdb:::rel_project(
  rel39,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("min_ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "min_ps_supplycost_y")
      tmp_expr
    }
  )
)
rel42 <- duckdb:::rel_join(
  rel40,
  rel41,
  list(
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("p_partkey_x", rel40), duckdb:::expr_reference("p_partkey_y", rel41))
    ),
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("ps_supplycost_x", rel40), duckdb:::expr_reference("min_ps_supplycost_y", rel41))
    )
  ),
  "inner"
)
rel43 <- duckdb:::rel_project(
  rel42,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey_x")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost_x")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr_x")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name_x")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal_x")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name_x")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address_x")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_phone_x")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment_x")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel44 <- duckdb:::rel_project(
  rel43,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_comment")
      duckdb:::expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel45 <- duckdb:::rel_order(
  rel44,
  list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("s_acctbal"))), duckdb:::expr_reference("n_name"), duckdb:::expr_reference("s_name"), duckdb:::expr_reference("p_partkey"))
)
rel46 <- duckdb:::rel_limit(rel45, 100)
df7 <- orders
rel47 <- duckdb:::rel_from_df(con, df7)
rel48 <- duckdb:::rel_project(
  rel47,
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
rel49 <- duckdb:::rel_filter(
  rel48,
  list(
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-03-15"))))
    )
  )
)
df8 <- customer
rel50 <- duckdb:::rel_from_df(con, df8)
rel51 <- duckdb:::rel_project(
  rel50,
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
rel52 <- duckdb:::rel_filter(
  rel51,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_mktsegment"), duckdb:::expr_constant("BUILDING"))
    )
  )
)
rel53 <- duckdb:::rel_set_alias(rel49, "lhs")
rel54 <- duckdb:::rel_set_alias(rel52, "rhs")
rel55 <- duckdb:::rel_join(
  rel53,
  rel54,
  list(
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("o_custkey", rel53), duckdb:::expr_reference("c_custkey", rel54))
    )
  ),
  "inner"
)
rel56 <- duckdb:::rel_project(
  rel55,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    }
  )
)
rel57 <- duckdb:::rel_project(
  rel56,
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
rel58 <- duckdb:::rel_from_df(con, df1)
rel59 <- duckdb:::rel_project(
  rel58,
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
rel60 <- duckdb:::rel_filter(
  rel59,
  list(
    duckdb:::expr_function(
      ">",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-03-15"))))
    )
  )
)
rel61 <- duckdb:::rel_project(
  rel60,
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
rel62 <- duckdb:::rel_set_alias(rel61, "lhs")
rel63 <- duckdb:::rel_set_alias(rel57, "rhs")
rel64 <- duckdb:::rel_join(
  rel62,
  rel63,
  list(
    duckdb:::expr_function(
      "___eq_na_matches_na",
      list(duckdb:::expr_reference("l_orderkey", rel62), duckdb:::expr_reference("o_orderkey", rel63))
    )
  ),
  "inner"
)
rel65 <- duckdb:::rel_project(
  rel64,
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
    }
  )
)
rel66 <- duckdb:::rel_project(
  rel65,
  list(
    l_orderkey = {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    o_orderdate = {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    o_shippriority = {
      tmp_expr <- duckdb:::expr_reference("o_shippriority")
      duckdb:::expr_set_alias(tmp_expr, "o_shippriority")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(
          duckdb:::expr_reference("l_extendedprice"),
          duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel67 <- duckdb:::rel_aggregate(
  rel66,
  list(duckdb:::expr_reference("l_orderkey"), duckdb:::expr_reference("o_orderdate"), duckdb:::expr_reference("o_shippriority")),
  list(
    revenue = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel68 <- duckdb:::rel_project(
  rel67,
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
rel69 <- duckdb:::rel_order(
  rel68,
  list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("revenue"))), duckdb:::expr_reference("o_orderdate"))
)
rel70 <- duckdb:::rel_limit(rel69, 10)
rel71 <- duckdb:::rel_from_df(con, df1)
rel72 <- duckdb:::rel_project(
  rel71,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
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
    }
  )
)
rel73 <- duckdb:::rel_filter(
  rel72,
  list(
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_commitdate"), duckdb:::expr_reference("l_receiptdate"))
    )
  )
)
rel74 <- duckdb:::rel_project(
  rel73,
  list({
    tmp_expr <- duckdb:::expr_reference("l_orderkey")
    duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
    tmp_expr
  })
)
rel75 <- duckdb:::rel_from_df(con, df7)
rel76 <- duckdb:::rel_project(
  rel75,
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
      tmp_expr <- duckdb:::expr_reference("o_orderpriority")
      duckdb:::expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel77 <- duckdb:::rel_filter(
  rel76,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1993-07-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1993-10-01"))))
    )
  )
)
rel78 <- duckdb:::rel_project(
  rel77,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderpriority")
      duckdb:::expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel79 <- duckdb:::rel_set_alias(rel74, "lhs")
rel80 <- duckdb:::rel_set_alias(rel78, "rhs")
rel81 <- duckdb:::rel_join(
  rel79,
  rel80,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel79), duckdb:::expr_reference("o_orderkey", rel80))
    )
  ),
  "inner"
)
rel82 <- duckdb:::rel_project(
  rel81,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderpriority")
      duckdb:::expr_set_alias(tmp_expr, "o_orderpriority")
      tmp_expr
    }
  )
)
rel83 <- duckdb:::rel_distinct(rel82)
rel84 <- duckdb:::rel_project(
  rel83,
  list({
    tmp_expr <- duckdb:::expr_reference("o_orderpriority")
    duckdb:::expr_set_alias(tmp_expr, "o_orderpriority")
    tmp_expr
  })
)
rel85 <- duckdb:::rel_aggregate(
  rel84,
  list(duckdb:::expr_reference("o_orderpriority")),
  list(
    order_count = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "order_count")
      tmp_expr
    }
  )
)
rel86 <- duckdb:::rel_order(rel85, list(duckdb:::expr_reference("o_orderpriority")))
rel87 <- duckdb:::rel_from_df(con, df6)
rel88 <- duckdb:::rel_project(
  rel87,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel89 <- duckdb:::rel_from_df(con, df5)
rel90 <- duckdb:::rel_project(
  rel89,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("r_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("r_name")
      duckdb:::expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    }
  )
)
rel91 <- duckdb:::rel_filter(
  rel90,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("r_name"), duckdb:::expr_constant("ASIA")))
  )
)
rel92 <- duckdb:::rel_set_alias(rel88, "lhs")
rel93 <- duckdb:::rel_set_alias(rel91, "rhs")
rel94 <- duckdb:::rel_join(
  rel92,
  rel93,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("n_regionkey", rel92), duckdb:::expr_reference("r_regionkey", rel93))
    )
  ),
  "inner"
)
rel95 <- duckdb:::rel_project(
  rel94,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("r_name")
      duckdb:::expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    }
  )
)
rel96 <- duckdb:::rel_project(
  rel95,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel97 <- duckdb:::rel_from_df(con, df4)
rel98 <- duckdb:::rel_project(
  rel97,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
rel99 <- duckdb:::rel_set_alias(rel98, "lhs")
rel100 <- duckdb:::rel_set_alias(rel96, "rhs")
rel101 <- duckdb:::rel_join(
  rel99,
  rel100,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel99), duckdb:::expr_reference("n_nationkey", rel100))
    )
  ),
  "inner"
)
rel102 <- duckdb:::rel_project(
  rel101,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel103 <- duckdb:::rel_project(
  rel102,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel104 <- duckdb:::rel_from_df(con, df1)
rel105 <- duckdb:::rel_project(
  rel104,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
rel106 <- duckdb:::rel_set_alias(rel105, "lhs")
rel107 <- duckdb:::rel_set_alias(rel103, "rhs")
rel108 <- duckdb:::rel_join(
  rel106,
  rel107,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel106), duckdb:::expr_reference("s_suppkey", rel107))
    )
  ),
  "inner"
)
rel109 <- duckdb:::rel_project(
  rel108,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel110 <- duckdb:::rel_from_df(con, df7)
rel111 <- duckdb:::rel_project(
  rel110,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    }
  )
)
rel112 <- duckdb:::rel_filter(
  rel111,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1994-01-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-01-01"))))
    )
  )
)
rel113 <- duckdb:::rel_project(
  rel112,
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
    }
  )
)
rel114 <- duckdb:::rel_from_df(con, df8)
rel115 <- duckdb:::rel_project(
  rel114,
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
rel116 <- duckdb:::rel_set_alias(rel113, "lhs")
rel117 <- duckdb:::rel_set_alias(rel115, "rhs")
rel118 <- duckdb:::rel_join(
  rel116,
  rel117,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_custkey", rel116), duckdb:::expr_reference("c_custkey", rel117))
    )
  ),
  "inner"
)
rel119 <- duckdb:::rel_project(
  rel118,
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
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    }
  )
)
rel120 <- duckdb:::rel_project(
  rel119,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    }
  )
)
rel121 <- duckdb:::rel_set_alias(rel109, "lhs")
rel122 <- duckdb:::rel_set_alias(rel120, "rhs")
rel123 <- duckdb:::rel_join(
  rel121,
  rel122,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel121), duckdb:::expr_reference("o_orderkey", rel122))
    ),
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel121), duckdb:::expr_reference("c_nationkey", rel122))
    )
  ),
  "inner"
)
rel124 <- duckdb:::rel_project(
  rel123,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel125 <- duckdb:::rel_project(
  rel124,
  list(
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
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel126 <- duckdb:::rel_project(
  rel125,
  list(
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    n_name = {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(
          duckdb:::expr_reference("l_extendedprice"),
          duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel127 <- duckdb:::rel_aggregate(
  rel126,
  list(duckdb:::expr_reference("n_name")),
  list(
    revenue = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel128 <- duckdb:::rel_order(rel127, list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("revenue")))))
rel129 <- duckdb:::rel_from_df(con, df1)
rel130 <- duckdb:::rel_project(
  rel129,
  list(
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
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    }
  )
)
rel131 <- duckdb:::rel_filter(
  rel130,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1994-01-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-01-01"))))
    ),
    duckdb:::expr_function(">=", list(duckdb:::expr_reference("l_discount"), duckdb:::expr_constant(0.05))),
    duckdb:::expr_function("<=", list(duckdb:::expr_reference("l_discount"), duckdb:::expr_constant(0.07))),
    duckdb:::expr_function("<", list(duckdb:::expr_reference("l_quantity"), duckdb:::expr_constant(24)))
  )
)
rel132 <- duckdb:::rel_project(
  rel131,
  list(
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
rel133 <- duckdb:::rel_aggregate(
  rel132,
  list(),
  list(
    revenue = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(duckdb:::expr_reference("l_extendedprice"), duckdb:::expr_reference("l_discount"))
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel134 <- duckdb:::rel_from_df(con, df4)
rel135 <- duckdb:::rel_project(
  rel134,
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
rel136 <- duckdb:::rel_from_df(con, df6)
rel137 <- duckdb:::rel_project(
  rel136,
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
rel138 <- duckdb:::rel_filter(
  rel137,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function("==", list(duckdb:::expr_reference("n1_name"), duckdb:::expr_constant("FRANCE"))),
        duckdb:::expr_function("==", list(duckdb:::expr_reference("n1_name"), duckdb:::expr_constant("GERMANY")))
      )
    )
  )
)
rel139 <- duckdb:::rel_set_alias(rel135, "lhs")
rel140 <- duckdb:::rel_set_alias(rel138, "rhs")
rel141 <- duckdb:::rel_join(
  rel139,
  rel140,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel139), duckdb:::expr_reference("n1_nationkey", rel140))
    )
  ),
  "inner"
)
rel142 <- duckdb:::rel_project(
  rel141,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
rel143 <- duckdb:::rel_project(
  rel142,
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
rel144 <- duckdb:::rel_from_df(con, df8)
rel145 <- duckdb:::rel_project(
  rel144,
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
rel146 <- duckdb:::rel_from_df(con, df6)
rel147 <- duckdb:::rel_project(
  rel146,
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
rel148 <- duckdb:::rel_filter(
  rel147,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function("==", list(duckdb:::expr_reference("n2_name"), duckdb:::expr_constant("FRANCE"))),
        duckdb:::expr_function("==", list(duckdb:::expr_reference("n2_name"), duckdb:::expr_constant("GERMANY")))
      )
    )
  )
)
rel149 <- duckdb:::rel_set_alias(rel145, "lhs")
rel150 <- duckdb:::rel_set_alias(rel148, "rhs")
rel151 <- duckdb:::rel_join(
  rel149,
  rel150,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_nationkey", rel149), duckdb:::expr_reference("n2_nationkey", rel150))
    )
  ),
  "inner"
)
rel152 <- duckdb:::rel_project(
  rel151,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel153 <- duckdb:::rel_project(
  rel152,
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
rel154 <- duckdb:::rel_from_df(con, df7)
rel155 <- duckdb:::rel_project(
  rel154,
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
rel156 <- duckdb:::rel_set_alias(rel155, "lhs")
rel157 <- duckdb:::rel_set_alias(rel153, "rhs")
rel158 <- duckdb:::rel_join(
  rel156,
  rel157,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_custkey", rel156), duckdb:::expr_reference("c_custkey", rel157))
    )
  ),
  "inner"
)
rel159 <- duckdb:::rel_project(
  rel158,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel160 <- duckdb:::rel_project(
  rel159,
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
rel161 <- duckdb:::rel_from_df(con, df1)
rel162 <- duckdb:::rel_project(
  rel161,
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
rel163 <- duckdb:::rel_filter(
  rel162,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-01-01"))))
    ),
    duckdb:::expr_function(
      "<=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1996-12-31"))))
    )
  )
)
rel164 <- duckdb:::rel_set_alias(rel163, "lhs")
rel165 <- duckdb:::rel_set_alias(rel160, "rhs")
rel166 <- duckdb:::rel_join(
  rel164,
  rel165,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel164), duckdb:::expr_reference("o_orderkey", rel165))
    )
  ),
  "inner"
)
rel167 <- duckdb:::rel_project(
  rel166,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel168 <- duckdb:::rel_project(
  rel167,
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
rel169 <- duckdb:::rel_set_alias(rel168, "lhs")
rel170 <- duckdb:::rel_set_alias(rel143, "rhs")
rel171 <- duckdb:::rel_join(
  rel169,
  rel170,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel169), duckdb:::expr_reference("s_suppkey", rel170))
    )
  ),
  "inner"
)
rel172 <- duckdb:::rel_project(
  rel171,
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
    }
  )
)
rel173 <- duckdb:::rel_filter(
  rel172,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "&",
          list(
            duckdb:::expr_function("==", list(duckdb:::expr_reference("n1_name"), duckdb:::expr_constant("FRANCE"))),
            duckdb:::expr_function("==", list(duckdb:::expr_reference("n2_name"), duckdb:::expr_constant("GERMANY")))
          )
        ),
        duckdb:::expr_function(
          "&",
          list(
            duckdb:::expr_function("==", list(duckdb:::expr_reference("n1_name"), duckdb:::expr_constant("GERMANY"))),
            duckdb:::expr_function("==", list(duckdb:::expr_reference("n2_name"), duckdb:::expr_constant("FRANCE")))
          )
        )
      )
    )
  )
)
rel174 <- duckdb:::rel_project(
  rel173,
  list(
    l_suppkey = {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    l_shipdate = {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    n2_name = {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    n1_name = {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    }
  )
)
rel175 <- duckdb:::rel_project(
  rel174,
  list(
    l_suppkey = {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    l_shipdate = {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    n2_name = {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    n1_name = {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    supp_nation = {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    }
  )
)
rel176 <- duckdb:::rel_project(
  rel175,
  list(
    l_suppkey = {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    l_shipdate = {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    n2_name = {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    n1_name = {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    supp_nation = {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    cust_nation = {
      tmp_expr <- duckdb:::expr_reference("cust_nation")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "as.integer",
        list(
          duckdb:::expr_function("strftime", list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_constant("%Y")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    }
  )
)
rel177 <- duckdb:::rel_project(
  rel176,
  list(
    l_suppkey = {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    l_shipdate = {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    n2_name = {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    n1_name = {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    supp_nation = {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    cust_nation = {
      tmp_expr <- duckdb:::expr_reference("cust_nation")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    l_year = {
      tmp_expr <- duckdb:::expr_reference("l_year")
      duckdb:::expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(
          duckdb:::expr_reference("l_extendedprice"),
          duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel178 <- duckdb:::rel_project(
  rel177,
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
rel179 <- duckdb:::rel_aggregate(
  rel178,
  list(duckdb:::expr_reference("supp_nation"), duckdb:::expr_reference("cust_nation"), duckdb:::expr_reference("l_year")),
  list(
    revenue = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel180 <- duckdb:::rel_order(
  rel179,
  list(duckdb:::expr_reference("supp_nation"), duckdb:::expr_reference("cust_nation"), duckdb:::expr_reference("l_year"))
)
rel181 <- duckdb:::rel_from_df(con, df6)
rel182 <- duckdb:::rel_project(
  rel181,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_regionkey")
      tmp_expr
    }
  )
)
rel183 <- duckdb:::rel_from_df(con, df5)
rel184 <- duckdb:::rel_project(
  rel183,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("r_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("r_name")
      duckdb:::expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    }
  )
)
rel185 <- duckdb:::rel_filter(
  rel184,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("r_name"), duckdb:::expr_constant("AMERICA")))
  )
)
rel186 <- duckdb:::rel_project(
  rel185,
  list({
    tmp_expr <- duckdb:::expr_reference("r_regionkey")
    duckdb:::expr_set_alias(tmp_expr, "r_regionkey")
    tmp_expr
  })
)
rel187 <- duckdb:::rel_set_alias(rel182, "lhs")
rel188 <- duckdb:::rel_set_alias(rel186, "rhs")
rel189 <- duckdb:::rel_join(
  rel187,
  rel188,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("n1_regionkey", rel187), duckdb:::expr_reference("r_regionkey", rel188))
    )
  ),
  "inner"
)
rel190 <- duckdb:::rel_project(
  rel189,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n1_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_regionkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_regionkey")
      tmp_expr
    }
  )
)
rel191 <- duckdb:::rel_project(
  rel190,
  list({
    tmp_expr <- duckdb:::expr_reference("n1_nationkey")
    duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
    tmp_expr
  })
)
rel192 <- duckdb:::rel_from_df(con, df8)
rel193 <- duckdb:::rel_project(
  rel192,
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
rel194 <- duckdb:::rel_set_alias(rel193, "lhs")
rel195 <- duckdb:::rel_set_alias(rel191, "rhs")
rel196 <- duckdb:::rel_join(
  rel194,
  rel195,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_nationkey", rel194), duckdb:::expr_reference("n1_nationkey", rel195))
    )
  ),
  "inner"
)
rel197 <- duckdb:::rel_project(
  rel196,
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
rel198 <- duckdb:::rel_project(
  rel197,
  list({
    tmp_expr <- duckdb:::expr_reference("c_custkey")
    duckdb:::expr_set_alias(tmp_expr, "c_custkey")
    tmp_expr
  })
)
rel199 <- duckdb:::rel_from_df(con, df7)
rel200 <- duckdb:::rel_project(
  rel199,
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
    }
  )
)
rel201 <- duckdb:::rel_filter(
  rel200,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-01-01"))))
    ),
    duckdb:::expr_function(
      "<=",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1996-12-31"))))
    )
  )
)
rel202 <- duckdb:::rel_set_alias(rel201, "lhs")
rel203 <- duckdb:::rel_set_alias(rel198, "rhs")
rel204 <- duckdb:::rel_join(
  rel202,
  rel203,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_custkey", rel202), duckdb:::expr_reference("c_custkey", rel203))
    )
  ),
  "inner"
)
rel205 <- duckdb:::rel_project(
  rel204,
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
    }
  )
)
rel206 <- duckdb:::rel_project(
  rel205,
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
    }
  )
)
rel207 <- duckdb:::rel_from_df(con, df1)
rel208 <- duckdb:::rel_project(
  rel207,
  list(
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
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
rel209 <- duckdb:::rel_set_alias(rel208, "lhs")
rel210 <- duckdb:::rel_set_alias(rel206, "rhs")
rel211 <- duckdb:::rel_join(
  rel209,
  rel210,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel209), duckdb:::expr_reference("o_orderkey", rel210))
    )
  ),
  "inner"
)
rel212 <- duckdb:::rel_project(
  rel211,
  list(
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
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    }
  )
)
rel213 <- duckdb:::rel_project(
  rel212,
  list(
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
    }
  )
)
rel214 <- duckdb:::rel_from_df(con, df3)
rel215 <- duckdb:::rel_project(
  rel214,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    }
  )
)
rel216 <- duckdb:::rel_filter(
  rel215,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("p_type"), duckdb:::expr_constant("ECONOMY ANODIZED STEEL"))
    )
  )
)
rel217 <- duckdb:::rel_project(
  rel216,
  list({
    tmp_expr <- duckdb:::expr_reference("p_partkey")
    duckdb:::expr_set_alias(tmp_expr, "p_partkey")
    tmp_expr
  })
)
rel218 <- duckdb:::rel_set_alias(rel213, "lhs")
rel219 <- duckdb:::rel_set_alias(rel217, "rhs")
rel220 <- duckdb:::rel_join(
  rel218,
  rel219,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel218), duckdb:::expr_reference("p_partkey", rel219))
    )
  ),
  "inner"
)
rel221 <- duckdb:::rel_project(
  rel220,
  list(
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
    }
  )
)
rel222 <- duckdb:::rel_project(
  rel221,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
    }
  )
)
rel223 <- duckdb:::rel_from_df(con, df4)
rel224 <- duckdb:::rel_project(
  rel223,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
rel225 <- duckdb:::rel_set_alias(rel222, "lhs")
rel226 <- duckdb:::rel_set_alias(rel224, "rhs")
rel227 <- duckdb:::rel_join(
  rel225,
  rel226,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel225), duckdb:::expr_reference("s_suppkey", rel226))
    )
  ),
  "inner"
)
rel228 <- duckdb:::rel_project(
  rel227,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
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
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
rel229 <- duckdb:::rel_project(
  rel228,
  list(
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
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
rel230 <- duckdb:::rel_from_df(con, df6)
rel231 <- duckdb:::rel_project(
  rel230,
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
rel232 <- duckdb:::rel_set_alias(rel229, "lhs")
rel233 <- duckdb:::rel_set_alias(rel231, "rhs")
rel234 <- duckdb:::rel_join(
  rel232,
  rel233,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel232), duckdb:::expr_reference("n2_nationkey", rel233))
    )
  ),
  "inner"
)
rel235 <- duckdb:::rel_project(
  rel234,
  list(
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
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel236 <- duckdb:::rel_project(
  rel235,
  list(
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
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel237 <- duckdb:::rel_project(
  rel236,
  list(
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    o_orderdate = {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    n2_name = {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "as.integer",
        list(
          duckdb:::expr_function("strftime", list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_constant("%Y")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    }
  )
)
rel238 <- duckdb:::rel_project(
  rel237,
  list(
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    o_orderdate = {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    n2_name = {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    o_year = {
      tmp_expr <- duckdb:::expr_reference("o_year")
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(
          duckdb:::expr_reference("l_extendedprice"),
          duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel239 <- duckdb:::rel_project(
  rel238,
  list(
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    o_orderdate = {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    n2_name = {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    o_year = {
      tmp_expr <- duckdb:::expr_reference("o_year")
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    volume = {
      tmp_expr <- duckdb:::expr_reference("volume")
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "nation")
      tmp_expr
    }
  )
)
rel240 <- duckdb:::rel_project(
  rel239,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_year")
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("volume")
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("nation")
      duckdb:::expr_set_alias(tmp_expr, "nation")
      tmp_expr
    }
  )
)
rel241 <- duckdb:::rel_aggregate(
  rel240,
  list(duckdb:::expr_reference("o_year")),
  list(
    mkt_share = {
      tmp_expr <- duckdb:::expr_function(
        "/",
        list(
          duckdb:::expr_function(
            "sum",
            list(
              duckdb:::expr_function(
                "ifelse",
                list(
                  duckdb:::expr_function("==", list(duckdb:::expr_reference("nation"), duckdb:::expr_constant("BRAZIL"))),
                  duckdb:::expr_reference("volume"),
                  duckdb:::expr_constant(0)
                )
              )
            )
          ),
          duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "mkt_share")
      tmp_expr
    }
  )
)
rel242 <- duckdb:::rel_order(rel241, list(duckdb:::expr_reference("o_year")))
rel243 <- duckdb:::rel_from_df(con, df3)
rel244 <- duckdb:::rel_project(
  rel243,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_name")
      duckdb:::expr_set_alias(tmp_expr, "p_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    }
  )
)
rel245 <- duckdb:::rel_filter(
  rel244,
  list(
    duckdb:::expr_function("grepl", list(duckdb:::expr_constant("green"), duckdb:::expr_reference("p_name")))
  )
)
rel246 <- duckdb:::rel_project(
  rel245,
  list({
    tmp_expr <- duckdb:::expr_reference("p_partkey")
    duckdb:::expr_set_alias(tmp_expr, "p_partkey")
    tmp_expr
  })
)
rel247 <- duckdb:::rel_from_df(con, df2)
rel248 <- duckdb:::rel_project(
  rel247,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    }
  )
)
rel249 <- duckdb:::rel_set_alias(rel248, "lhs")
rel250 <- duckdb:::rel_set_alias(rel246, "rhs")
rel251 <- duckdb:::rel_join(
  rel249,
  rel250,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_partkey", rel249), duckdb:::expr_reference("p_partkey", rel250))
    )
  ),
  "inner"
)
rel252 <- duckdb:::rel_project(
  rel251,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    }
  )
)
rel253 <- duckdb:::rel_from_df(con, df4)
rel254 <- duckdb:::rel_project(
  rel253,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    }
  )
)
rel255 <- duckdb:::rel_from_df(con, df6)
rel256 <- duckdb:::rel_project(
  rel255,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel257 <- duckdb:::rel_set_alias(rel254, "lhs")
rel258 <- duckdb:::rel_set_alias(rel256, "rhs")
rel259 <- duckdb:::rel_join(
  rel257,
  rel258,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel257), duckdb:::expr_reference("n_nationkey", rel258))
    )
  ),
  "inner"
)
rel260 <- duckdb:::rel_project(
  rel259,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel261 <- duckdb:::rel_project(
  rel260,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel262 <- duckdb:::rel_set_alias(rel252, "lhs")
rel263 <- duckdb:::rel_set_alias(rel261, "rhs")
rel264 <- duckdb:::rel_join(
  rel262,
  rel263,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_suppkey", rel262), duckdb:::expr_reference("s_suppkey", rel263))
    )
  ),
  "inner"
)
rel265 <- duckdb:::rel_project(
  rel264,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel266 <- duckdb:::rel_from_df(con, df1)
rel267 <- duckdb:::rel_project(
  rel266,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    }
  )
)
rel268 <- duckdb:::rel_set_alias(rel267, "lhs")
rel269 <- duckdb:::rel_set_alias(rel265, "rhs")
rel270 <- duckdb:::rel_join(
  rel268,
  rel269,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel268), duckdb:::expr_reference("ps_suppkey", rel269))
    ),
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel268), duckdb:::expr_reference("ps_partkey", rel269))
    )
  ),
  "inner"
)
rel271 <- duckdb:::rel_project(
  rel270,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel272 <- duckdb:::rel_project(
  rel271,
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
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel273 <- duckdb:::rel_from_df(con, df7)
rel274 <- duckdb:::rel_project(
  rel273,
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
    }
  )
)
rel275 <- duckdb:::rel_set_alias(rel274, "lhs")
rel276 <- duckdb:::rel_set_alias(rel272, "rhs")
rel277 <- duckdb:::rel_join(
  rel275,
  rel276,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_orderkey", rel275), duckdb:::expr_reference("l_orderkey", rel276))
    )
  ),
  "inner"
)
rel278 <- duckdb:::rel_project(
  rel277,
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
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel279 <- duckdb:::rel_project(
  rel278,
  list(
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
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }
  )
)
rel280 <- duckdb:::rel_project(
  rel279,
  list(
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    l_quantity = {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    ps_supplycost = {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    n_name = {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    o_orderdate = {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "nation")
      tmp_expr
    }
  )
)
rel281 <- duckdb:::rel_project(
  rel280,
  list(
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    l_quantity = {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    ps_supplycost = {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    n_name = {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    o_orderdate = {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    nation = {
      tmp_expr <- duckdb:::expr_reference("nation")
      duckdb:::expr_set_alias(tmp_expr, "nation")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "as.integer",
        list(
          duckdb:::expr_function("strftime", list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_constant("%Y")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    }
  )
)
rel282 <- duckdb:::rel_project(
  rel281,
  list(
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    l_quantity = {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    ps_supplycost = {
      tmp_expr <- duckdb:::expr_reference("ps_supplycost")
      duckdb:::expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    n_name = {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    o_orderdate = {
      tmp_expr <- duckdb:::expr_reference("o_orderdate")
      duckdb:::expr_set_alias(tmp_expr, "o_orderdate")
      tmp_expr
    },
    nation = {
      tmp_expr <- duckdb:::expr_reference("nation")
      duckdb:::expr_set_alias(tmp_expr, "nation")
      tmp_expr
    },
    o_year = {
      tmp_expr <- duckdb:::expr_reference("o_year")
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "-",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_reference("l_extendedprice"),
              duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
            )
          ),
          duckdb:::expr_function(
            "*",
            list(duckdb:::expr_reference("ps_supplycost"), duckdb:::expr_reference("l_quantity"))
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "amount")
      tmp_expr
    }
  )
)
rel283 <- duckdb:::rel_project(
  rel282,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("nation")
      duckdb:::expr_set_alias(tmp_expr, "nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_year")
      duckdb:::expr_set_alias(tmp_expr, "o_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("amount")
      duckdb:::expr_set_alias(tmp_expr, "amount")
      tmp_expr
    }
  )
)
rel284 <- duckdb:::rel_aggregate(
  rel283,
  list(duckdb:::expr_reference("nation"), duckdb:::expr_reference("o_year")),
  list(
    sum_profit = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("amount")))
      duckdb:::expr_set_alias(tmp_expr, "sum_profit")
      tmp_expr
    }
  )
)
rel285 <- duckdb:::rel_order(
  rel284,
  list(duckdb:::expr_reference("nation"), duckdb:::expr_function("desc", list(duckdb:::expr_reference("o_year"))))
)
rel286 <- duckdb:::rel_from_df(con, df1)
rel287 <- duckdb:::rel_project(
  rel286,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_returnflag")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag")
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
rel288 <- duckdb:::rel_filter(
  rel287,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("l_returnflag"), duckdb:::expr_constant("R")))
  )
)
rel289 <- duckdb:::rel_project(
  rel288,
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
rel290 <- duckdb:::rel_from_df(con, df7)
rel291 <- duckdb:::rel_project(
  rel290,
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
    }
  )
)
rel292 <- duckdb:::rel_filter(
  rel291,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1993-10-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("o_orderdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1994-01-01"))))
    )
  )
)
rel293 <- duckdb:::rel_project(
  rel292,
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
    }
  )
)
rel294 <- duckdb:::rel_set_alias(rel289, "lhs")
rel295 <- duckdb:::rel_set_alias(rel293, "rhs")
rel296 <- duckdb:::rel_join(
  rel294,
  rel295,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel294), duckdb:::expr_reference("o_orderkey", rel295))
    )
  ),
  "inner"
)
rel297 <- duckdb:::rel_project(
  rel296,
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
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    }
  )
)
rel298 <- duckdb:::rel_project(
  rel297,
  list(
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
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    }
  )
)
rel299 <- duckdb:::rel_project(
  rel298,
  list(
    l_extendedprice = {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    l_discount = {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    o_custkey = {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(
          duckdb:::expr_reference("l_extendedprice"),
          duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel300 <- duckdb:::rel_aggregate(
  rel299,
  list(duckdb:::expr_reference("o_custkey")),
  list(
    revenue = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel301 <- duckdb:::rel_from_df(con, df8)
rel302 <- duckdb:::rel_project(
  rel301,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    }
  )
)
rel303 <- duckdb:::rel_set_alias(rel302, "lhs")
rel304 <- duckdb:::rel_set_alias(rel300, "rhs")
rel305 <- duckdb:::rel_join(
  rel303,
  rel304,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_custkey", rel303), duckdb:::expr_reference("o_custkey", rel304))
    )
  ),
  "inner"
)
rel306 <- duckdb:::rel_project(
  rel305,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("revenue")
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel307 <- duckdb:::rel_from_df(con, df6)
rel308 <- duckdb:::rel_project(
  rel307,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel309 <- duckdb:::rel_set_alias(rel306, "lhs")
rel310 <- duckdb:::rel_set_alias(rel308, "rhs")
rel311 <- duckdb:::rel_join(
  rel309,
  rel310,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_nationkey", rel309), duckdb:::expr_reference("n_nationkey", rel310))
    )
  ),
  "inner"
)
rel312 <- duckdb:::rel_project(
  rel311,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("revenue")
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel313 <- duckdb:::rel_project(
  rel312,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("revenue")
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    }
  )
)
rel314 <- duckdb:::rel_order(rel313, list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("revenue")))))
rel315 <- duckdb:::rel_limit(rel314, 20)
rel316 <- duckdb:::rel_from_df(con, df6)
rel317 <- duckdb:::rel_filter(
  rel316,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("n_name"), duckdb:::expr_constant("GERMANY")))
  )
)
rel318 <- duckdb:::rel_from_df(con, df2)
rel319 <- duckdb:::rel_set_alias(rel318, "lhs")
rel320 <- duckdb:::rel_from_df(con, df4)
rel321 <- duckdb:::rel_set_alias(rel320, "rhs")
rel322 <- duckdb:::rel_join(
  rel319,
  rel321,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_suppkey", rel319), duckdb:::expr_reference("s_suppkey", rel321))
    )
  ),
  "inner"
)
rel323 <- duckdb:::rel_project(
  rel322,
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
rel324 <- duckdb:::rel_set_alias(rel323, "lhs")
rel325 <- duckdb:::rel_set_alias(rel317, "rhs")
rel326 <- duckdb:::rel_join(
  rel324,
  rel325,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel324), duckdb:::expr_reference("n_nationkey", rel325))
    )
  ),
  "inner"
)
rel327 <- duckdb:::rel_project(
  rel326,
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
rel328 <- duckdb:::rel_aggregate(
  rel327,
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
          duckdb:::expr_constant(1e-04)
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "global_value")
      tmp_expr
    }
  )
)
rel329 <- duckdb:::rel_project(
  rel328,
  list(
    global_value = {
      tmp_expr <- duckdb:::expr_reference("global_value")
      duckdb:::expr_set_alias(tmp_expr, "global_value")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_constant(1L)
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    }
  )
)
rel330 <- duckdb:::rel_aggregate(
  rel327,
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
rel331 <- duckdb:::rel_project(
  rel330,
  list(
    ps_partkey = {
      tmp_expr <- duckdb:::expr_reference("ps_partkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_partkey")
      tmp_expr
    },
    value = {
      tmp_expr <- duckdb:::expr_reference("value")
      duckdb:::expr_set_alias(tmp_expr, "value")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_constant(1L)
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    }
  )
)
rel332 <- duckdb:::rel_set_alias(rel331, "lhs")
rel333 <- duckdb:::rel_set_alias(rel329, "rhs")
rel334 <- duckdb:::rel_project(
  rel332,
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
rel335 <- duckdb:::rel_project(
  rel333,
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
rel336 <- duckdb:::rel_join(
  rel334,
  rel335,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("global_agr_key_x", rel334), duckdb:::expr_reference("global_agr_key_y", rel335))
    )
  ),
  "inner"
)
rel337 <- duckdb:::rel_project(
  rel336,
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
rel338 <- duckdb:::rel_filter(
  rel337,
  list(
    duckdb:::expr_function(">", list(duckdb:::expr_reference("value"), duckdb:::expr_reference("global_value")))
  )
)
rel339 <- duckdb:::rel_order(rel338, list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("value")))))
rel340 <- duckdb:::rel_project(
  rel339,
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
rel341 <- duckdb:::rel_from_df(con, df1)
rel342 <- duckdb:::rel_filter(
  rel341,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function("==", list(duckdb:::expr_constant("MAIL"), duckdb:::expr_reference("l_shipmode"))),
        duckdb:::expr_function("==", list(duckdb:::expr_constant("SHIP"), duckdb:::expr_reference("l_shipmode")))
      )
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_commitdate"), duckdb:::expr_reference("l_receiptdate"))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_reference("l_commitdate"))
    ),
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("l_receiptdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1994-01-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_receiptdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-01-01"))))
    )
  )
)
rel343 <- duckdb:::rel_set_alias(rel342, "lhs")
rel344 <- duckdb:::rel_from_df(con, df7)
rel345 <- duckdb:::rel_set_alias(rel344, "rhs")
rel346 <- duckdb:::rel_join(
  rel343,
  rel345,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel343), duckdb:::expr_reference("o_orderkey", rel345))
    )
  ),
  "inner"
)
rel347 <- duckdb:::rel_project(
  rel346,
  list(
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
rel348 <- duckdb:::rel_aggregate(
  rel347,
  list(duckdb:::expr_reference("l_shipmode")),
  list(
    high_line_count = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "ifelse",
            list(
              duckdb:::expr_function(
                "|",
                list(
                  duckdb:::expr_function(
                    "==",
                    list(duckdb:::expr_reference("o_orderpriority"), duckdb:::expr_constant("1-URGENT"))
                  ),
                  duckdb:::expr_function(
                    "==",
                    list(duckdb:::expr_reference("o_orderpriority"), duckdb:::expr_constant("2-HIGH"))
                  )
                )
              ),
              duckdb:::expr_constant(1L),
              duckdb:::expr_constant(0L)
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "high_line_count")
      tmp_expr
    },
    low_line_count = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "ifelse",
            list(
              duckdb:::expr_function(
                "&",
                list(
                  duckdb:::expr_function(
                    "!=",
                    list(duckdb:::expr_reference("o_orderpriority"), duckdb:::expr_constant("1-URGENT"))
                  ),
                  duckdb:::expr_function(
                    "!=",
                    list(duckdb:::expr_reference("o_orderpriority"), duckdb:::expr_constant("2-HIGH"))
                  )
                )
              ),
              duckdb:::expr_constant(1L),
              duckdb:::expr_constant(0L)
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "low_line_count")
      tmp_expr
    }
  )
)
rel349 <- duckdb:::rel_order(rel348, list(duckdb:::expr_reference("l_shipmode")))
rel350 <- duckdb:::rel_from_df(con, df7)
rel351 <- duckdb:::rel_filter(
  rel350,
  list(
    duckdb:::expr_function(
      "!",
      list(
        duckdb:::expr_function(
          "grepl",
          list(duckdb:::expr_constant("special.*?requests"), duckdb:::expr_reference("o_comment"))
        )
      )
    )
  )
)
rel352 <- duckdb:::rel_from_df(con, df8)
rel353 <- duckdb:::rel_set_alias(rel352, "lhs")
rel354 <- duckdb:::rel_set_alias(rel351, "rhs")
rel355 <- duckdb:::rel_join(
  rel353,
  rel354,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_custkey", rel353), duckdb:::expr_reference("o_custkey", rel354))
    )
  ),
  "left"
)
rel356 <- duckdb:::rel_project(
  rel355,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
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
rel357 <- duckdb:::rel_aggregate(
  rel356,
  list(duckdb:::expr_reference("c_custkey")),
  list(
    c_count = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "ifelse",
            list(duckdb:::expr_function("is.na", list(duckdb:::expr_reference("o_orderkey"))), duckdb:::expr_constant(0L), duckdb:::expr_constant(1L))
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "c_count")
      tmp_expr
    }
  )
)
rel358 <- duckdb:::rel_aggregate(
  rel357,
  list(duckdb:::expr_reference("c_count")),
  list(
    custdist = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "custdist")
      tmp_expr
    }
  )
)
rel359 <- duckdb:::rel_order(
  rel358,
  list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("custdist"))), duckdb:::expr_function("desc", list(duckdb:::expr_reference("c_count"))))
)
rel360 <- duckdb:::rel_from_df(con, df1)
rel361 <- duckdb:::rel_filter(
  rel360,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-09-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-10-01"))))
    )
  )
)
rel362 <- duckdb:::rel_set_alias(rel361, "lhs")
rel363 <- duckdb:::rel_from_df(con, df3)
rel364 <- duckdb:::rel_set_alias(rel363, "rhs")
rel365 <- duckdb:::rel_join(
  rel362,
  rel364,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel362), duckdb:::expr_reference("p_partkey", rel364))
    )
  ),
  "inner"
)
rel366 <- duckdb:::rel_project(
  rel365,
  list(
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
      tmp_expr <- duckdb:::expr_reference("p_name")
      duckdb:::expr_set_alias(tmp_expr, "p_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_brand")
      duckdb:::expr_set_alias(tmp_expr, "p_brand")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size")
      duckdb:::expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_container")
      duckdb:::expr_set_alias(tmp_expr, "p_container")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_retailprice")
      duckdb:::expr_set_alias(tmp_expr, "p_retailprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_comment")
      duckdb:::expr_set_alias(tmp_expr, "p_comment")
      tmp_expr
    }
  )
)
rel367 <- duckdb:::rel_aggregate(
  rel366,
  list(),
  list(
    promo_revenue = {
      tmp_expr <- duckdb:::expr_function(
        "/",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_constant(100),
              duckdb:::expr_function(
                "sum",
                list(
                  duckdb:::expr_function(
                    "ifelse",
                    list(
                      duckdb:::expr_function("grepl", list(duckdb:::expr_constant("^PROMO"), duckdb:::expr_reference("p_type"))),
                      duckdb:::expr_function(
                        "*",
                        list(
                          duckdb:::expr_reference("l_extendedprice"),
                          duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
                        )
                      ),
                      duckdb:::expr_constant(0)
                    )
                  )
                )
              )
            )
          ),
          duckdb:::expr_function(
            "sum",
            list(
              duckdb:::expr_function(
                "*",
                list(
                  duckdb:::expr_reference("l_extendedprice"),
                  duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
                )
              )
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "promo_revenue")
      tmp_expr
    }
  )
)
rel368 <- duckdb:::rel_from_df(con, df1)
rel369 <- duckdb:::rel_filter(
  rel368,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1996-01-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1996-04-01"))))
    )
  )
)
rel370 <- duckdb:::rel_aggregate(
  rel369,
  list(duckdb:::expr_reference("l_suppkey")),
  list(
    total_revenue = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_reference("l_extendedprice"),
              duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    }
  )
)
rel371 <- duckdb:::rel_project(
  rel370,
  list(
    l_suppkey = {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    total_revenue = {
      tmp_expr <- duckdb:::expr_reference("total_revenue")
      duckdb:::expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_constant(1L)
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    }
  )
)
rel372 <- duckdb:::rel_aggregate(
  rel371,
  list(duckdb:::expr_reference("global_agr_key")),
  list(
    max_total_revenue = {
      tmp_expr <- duckdb:::expr_function("max", list(duckdb:::expr_reference("total_revenue")))
      duckdb:::expr_set_alias(tmp_expr, "max_total_revenue")
      tmp_expr
    }
  )
)
rel373 <- duckdb:::rel_project(
  rel370,
  list(
    l_suppkey = {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    total_revenue = {
      tmp_expr <- duckdb:::expr_reference("total_revenue")
      duckdb:::expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_constant(1L)
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    }
  )
)
rel374 <- duckdb:::rel_set_alias(rel373, "lhs")
rel375 <- duckdb:::rel_set_alias(rel372, "rhs")
rel376 <- duckdb:::rel_project(
  rel374,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("total_revenue")
      duckdb:::expr_set_alias(tmp_expr, "total_revenue_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("global_agr_key")
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key_x")
      tmp_expr
    }
  )
)
rel377 <- duckdb:::rel_project(
  rel375,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("global_agr_key")
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("max_total_revenue")
      duckdb:::expr_set_alias(tmp_expr, "max_total_revenue_y")
      tmp_expr
    }
  )
)
rel378 <- duckdb:::rel_join(
  rel376,
  rel377,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("global_agr_key_x", rel376), duckdb:::expr_reference("global_agr_key_y", rel377))
    )
  ),
  "inner"
)
rel379 <- duckdb:::rel_project(
  rel378,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey_x")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("total_revenue_x")
      duckdb:::expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("global_agr_key_x")
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("max_total_revenue_y")
      duckdb:::expr_set_alias(tmp_expr, "max_total_revenue")
      tmp_expr
    }
  )
)
rel380 <- duckdb:::rel_filter(
  rel379,
  list(
    duckdb:::expr_function(
      "<",
      list(
        duckdb:::expr_function(
          "abs",
          list(
            duckdb:::expr_function(
              "-",
              list(duckdb:::expr_reference("total_revenue"), duckdb:::expr_reference("max_total_revenue"))
            )
          )
        ),
        duckdb:::expr_constant(1e-09)
      )
    )
  )
)
rel381 <- duckdb:::rel_set_alias(rel380, "lhs")
rel382 <- duckdb:::rel_from_df(con, df4)
rel383 <- duckdb:::rel_set_alias(rel382, "rhs")
rel384 <- duckdb:::rel_join(
  rel381,
  rel383,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel381), duckdb:::expr_reference("s_suppkey", rel383))
    )
  ),
  "inner"
)
rel385 <- duckdb:::rel_project(
  rel384,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("total_revenue")
      duckdb:::expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("global_agr_key")
      duckdb:::expr_set_alias(tmp_expr, "global_agr_key")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("max_total_revenue")
      duckdb:::expr_set_alias(tmp_expr, "max_total_revenue")
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
rel386 <- duckdb:::rel_project(
  rel385,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
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
      tmp_expr <- duckdb:::expr_reference("s_phone")
      duckdb:::expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("total_revenue")
      duckdb:::expr_set_alias(tmp_expr, "total_revenue")
      tmp_expr
    }
  )
)
rel387 <- duckdb:::rel_from_df(con, df3)
rel388 <- duckdb:::rel_filter(
  rel387,
  list(
    duckdb:::expr_function("!=", list(duckdb:::expr_reference("p_brand"), duckdb:::expr_constant("Brand#45"))),
    duckdb:::expr_function(
      "!",
      list(
        duckdb:::expr_function(
          "grepl",
          list(duckdb:::expr_constant("^MEDIUM POLISHED"), duckdb:::expr_reference("p_type"))
        )
      )
    ),
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "|",
          list(
            duckdb:::expr_function(
              "|",
              list(
                duckdb:::expr_function(
                  "|",
                  list(
                    duckdb:::expr_function(
                      "|",
                      list(
                        duckdb:::expr_function(
                          "|",
                          list(
                            duckdb:::expr_function(
                              "|",
                              list(
                                duckdb:::expr_function("==", list(duckdb:::expr_constant(49), duckdb:::expr_reference("p_size"))),
                                duckdb:::expr_function("==", list(duckdb:::expr_constant(14), duckdb:::expr_reference("p_size")))
                              )
                            ),
                            duckdb:::expr_function("==", list(duckdb:::expr_constant(23), duckdb:::expr_reference("p_size")))
                          )
                        ),
                        duckdb:::expr_function("==", list(duckdb:::expr_constant(45), duckdb:::expr_reference("p_size")))
                      )
                    ),
                    duckdb:::expr_function("==", list(duckdb:::expr_constant(19), duckdb:::expr_reference("p_size")))
                  )
                ),
                duckdb:::expr_function("==", list(duckdb:::expr_constant(3), duckdb:::expr_reference("p_size")))
              )
            ),
            duckdb:::expr_function("==", list(duckdb:::expr_constant(36), duckdb:::expr_reference("p_size")))
          )
        ),
        duckdb:::expr_function("==", list(duckdb:::expr_constant(9), duckdb:::expr_reference("p_size")))
      )
    )
  )
)
rel389 <- duckdb:::rel_from_df(con, df4)
rel390 <- duckdb:::rel_filter(
  rel389,
  list(
    duckdb:::expr_function(
      "!",
      list(
        duckdb:::expr_function(
          "grepl",
          list(duckdb:::expr_constant("Customer.*?Complaints"), duckdb:::expr_reference("s_comment"))
        )
      )
    )
  )
)
rel391 <- duckdb:::rel_from_df(con, df2)
rel392 <- duckdb:::rel_set_alias(rel391, "lhs")
rel393 <- duckdb:::rel_set_alias(rel390, "rhs")
rel394 <- duckdb:::rel_join(
  rel392,
  rel393,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_suppkey", rel392), duckdb:::expr_reference("s_suppkey", rel393))
    )
  ),
  "inner"
)
rel395 <- duckdb:::rel_project(
  rel394,
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
rel396 <- duckdb:::rel_project(
  rel395,
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
    }
  )
)
rel397 <- duckdb:::rel_set_alias(rel388, "lhs")
rel398 <- duckdb:::rel_set_alias(rel396, "rhs")
rel399 <- duckdb:::rel_join(
  rel397,
  rel398,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("p_partkey", rel397), duckdb:::expr_reference("ps_partkey", rel398))
    )
  ),
  "inner"
)
rel400 <- duckdb:::rel_project(
  rel399,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_partkey")
      duckdb:::expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_name")
      duckdb:::expr_set_alias(tmp_expr, "p_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_brand")
      duckdb:::expr_set_alias(tmp_expr, "p_brand")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size")
      duckdb:::expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_container")
      duckdb:::expr_set_alias(tmp_expr, "p_container")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_retailprice")
      duckdb:::expr_set_alias(tmp_expr, "p_retailprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_comment")
      duckdb:::expr_set_alias(tmp_expr, "p_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("ps_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    }
  )
)
rel401 <- duckdb:::rel_aggregate(
  rel400,
  list(duckdb:::expr_reference("p_brand"), duckdb:::expr_reference("p_type"), duckdb:::expr_reference("p_size")),
  list(
    supplier_cnt = {
      tmp_expr <- duckdb:::expr_function("n_distinct", list(duckdb:::expr_reference("ps_suppkey")))
      duckdb:::expr_set_alias(tmp_expr, "supplier_cnt")
      tmp_expr
    }
  )
)
rel402 <- duckdb:::rel_project(
  rel401,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("p_brand")
      duckdb:::expr_set_alias(tmp_expr, "p_brand")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size")
      duckdb:::expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("supplier_cnt")
      duckdb:::expr_set_alias(tmp_expr, "supplier_cnt")
      tmp_expr
    }
  )
)
rel403 <- duckdb:::rel_order(
  rel402,
  list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("supplier_cnt"))), duckdb:::expr_reference("p_brand"), duckdb:::expr_reference("p_type"), duckdb:::expr_reference("p_size"))
)
rel404 <- duckdb:::rel_from_df(con, df3)
rel405 <- duckdb:::rel_filter(
  rel404,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("p_brand"), duckdb:::expr_constant("Brand#23"))),
    duckdb:::expr_function("==", list(duckdb:::expr_reference("p_container"), duckdb:::expr_constant("MED BOX")))
  )
)
rel406 <- duckdb:::rel_from_df(con, df1)
rel407 <- duckdb:::rel_set_alias(rel406, "lhs")
rel408 <- duckdb:::rel_set_alias(rel405, "rhs")
rel409 <- duckdb:::rel_join(
  rel407,
  rel408,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel407), duckdb:::expr_reference("p_partkey", rel408))
    )
  ),
  "inner"
)
rel410 <- duckdb:::rel_project(
  rel409,
  list(
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
      tmp_expr <- duckdb:::expr_reference("p_name")
      duckdb:::expr_set_alias(tmp_expr, "p_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_brand")
      duckdb:::expr_set_alias(tmp_expr, "p_brand")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size")
      duckdb:::expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_container")
      duckdb:::expr_set_alias(tmp_expr, "p_container")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_retailprice")
      duckdb:::expr_set_alias(tmp_expr, "p_retailprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_comment")
      duckdb:::expr_set_alias(tmp_expr, "p_comment")
      tmp_expr
    }
  )
)
rel411 <- duckdb:::rel_aggregate(
  rel410,
  list(duckdb:::expr_reference("l_partkey")),
  list(
    quantity_threshold = {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(duckdb:::expr_constant(0.2), duckdb:::expr_function("mean", list(duckdb:::expr_reference("l_quantity"))))
      )
      duckdb:::expr_set_alias(tmp_expr, "quantity_threshold")
      tmp_expr
    }
  )
)
rel412 <- duckdb:::rel_set_alias(rel410, "lhs")
rel413 <- duckdb:::rel_set_alias(rel411, "rhs")
rel414 <- duckdb:::rel_project(
  rel412,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linenumber")
      duckdb:::expr_set_alias(tmp_expr, "l_linenumber_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_tax")
      duckdb:::expr_set_alias(tmp_expr, "l_tax_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_returnflag")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linestatus")
      duckdb:::expr_set_alias(tmp_expr, "l_linestatus_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_commitdate")
      duckdb:::expr_set_alias(tmp_expr, "l_commitdate_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_receiptdate")
      duckdb:::expr_set_alias(tmp_expr, "l_receiptdate_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipinstruct")
      duckdb:::expr_set_alias(tmp_expr, "l_shipinstruct_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipmode")
      duckdb:::expr_set_alias(tmp_expr, "l_shipmode_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_comment")
      duckdb:::expr_set_alias(tmp_expr, "l_comment_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_name")
      duckdb:::expr_set_alias(tmp_expr, "p_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_brand")
      duckdb:::expr_set_alias(tmp_expr, "p_brand_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size")
      duckdb:::expr_set_alias(tmp_expr, "p_size_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_container")
      duckdb:::expr_set_alias(tmp_expr, "p_container_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_retailprice")
      duckdb:::expr_set_alias(tmp_expr, "p_retailprice_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_comment")
      duckdb:::expr_set_alias(tmp_expr, "p_comment_x")
      tmp_expr
    }
  )
)
rel415 <- duckdb:::rel_project(
  rel413,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("quantity_threshold")
      duckdb:::expr_set_alias(tmp_expr, "quantity_threshold_y")
      tmp_expr
    }
  )
)
rel416 <- duckdb:::rel_join(
  rel414,
  rel415,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey_x", rel414), duckdb:::expr_reference("l_partkey_y", rel415))
    )
  ),
  "inner"
)
rel417 <- duckdb:::rel_project(
  rel416,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey_x")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_partkey_x")
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey_x")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linenumber_x")
      duckdb:::expr_set_alias(tmp_expr, "l_linenumber")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity_x")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice_x")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount_x")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_tax_x")
      duckdb:::expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_returnflag_x")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linestatus_x")
      duckdb:::expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate_x")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_commitdate_x")
      duckdb:::expr_set_alias(tmp_expr, "l_commitdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_receiptdate_x")
      duckdb:::expr_set_alias(tmp_expr, "l_receiptdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipinstruct_x")
      duckdb:::expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipmode_x")
      duckdb:::expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_comment_x")
      duckdb:::expr_set_alias(tmp_expr, "l_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_name_x")
      duckdb:::expr_set_alias(tmp_expr, "p_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr_x")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_brand_x")
      duckdb:::expr_set_alias(tmp_expr, "p_brand")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type_x")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size_x")
      duckdb:::expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_container_x")
      duckdb:::expr_set_alias(tmp_expr, "p_container")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_retailprice_x")
      duckdb:::expr_set_alias(tmp_expr, "p_retailprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_comment_x")
      duckdb:::expr_set_alias(tmp_expr, "p_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("quantity_threshold_y")
      duckdb:::expr_set_alias(tmp_expr, "quantity_threshold")
      tmp_expr
    }
  )
)
rel418 <- duckdb:::rel_filter(
  rel417,
  list(
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_quantity"), duckdb:::expr_reference("quantity_threshold"))
    )
  )
)
rel419 <- duckdb:::rel_aggregate(
  rel418,
  list(),
  list(
    avg_yearly = {
      tmp_expr <- duckdb:::expr_function(
        "/",
        list(duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_extendedprice"))), duckdb:::expr_constant(7))
      )
      duckdb:::expr_set_alias(tmp_expr, "avg_yearly")
      tmp_expr
    }
  )
)
rel420 <- duckdb:::rel_from_df(con, df1)
rel421 <- duckdb:::rel_aggregate(
  rel420,
  list(duckdb:::expr_reference("l_orderkey")),
  list(
    sum = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_quantity")))
      duckdb:::expr_set_alias(tmp_expr, "sum")
      tmp_expr
    }
  )
)
rel422 <- duckdb:::rel_filter(
  rel421,
  list(
    duckdb:::expr_function(">", list(duckdb:::expr_reference("sum"), duckdb:::expr_constant(300)))
  )
)
rel423 <- duckdb:::rel_from_df(con, df7)
rel424 <- duckdb:::rel_set_alias(rel423, "lhs")
rel425 <- duckdb:::rel_set_alias(rel422, "rhs")
rel426 <- duckdb:::rel_join(
  rel424,
  rel425,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_orderkey", rel424), duckdb:::expr_reference("l_orderkey", rel425))
    )
  ),
  "inner"
)
rel427 <- duckdb:::rel_project(
  rel426,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("sum")
      duckdb:::expr_set_alias(tmp_expr, "sum")
      tmp_expr
    }
  )
)
rel428 <- duckdb:::rel_set_alias(rel427, "lhs")
rel429 <- duckdb:::rel_from_df(con, df8)
rel430 <- duckdb:::rel_set_alias(rel429, "rhs")
rel431 <- duckdb:::rel_join(
  rel428,
  rel430,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_custkey", rel428), duckdb:::expr_reference("c_custkey", rel430))
    )
  ),
  "inner"
)
rel432 <- duckdb:::rel_project(
  rel431,
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("sum")
      duckdb:::expr_set_alias(tmp_expr, "sum")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    }
  )
)
rel433 <- duckdb:::rel_project(
  rel432,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
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
      tmp_expr <- duckdb:::expr_reference("o_totalprice")
      duckdb:::expr_set_alias(tmp_expr, "o_totalprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("sum")
      duckdb:::expr_set_alias(tmp_expr, "sum")
      tmp_expr
    }
  )
)
rel434 <- duckdb:::rel_order(
  rel433,
  list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("o_totalprice"))), duckdb:::expr_reference("o_orderdate"))
)
rel435 <- duckdb:::rel_limit(rel434, 100)
rel436 <- duckdb:::rel_from_df(con, df1)
rel437 <- duckdb:::rel_set_alias(rel436, "lhs")
rel438 <- duckdb:::rel_from_df(con, df3)
rel439 <- duckdb:::rel_set_alias(rel438, "rhs")
rel440 <- duckdb:::rel_join(
  rel437,
  rel439,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel437), duckdb:::expr_reference("p_partkey", rel439))
    )
  ),
  "inner"
)
rel441 <- duckdb:::rel_project(
  rel440,
  list(
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
      tmp_expr <- duckdb:::expr_reference("p_name")
      duckdb:::expr_set_alias(tmp_expr, "p_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_brand")
      duckdb:::expr_set_alias(tmp_expr, "p_brand")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size")
      duckdb:::expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_container")
      duckdb:::expr_set_alias(tmp_expr, "p_container")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_retailprice")
      duckdb:::expr_set_alias(tmp_expr, "p_retailprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_comment")
      duckdb:::expr_set_alias(tmp_expr, "p_comment")
      tmp_expr
    }
  )
)
rel442 <- duckdb:::rel_filter(
  rel441,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "|",
          list(
            duckdb:::expr_function(
              "&",
              list(
                duckdb:::expr_function(
                  "&",
                  list(
                    duckdb:::expr_function(
                      "&",
                      list(
                        duckdb:::expr_function(
                          "&",
                          list(
                            duckdb:::expr_function(
                              "&",
                              list(
                                duckdb:::expr_function(
                                  "&",
                                  list(
                                    duckdb:::expr_function(
                                      "&",
                                      list(
                                        duckdb:::expr_function("==", list(duckdb:::expr_reference("p_brand"), duckdb:::expr_constant("Brand#12"))),
                                        duckdb:::expr_function(
                                          "|",
                                          list(
                                            duckdb:::expr_function(
                                              "|",
                                              list(
                                                duckdb:::expr_function(
                                                  "|",
                                                  list(
                                                    duckdb:::expr_function("==", list(duckdb:::expr_constant("SM CASE"), duckdb:::expr_reference("p_container"))),
                                                    duckdb:::expr_function("==", list(duckdb:::expr_constant("SM BOX"), duckdb:::expr_reference("p_container")))
                                                  )
                                                ),
                                                duckdb:::expr_function("==", list(duckdb:::expr_constant("SM PACK"), duckdb:::expr_reference("p_container")))
                                              )
                                            ),
                                            duckdb:::expr_function("==", list(duckdb:::expr_constant("SM PKG"), duckdb:::expr_reference("p_container")))
                                          )
                                        )
                                      )
                                    ),
                                    duckdb:::expr_function(">=", list(duckdb:::expr_reference("l_quantity"), duckdb:::expr_constant(1)))
                                  )
                                ),
                                duckdb:::expr_function(
                                  "<=",
                                  list(
                                    duckdb:::expr_reference("l_quantity"),
                                    duckdb:::expr_function("+", list(duckdb:::expr_constant(1), duckdb:::expr_constant(10)))
                                  )
                                )
                              )
                            ),
                            duckdb:::expr_function(">=", list(duckdb:::expr_reference("p_size"), duckdb:::expr_constant(1)))
                          )
                        ),
                        duckdb:::expr_function("<=", list(duckdb:::expr_reference("p_size"), duckdb:::expr_constant(5)))
                      )
                    ),
                    duckdb:::expr_function(
                      "|",
                      list(
                        duckdb:::expr_function("==", list(duckdb:::expr_constant("AIR"), duckdb:::expr_reference("l_shipmode"))),
                        duckdb:::expr_function("==", list(duckdb:::expr_constant("AIR REG"), duckdb:::expr_reference("l_shipmode")))
                      )
                    )
                  )
                ),
                duckdb:::expr_function(
                  "==",
                  list(duckdb:::expr_reference("l_shipinstruct"), duckdb:::expr_constant("DELIVER IN PERSON"))
                )
              )
            ),
            duckdb:::expr_function(
              "&",
              list(
                duckdb:::expr_function(
                  "&",
                  list(
                    duckdb:::expr_function(
                      "&",
                      list(
                        duckdb:::expr_function(
                          "&",
                          list(
                            duckdb:::expr_function(
                              "&",
                              list(
                                duckdb:::expr_function(
                                  "&",
                                  list(
                                    duckdb:::expr_function(
                                      "&",
                                      list(
                                        duckdb:::expr_function("==", list(duckdb:::expr_reference("p_brand"), duckdb:::expr_constant("Brand#23"))),
                                        duckdb:::expr_function(
                                          "|",
                                          list(
                                            duckdb:::expr_function(
                                              "|",
                                              list(
                                                duckdb:::expr_function(
                                                  "|",
                                                  list(
                                                    duckdb:::expr_function("==", list(duckdb:::expr_constant("MED BAG"), duckdb:::expr_reference("p_container"))),
                                                    duckdb:::expr_function("==", list(duckdb:::expr_constant("MED BOX"), duckdb:::expr_reference("p_container")))
                                                  )
                                                ),
                                                duckdb:::expr_function("==", list(duckdb:::expr_constant("MED PKG"), duckdb:::expr_reference("p_container")))
                                              )
                                            ),
                                            duckdb:::expr_function(
                                              "==",
                                              list(duckdb:::expr_constant("MED PACK"), duckdb:::expr_reference("p_container"))
                                            )
                                          )
                                        )
                                      )
                                    ),
                                    duckdb:::expr_function(">=", list(duckdb:::expr_reference("l_quantity"), duckdb:::expr_constant(10)))
                                  )
                                ),
                                duckdb:::expr_function(
                                  "<=",
                                  list(
                                    duckdb:::expr_reference("l_quantity"),
                                    duckdb:::expr_function("+", list(duckdb:::expr_constant(10), duckdb:::expr_constant(10)))
                                  )
                                )
                              )
                            ),
                            duckdb:::expr_function(">=", list(duckdb:::expr_reference("p_size"), duckdb:::expr_constant(1)))
                          )
                        ),
                        duckdb:::expr_function("<=", list(duckdb:::expr_reference("p_size"), duckdb:::expr_constant(10)))
                      )
                    ),
                    duckdb:::expr_function(
                      "|",
                      list(
                        duckdb:::expr_function("==", list(duckdb:::expr_constant("AIR"), duckdb:::expr_reference("l_shipmode"))),
                        duckdb:::expr_function("==", list(duckdb:::expr_constant("AIR REG"), duckdb:::expr_reference("l_shipmode")))
                      )
                    )
                  )
                ),
                duckdb:::expr_function(
                  "==",
                  list(duckdb:::expr_reference("l_shipinstruct"), duckdb:::expr_constant("DELIVER IN PERSON"))
                )
              )
            )
          )
        ),
        duckdb:::expr_function(
          "&",
          list(
            duckdb:::expr_function(
              "&",
              list(
                duckdb:::expr_function(
                  "&",
                  list(
                    duckdb:::expr_function(
                      "&",
                      list(
                        duckdb:::expr_function(
                          "&",
                          list(
                            duckdb:::expr_function(
                              "&",
                              list(
                                duckdb:::expr_function(
                                  "&",
                                  list(
                                    duckdb:::expr_function("==", list(duckdb:::expr_reference("p_brand"), duckdb:::expr_constant("Brand#34"))),
                                    duckdb:::expr_function(
                                      "|",
                                      list(
                                        duckdb:::expr_function(
                                          "|",
                                          list(
                                            duckdb:::expr_function(
                                              "|",
                                              list(
                                                duckdb:::expr_function("==", list(duckdb:::expr_constant("LG CASE"), duckdb:::expr_reference("p_container"))),
                                                duckdb:::expr_function("==", list(duckdb:::expr_constant("LG BOX"), duckdb:::expr_reference("p_container")))
                                              )
                                            ),
                                            duckdb:::expr_function("==", list(duckdb:::expr_constant("LG PACK"), duckdb:::expr_reference("p_container")))
                                          )
                                        ),
                                        duckdb:::expr_function("==", list(duckdb:::expr_constant("LG PKG"), duckdb:::expr_reference("p_container")))
                                      )
                                    )
                                  )
                                ),
                                duckdb:::expr_function(">=", list(duckdb:::expr_reference("l_quantity"), duckdb:::expr_constant(20)))
                              )
                            ),
                            duckdb:::expr_function(
                              "<=",
                              list(
                                duckdb:::expr_reference("l_quantity"),
                                duckdb:::expr_function("+", list(duckdb:::expr_constant(20), duckdb:::expr_constant(10)))
                              )
                            )
                          )
                        ),
                        duckdb:::expr_function(">=", list(duckdb:::expr_reference("p_size"), duckdb:::expr_constant(1)))
                      )
                    ),
                    duckdb:::expr_function("<=", list(duckdb:::expr_reference("p_size"), duckdb:::expr_constant(15)))
                  )
                ),
                duckdb:::expr_function(
                  "|",
                  list(
                    duckdb:::expr_function("==", list(duckdb:::expr_constant("AIR"), duckdb:::expr_reference("l_shipmode"))),
                    duckdb:::expr_function("==", list(duckdb:::expr_constant("AIR REG"), duckdb:::expr_reference("l_shipmode")))
                  )
                )
              )
            ),
            duckdb:::expr_function(
              "==",
              list(duckdb:::expr_reference("l_shipinstruct"), duckdb:::expr_constant("DELIVER IN PERSON"))
            )
          )
        )
      )
    )
  )
)
rel443 <- duckdb:::rel_aggregate(
  rel442,
  list(),
  list(
    revenue = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "*",
            list(
              duckdb:::expr_reference("l_extendedprice"),
              duckdb:::expr_function("-", list(duckdb:::expr_constant(1), duckdb:::expr_reference("l_discount")))
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
rel444 <- duckdb:::rel_from_df(con, df6)
rel445 <- duckdb:::rel_filter(
  rel444,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("n_name"), duckdb:::expr_constant("CANADA")))
  )
)
rel446 <- duckdb:::rel_from_df(con, df4)
rel447 <- duckdb:::rel_set_alias(rel446, "lhs")
rel448 <- duckdb:::rel_set_alias(rel445, "rhs")
rel449 <- duckdb:::rel_join(
  rel447,
  rel448,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel447), duckdb:::expr_reference("n_nationkey", rel448))
    )
  ),
  "inner"
)
rel450 <- duckdb:::rel_project(
  rel449,
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
rel451 <- duckdb:::rel_project(
  rel450,
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
    }
  )
)
rel452 <- duckdb:::rel_from_df(con, df3)
rel453 <- duckdb:::rel_filter(
  rel452,
  list(
    duckdb:::expr_function("grepl", list(duckdb:::expr_constant("^forest"), duckdb:::expr_reference("p_name")))
  )
)
rel454 <- duckdb:::rel_from_df(con, df2)
rel455 <- duckdb:::rel_set_alias(rel454, "lhs")
rel456 <- duckdb:::rel_set_alias(rel451, "rhs")
rel457 <- duckdb:::rel_join(
  rel455,
  rel456,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_suppkey", rel455), duckdb:::expr_reference("s_suppkey", rel456))
    )
  ),
  "semi"
)
rel458 <- duckdb:::rel_set_alias(rel457, "lhs")
rel459 <- duckdb:::rel_set_alias(rel453, "rhs")
rel460 <- duckdb:::rel_join(
  rel458,
  rel459,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_partkey", rel458), duckdb:::expr_reference("p_partkey", rel459))
    )
  ),
  "semi"
)
rel461 <- duckdb:::rel_from_df(con, df1)
rel462 <- duckdb:::rel_filter(
  rel461,
  list(
    duckdb:::expr_function(
      ">=",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1994-01-01"))))
    ),
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_shipdate"), duckdb:::expr_function("as.Date", list(duckdb:::expr_constant("1995-01-01"))))
    )
  )
)
rel463 <- duckdb:::rel_set_alias(rel462, "lhs")
rel464 <- duckdb:::rel_set_alias(rel460, "rhs")
rel465 <- duckdb:::rel_join(
  rel463,
  rel464,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel463), duckdb:::expr_reference("ps_partkey", rel464))
    ),
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel463), duckdb:::expr_reference("ps_suppkey", rel464))
    )
  ),
  "semi"
)
rel466 <- duckdb:::rel_aggregate(
  rel465,
  list(duckdb:::expr_reference("l_suppkey")),
  list(
    qty_threshold = {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(duckdb:::expr_constant(0.5), duckdb:::expr_function("sum", list(duckdb:::expr_reference("l_quantity"))))
      )
      duckdb:::expr_set_alias(tmp_expr, "qty_threshold")
      tmp_expr
    }
  )
)
rel467 <- duckdb:::rel_set_alias(rel460, "lhs")
rel468 <- duckdb:::rel_set_alias(rel466, "rhs")
rel469 <- duckdb:::rel_join(
  rel467,
  rel468,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("ps_suppkey", rel467), duckdb:::expr_reference("l_suppkey", rel468))
    )
  ),
  "inner"
)
rel470 <- duckdb:::rel_project(
  rel469,
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
      tmp_expr <- duckdb:::expr_reference("qty_threshold")
      duckdb:::expr_set_alias(tmp_expr, "qty_threshold")
      tmp_expr
    }
  )
)
rel471 <- duckdb:::rel_filter(
  rel470,
  list(
    duckdb:::expr_function(
      ">",
      list(duckdb:::expr_reference("ps_availqty"), duckdb:::expr_reference("qty_threshold"))
    )
  )
)
rel472 <- duckdb:::rel_set_alias(rel451, "lhs")
rel473 <- duckdb:::rel_set_alias(rel471, "rhs")
rel474 <- duckdb:::rel_join(
  rel472,
  rel473,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_suppkey", rel472), duckdb:::expr_reference("ps_suppkey", rel473))
    )
  ),
  "semi"
)
rel475 <- duckdb:::rel_project(
  rel474,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_name")
      duckdb:::expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_address")
      duckdb:::expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    }
  )
)
rel476 <- duckdb:::rel_order(rel475, list(duckdb:::expr_reference("s_name")))
rel477 <- duckdb:::rel_from_df(con, df1)
rel478 <- duckdb:::rel_aggregate(
  rel477,
  list(duckdb:::expr_reference("l_orderkey"), duckdb:::expr_reference("l_suppkey")),
  list(
    n = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "n")
      tmp_expr
    }
  )
)
rel479 <- duckdb:::rel_aggregate(
  rel478,
  list(duckdb:::expr_reference("l_orderkey")),
  list(
    n_supplier = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "n_supplier")
      tmp_expr
    }
  )
)
rel480 <- duckdb:::rel_filter(
  rel479,
  list(
    duckdb:::expr_function(">", list(duckdb:::expr_reference("n_supplier"), duckdb:::expr_constant(1)))
  )
)
rel481 <- duckdb:::rel_from_df(con, df1)
rel482 <- duckdb:::rel_set_alias(rel481, "lhs")
rel483 <- duckdb:::rel_set_alias(rel480, "rhs")
rel484 <- duckdb:::rel_join(
  rel482,
  rel483,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel482), duckdb:::expr_reference("l_orderkey", rel483))
    )
  ),
  "semi"
)
rel485 <- duckdb:::rel_set_alias(rel484, "lhs")
rel486 <- duckdb:::rel_from_df(con, df7)
rel487 <- duckdb:::rel_set_alias(rel486, "rhs")
rel488 <- duckdb:::rel_join(
  rel485,
  rel487,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel485), duckdb:::expr_reference("o_orderkey", rel487))
    )
  ),
  "inner"
)
rel489 <- duckdb:::rel_project(
  rel488,
  list(
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
rel490 <- duckdb:::rel_filter(
  rel489,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("o_orderstatus"), duckdb:::expr_constant("F")))
  )
)
rel491 <- duckdb:::rel_aggregate(
  rel490,
  list(duckdb:::expr_reference("l_orderkey"), duckdb:::expr_reference("l_suppkey")),
  list(
    failed_delivery_commit = {
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
    }
  )
)
rel492 <- duckdb:::rel_aggregate(
  rel491,
  list(duckdb:::expr_reference("l_orderkey")),
  list(
    n_supplier = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "n_supplier")
      tmp_expr
    },
    num_failed = {
      tmp_expr <- duckdb:::expr_function(
        "sum",
        list(
          duckdb:::expr_function(
            "ifelse",
            list(duckdb:::expr_reference("failed_delivery_commit"), duckdb:::expr_constant(1), duckdb:::expr_constant(0))
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "num_failed")
      tmp_expr
    }
  )
)
rel493 <- duckdb:::rel_filter(
  rel492,
  list(
    duckdb:::expr_function(
      "&",
      list(
        duckdb:::expr_function(">", list(duckdb:::expr_reference("n_supplier"), duckdb:::expr_constant(1))),
        duckdb:::expr_function("==", list(duckdb:::expr_reference("num_failed"), duckdb:::expr_constant(1)))
      )
    )
  )
)
rel494 <- duckdb:::rel_from_df(con, df1)
rel495 <- duckdb:::rel_set_alias(rel494, "lhs")
rel496 <- duckdb:::rel_set_alias(rel493, "rhs")
rel497 <- duckdb:::rel_join(
  rel495,
  rel496,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel495), duckdb:::expr_reference("l_orderkey", rel496))
    )
  ),
  "semi"
)
rel498 <- duckdb:::rel_from_df(con, df4)
rel499 <- duckdb:::rel_set_alias(rel498, "lhs")
rel500 <- duckdb:::rel_set_alias(rel497, "rhs")
rel501 <- duckdb:::rel_join(
  rel499,
  rel500,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_suppkey", rel499), duckdb:::expr_reference("l_suppkey", rel500))
    )
  ),
  "inner"
)
rel502 <- duckdb:::rel_project(
  rel501,
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
rel503 <- duckdb:::rel_filter(
  rel502,
  list(
    duckdb:::expr_function(
      ">",
      list(duckdb:::expr_reference("l_receiptdate"), duckdb:::expr_reference("l_commitdate"))
    )
  )
)
rel504 <- duckdb:::rel_set_alias(rel503, "lhs")
rel505 <- duckdb:::rel_from_df(con, df6)
rel506 <- duckdb:::rel_set_alias(rel505, "rhs")
rel507 <- duckdb:::rel_join(
  rel504,
  rel506,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel504), duckdb:::expr_reference("n_nationkey", rel506))
    )
  ),
  "inner"
)
rel508 <- duckdb:::rel_project(
  rel507,
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
rel509 <- duckdb:::rel_filter(
  rel508,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("n_name"), duckdb:::expr_constant("SAUDI ARABIA")))
  )
)
rel510 <- duckdb:::rel_aggregate(
  rel509,
  list(duckdb:::expr_reference("s_name")),
  list(
    numwait = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "numwait")
      tmp_expr
    }
  )
)
rel511 <- duckdb:::rel_order(
  rel510,
  list(duckdb:::expr_function("desc", list(duckdb:::expr_reference("numwait"))), duckdb:::expr_reference("s_name"))
)
rel512 <- duckdb:::rel_limit(rel511, 100)
rel513 <- duckdb:::rel_from_df(con, df8)
rel514 <- duckdb:::rel_filter(
  rel513,
  list(
    duckdb:::expr_function(
      "&",
      list(
        duckdb:::expr_function(
          "|",
          list(
            duckdb:::expr_function(
              "|",
              list(
                duckdb:::expr_function(
                  "|",
                  list(
                    duckdb:::expr_function(
                      "|",
                      list(
                        duckdb:::expr_function(
                          "|",
                          list(
                            duckdb:::expr_function(
                              "|",
                              list(
                                duckdb:::expr_function(
                                  "==",
                                  list(
                                    duckdb:::expr_constant("13"),
                                    duckdb:::expr_function(
                                      "substr",
                                      list(duckdb:::expr_reference("c_phone"), duckdb:::expr_constant(1L), duckdb:::expr_constant(2L))
                                    )
                                  )
                                ),
                                duckdb:::expr_function(
                                  "==",
                                  list(
                                    duckdb:::expr_constant("31"),
                                    duckdb:::expr_function(
                                      "substr",
                                      list(duckdb:::expr_reference("c_phone"), duckdb:::expr_constant(1L), duckdb:::expr_constant(2L))
                                    )
                                  )
                                )
                              )
                            ),
                            duckdb:::expr_function(
                              "==",
                              list(
                                duckdb:::expr_constant("23"),
                                duckdb:::expr_function(
                                  "substr",
                                  list(duckdb:::expr_reference("c_phone"), duckdb:::expr_constant(1L), duckdb:::expr_constant(2L))
                                )
                              )
                            )
                          )
                        ),
                        duckdb:::expr_function(
                          "==",
                          list(
                            duckdb:::expr_constant("29"),
                            duckdb:::expr_function(
                              "substr",
                              list(duckdb:::expr_reference("c_phone"), duckdb:::expr_constant(1L), duckdb:::expr_constant(2L))
                            )
                          )
                        )
                      )
                    ),
                    duckdb:::expr_function(
                      "==",
                      list(
                        duckdb:::expr_constant("30"),
                        duckdb:::expr_function(
                          "substr",
                          list(duckdb:::expr_reference("c_phone"), duckdb:::expr_constant(1L), duckdb:::expr_constant(2L))
                        )
                      )
                    )
                  )
                ),
                duckdb:::expr_function(
                  "==",
                  list(
                    duckdb:::expr_constant("18"),
                    duckdb:::expr_function(
                      "substr",
                      list(duckdb:::expr_reference("c_phone"), duckdb:::expr_constant(1L), duckdb:::expr_constant(2L))
                    )
                  )
                )
              )
            ),
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_constant("17"),
                duckdb:::expr_function(
                  "substr",
                  list(duckdb:::expr_reference("c_phone"), duckdb:::expr_constant(1L), duckdb:::expr_constant(2L))
                )
              )
            )
          )
        ),
        duckdb:::expr_function(">", list(duckdb:::expr_reference("c_acctbal"), duckdb:::expr_constant(0)))
      )
    )
  )
)
rel515 <- duckdb:::rel_aggregate(
  rel514,
  list(),
  list(
    acctbal_min = {
      tmp_expr <- duckdb:::expr_function("mean", list(duckdb:::expr_reference("c_acctbal")))
      duckdb:::expr_set_alias(tmp_expr, "acctbal_min")
      tmp_expr
    },
    join_id = {
      tmp_expr <- duckdb:::expr_constant(1L)
      duckdb:::expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    }
  )
)
rel516 <- duckdb:::rel_from_df(con, df8)
rel517 <- duckdb:::rel_project(
  rel516,
  list(
    c_custkey = {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    c_name = {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    c_address = {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    c_nationkey = {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    c_phone = {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    c_acctbal = {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    c_mktsegment = {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    },
    c_comment = {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_function(
        "substr",
        list(duckdb:::expr_reference("c_phone"), duckdb:::expr_constant(1L), duckdb:::expr_constant(2L))
      )
      duckdb:::expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    }
  )
)
rel518 <- duckdb:::rel_project(
  rel517,
  list(
    c_custkey = {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    c_name = {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    c_address = {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    c_nationkey = {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    c_phone = {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    c_acctbal = {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    c_mktsegment = {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    },
    c_comment = {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    cntrycode = {
      tmp_expr <- duckdb:::expr_reference("cntrycode")
      duckdb:::expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    }, {
      tmp_expr <- duckdb:::expr_constant(1L)
      duckdb:::expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    }
  )
)
rel519 <- duckdb:::rel_set_alias(rel518, "lhs")
rel520 <- duckdb:::rel_set_alias(rel515, "rhs")
rel521 <- duckdb:::rel_project(
  rel519,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_name")
      duckdb:::expr_set_alias(tmp_expr, "c_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_address")
      duckdb:::expr_set_alias(tmp_expr, "c_address_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_phone")
      duckdb:::expr_set_alias(tmp_expr, "c_phone_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_comment")
      duckdb:::expr_set_alias(tmp_expr, "c_comment_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("cntrycode")
      duckdb:::expr_set_alias(tmp_expr, "cntrycode_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("join_id")
      duckdb:::expr_set_alias(tmp_expr, "join_id_x")
      tmp_expr
    }
  )
)
rel522 <- duckdb:::rel_project(
  rel520,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("acctbal_min")
      duckdb:::expr_set_alias(tmp_expr, "acctbal_min_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("join_id")
      duckdb:::expr_set_alias(tmp_expr, "join_id_y")
      tmp_expr
    }
  )
)
rel523 <- duckdb:::rel_join(
  rel521,
  rel522,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("join_id_x", rel521), duckdb:::expr_reference("join_id_y", rel522))
    )
  ),
  "left"
)
rel524 <- duckdb:::rel_project(
  rel523,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey_x")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_name_x")
      duckdb:::expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_address_x")
      duckdb:::expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey_x")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_phone_x")
      duckdb:::expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal_x")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_mktsegment_x")
      duckdb:::expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_comment_x")
      duckdb:::expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("cntrycode_x")
      duckdb:::expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("join_id_x")
      duckdb:::expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("acctbal_min_y")
      duckdb:::expr_set_alias(tmp_expr, "acctbal_min")
      tmp_expr
    }
  )
)
rel525 <- duckdb:::rel_filter(
  rel524,
  list(
    duckdb:::expr_function(
      "&",
      list(
        duckdb:::expr_function(
          "|",
          list(
            duckdb:::expr_function(
              "|",
              list(
                duckdb:::expr_function(
                  "|",
                  list(
                    duckdb:::expr_function(
                      "|",
                      list(
                        duckdb:::expr_function(
                          "|",
                          list(
                            duckdb:::expr_function(
                              "|",
                              list(
                                duckdb:::expr_function("==", list(duckdb:::expr_constant("13"), duckdb:::expr_reference("cntrycode"))),
                                duckdb:::expr_function("==", list(duckdb:::expr_constant("31"), duckdb:::expr_reference("cntrycode")))
                              )
                            ),
                            duckdb:::expr_function("==", list(duckdb:::expr_constant("23"), duckdb:::expr_reference("cntrycode")))
                          )
                        ),
                        duckdb:::expr_function("==", list(duckdb:::expr_constant("29"), duckdb:::expr_reference("cntrycode")))
                      )
                    ),
                    duckdb:::expr_function("==", list(duckdb:::expr_constant("30"), duckdb:::expr_reference("cntrycode")))
                  )
                ),
                duckdb:::expr_function("==", list(duckdb:::expr_constant("18"), duckdb:::expr_reference("cntrycode")))
              )
            ),
            duckdb:::expr_function("==", list(duckdb:::expr_constant("17"), duckdb:::expr_reference("cntrycode")))
          )
        ),
        duckdb:::expr_function(
          ">",
          list(duckdb:::expr_reference("c_acctbal"), duckdb:::expr_reference("acctbal_min"))
        )
      )
    )
  )
)
rel526 <- duckdb:::rel_set_alias(rel525, "lhs")
rel527 <- duckdb:::rel_from_df(con, df7)
rel528 <- duckdb:::rel_set_alias(rel527, "rhs")
rel529 <- duckdb:::rel_join(
  rel526,
  rel528,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_custkey", rel526), duckdb:::expr_reference("o_custkey", rel528))
    )
  ),
  "anti"
)
rel530 <- duckdb:::rel_project(
  rel529,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("cntrycode")
      duckdb:::expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_acctbal")
      duckdb:::expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    }
  )
)
rel531 <- duckdb:::rel_aggregate(
  rel530,
  list(duckdb:::expr_reference("cntrycode")),
  list(
    numcust = {
      tmp_expr <- duckdb:::expr_function("n", list())
      duckdb:::expr_set_alias(tmp_expr, "numcust")
      tmp_expr
    },
    totacctbal = {
      tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("c_acctbal")))
      duckdb:::expr_set_alias(tmp_expr, "totacctbal")
      tmp_expr
    }
  )
)
rel532 <- duckdb:::rel_order(rel531, list(duckdb:::expr_reference("cntrycode")))
rel532
duckdb:::rel_to_altrep(rel532)
