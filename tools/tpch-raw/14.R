qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS (x == y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(
  DBI::dbExecute(
    con,
    r"[CREATE MACRO "___divide"(x, y) AS CASE WHEN y = 0 THEN CASE WHEN x = 0 THEN CAST('NaN' AS double) WHEN x > 0 THEN CAST('+Infinity' AS double) ELSE CAST('-Infinity' AS double) END ELSE CAST(x AS double) / y END]"
  )
)
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "if_else"(test, yes, no) AS (CASE WHEN test IS NULL THEN NULL ELSE CASE WHEN test THEN yes ELSE no END END)'
  )
)
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "grepl"(pattern, x) AS (CASE WHEN x IS NULL THEN FALSE ELSE regexp_matches(x, pattern) END)'
  )
)
df1 <- lineitem
"filter"
rel1 <- duckdb$rel_from_df(con, df1)
"filter"
rel2 <- duckdb$rel_filter(
  rel1,
  list(
    duckdb$expr_comparison(
      ">=",
      list(duckdb$expr_reference("l_shipdate"), duckdb$expr_constant(as.Date("1995-09-01")))
    ),
    duckdb$expr_comparison(
      "<",
      list(duckdb$expr_reference("l_shipdate"), duckdb$expr_constant(as.Date("1995-10-01")))
    )
  )
)
"inner_join"
rel3 <- duckdb$rel_set_alias(rel2, "lhs")
df2 <- part
"inner_join"
rel4 <- duckdb$rel_from_df(con, df2)
"inner_join"
rel5 <- duckdb$rel_set_alias(rel4, "rhs")
"inner_join"
rel6 <- duckdb$rel_join(
  rel3,
  rel5,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_partkey", rel3), duckdb$expr_reference("p_partkey", rel5))
    )
  ),
  "inner"
)
"inner_join"
rel7 <- duckdb$rel_project(
  rel6,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_partkey", rel3), duckdb$expr_reference("p_partkey", rel5))
      )
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
      tmp_expr <- duckdb$expr_reference("p_name")
      duckdb$expr_set_alias(tmp_expr, "p_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_brand")
      duckdb$expr_set_alias(tmp_expr, "p_brand")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_type")
      duckdb$expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_size")
      duckdb$expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_container")
      duckdb$expr_set_alias(tmp_expr, "p_container")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_retailprice")
      duckdb$expr_set_alias(tmp_expr, "p_retailprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_comment")
      duckdb$expr_set_alias(tmp_expr, "p_comment")
      tmp_expr
    }
  )
)
"summarise"
rel8 <- duckdb$rel_aggregate(
  rel7,
  groups = list(),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "___divide",
        list(
          duckdb$expr_function(
            "*",
            list(
              duckdb$expr_constant(100),
              duckdb$expr_function(
                "sum",
                list(
                  duckdb$expr_function(
                    "if_else",
                    list(
                      duckdb$expr_function("grepl", list(duckdb$expr_constant("^PROMO"), duckdb$expr_reference("p_type"))),
                      duckdb$expr_function(
                        "*",
                        list(
                          duckdb$expr_reference("l_extendedprice"),
                          duckdb$expr_function("-", list(duckdb$expr_constant(1), duckdb$expr_reference("l_discount")))
                        )
                      ),
                      duckdb$expr_constant(0)
                    )
                  )
                )
              )
            )
          ),
          duckdb$expr_function(
            "sum",
            list(
              duckdb$expr_function(
                "*",
                list(
                  duckdb$expr_reference("l_extendedprice"),
                  duckdb$expr_function("-", list(duckdb$expr_constant(1), duckdb$expr_reference("l_discount")))
                )
              )
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "promo_revenue")
      tmp_expr
    }
  )
)
"summarise"
rel9 <- duckdb$rel_distinct(rel8)
rel9
duckdb$rel_to_altrep(rel9)
