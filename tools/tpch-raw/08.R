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
df1 <- nation
rel1 <- duckdb:::rel_from_df(con, df1)
rel2 <- duckdb:::rel_project(
  rel1,
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
df2 <- region
rel3 <- duckdb:::rel_from_df(con, df2)
rel4 <- duckdb:::rel_project(
  rel3,
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
rel5 <- duckdb:::rel_filter(
  rel4,
  list(
    duckdb:::expr_function("==", list(duckdb:::expr_reference("r_name"), duckdb:::expr_constant("AMERICA")))
  )
)
rel6 <- duckdb:::rel_project(
  rel5,
  list({
    tmp_expr <- duckdb:::expr_reference("r_regionkey")
    duckdb:::expr_set_alias(tmp_expr, "r_regionkey")
    tmp_expr
  })
)
rel7 <- duckdb:::rel_set_alias(rel2, "lhs")
rel8 <- duckdb:::rel_set_alias(rel6, "rhs")
rel9 <- duckdb:::rel_join(
  rel7,
  rel8,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("n1_regionkey", rel7), duckdb:::expr_reference("r_regionkey", rel8))
    )
  ),
  "inner"
)
rel10 <- duckdb:::rel_project(
  rel9,
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
rel11 <- duckdb:::rel_project(
  rel10,
  list({
    tmp_expr <- duckdb:::expr_reference("n1_nationkey")
    duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
    tmp_expr
  })
)
df3 <- customer
rel12 <- duckdb:::rel_from_df(con, df3)
rel13 <- duckdb:::rel_project(
  rel12,
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
rel14 <- duckdb:::rel_set_alias(rel13, "lhs")
rel15 <- duckdb:::rel_set_alias(rel11, "rhs")
rel16 <- duckdb:::rel_join(
  rel14,
  rel15,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_nationkey", rel14), duckdb:::expr_reference("n1_nationkey", rel15))
    )
  ),
  "inner"
)
rel17 <- duckdb:::rel_project(
  rel16,
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
rel18 <- duckdb:::rel_project(
  rel17,
  list({
    tmp_expr <- duckdb:::expr_reference("c_custkey")
    duckdb:::expr_set_alias(tmp_expr, "c_custkey")
    tmp_expr
  })
)
df4 <- orders
rel19 <- duckdb:::rel_from_df(con, df4)
rel20 <- duckdb:::rel_project(
  rel19,
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
rel21 <- duckdb:::rel_filter(
  rel20,
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
rel22 <- duckdb:::rel_set_alias(rel21, "lhs")
rel23 <- duckdb:::rel_set_alias(rel18, "rhs")
rel24 <- duckdb:::rel_join(
  rel22,
  rel23,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_custkey", rel22), duckdb:::expr_reference("c_custkey", rel23))
    )
  ),
  "inner"
)
rel25 <- duckdb:::rel_project(
  rel24,
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
rel26 <- duckdb:::rel_project(
  rel25,
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
df5 <- lineitem
rel27 <- duckdb:::rel_from_df(con, df5)
rel28 <- duckdb:::rel_project(
  rel27,
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
rel29 <- duckdb:::rel_set_alias(rel28, "lhs")
rel30 <- duckdb:::rel_set_alias(rel26, "rhs")
rel31 <- duckdb:::rel_join(
  rel29,
  rel30,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel29), duckdb:::expr_reference("o_orderkey", rel30))
    )
  ),
  "inner"
)
rel32 <- duckdb:::rel_project(
  rel31,
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
rel33 <- duckdb:::rel_project(
  rel32,
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
df6 <- part
rel34 <- duckdb:::rel_from_df(con, df6)
rel35 <- duckdb:::rel_project(
  rel34,
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
rel36 <- duckdb:::rel_filter(
  rel35,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("p_type"), duckdb:::expr_constant("ECONOMY ANODIZED STEEL"))
    )
  )
)
rel37 <- duckdb:::rel_project(
  rel36,
  list({
    tmp_expr <- duckdb:::expr_reference("p_partkey")
    duckdb:::expr_set_alias(tmp_expr, "p_partkey")
    tmp_expr
  })
)
rel38 <- duckdb:::rel_set_alias(rel33, "lhs")
rel39 <- duckdb:::rel_set_alias(rel37, "rhs")
rel40 <- duckdb:::rel_join(
  rel38,
  rel39,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel38), duckdb:::expr_reference("p_partkey", rel39))
    )
  ),
  "inner"
)
rel41 <- duckdb:::rel_project(
  rel40,
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
rel42 <- duckdb:::rel_project(
  rel41,
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
df7 <- supplier
rel43 <- duckdb:::rel_from_df(con, df7)
rel44 <- duckdb:::rel_project(
  rel43,
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
rel45 <- duckdb:::rel_set_alias(rel42, "lhs")
rel46 <- duckdb:::rel_set_alias(rel44, "rhs")
rel47 <- duckdb:::rel_join(
  rel45,
  rel46,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel45), duckdb:::expr_reference("s_suppkey", rel46))
    )
  ),
  "inner"
)
rel48 <- duckdb:::rel_project(
  rel47,
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
rel49 <- duckdb:::rel_project(
  rel48,
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
rel50 <- duckdb:::rel_from_df(con, df1)
rel51 <- duckdb:::rel_project(
  rel50,
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
rel52 <- duckdb:::rel_set_alias(rel49, "lhs")
rel53 <- duckdb:::rel_set_alias(rel51, "rhs")
rel54 <- duckdb:::rel_join(
  rel52,
  rel53,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel52), duckdb:::expr_reference("n2_nationkey", rel53))
    )
  ),
  "inner"
)
rel55 <- duckdb:::rel_project(
  rel54,
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
rel56 <- duckdb:::rel_project(
  rel55,
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
rel57 <- duckdb:::rel_project(
  rel56,
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
rel58 <- duckdb:::rel_project(
  rel57,
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
rel59 <- duckdb:::rel_project(
  rel58,
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
rel60 <- duckdb:::rel_project(
  rel59,
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
rel61 <- duckdb:::rel_aggregate(
  rel60,
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
rel62 <- duckdb:::rel_order(rel61, list(duckdb:::expr_reference("o_year")))
rel62
duckdb:::rel_to_altrep(rel62)
