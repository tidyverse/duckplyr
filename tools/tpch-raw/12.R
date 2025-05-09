qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(duckdb$rapi_load_rfuns(drv@database_ref))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "|"(x, y) AS (x OR y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS (x == y)'))
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "if_else"(test, yes, no) AS (CASE WHEN test IS NULL THEN NULL ELSE CASE WHEN test THEN yes ELSE no END END)'
  )
)
invisible(DBI::dbExecute(con, 'CREATE MACRO "&"(x, y) AS (x AND y)'))
df1 <- lineitem
"filter"
rel1 <- duckdb$rel_from_df(con, df1)
"filter"
rel2 <- duckdb$rel_filter(
  rel1,
  list(
    duckdb$expr_function(
      "___coalesce",
      list(
        duckdb$expr_function(
          "|",
          list(
            duckdb$expr_function("r_base::==", list(duckdb$expr_reference("l_shipmode"), duckdb$expr_constant("MAIL"))),
            duckdb$expr_function("r_base::==", list(duckdb$expr_reference("l_shipmode"), duckdb$expr_constant("SHIP")))
          )
        ),
        duckdb$expr_constant(FALSE)
      )
    ),
    duckdb$expr_comparison(
      "<",
      list(duckdb$expr_reference("l_commitdate"), duckdb$expr_reference("l_receiptdate"))
    ),
    duckdb$expr_comparison(
      "<",
      list(duckdb$expr_reference("l_shipdate"), duckdb$expr_reference("l_commitdate"))
    ),
    duckdb$expr_comparison(
      ">=",
      list(duckdb$expr_reference("l_receiptdate"), duckdb$expr_constant(as.Date("1994-01-01")))
    ),
    duckdb$expr_comparison(
      "<",
      list(duckdb$expr_reference("l_receiptdate"), duckdb$expr_constant(as.Date("1995-01-01")))
    )
  )
)
"inner_join"
rel3 <- duckdb$rel_set_alias(rel2, "lhs")
df2 <- orders
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
      list(duckdb$expr_reference("l_orderkey", rel3), duckdb$expr_reference("o_orderkey", rel5))
    )
  ),
  "inner"
)
"inner_join"
rel7 <- duckdb$rel_project(
  rel6,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_orderkey", rel3), duckdb$expr_reference("o_orderkey", rel5))
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
"summarise"
rel8 <- duckdb$rel_aggregate(
  rel7,
  groups = list(duckdb$expr_reference("l_shipmode")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "if_else",
            list(
              duckdb$expr_function(
                "|",
                list(
                  duckdb$expr_comparison(
                    "==",
                    list(duckdb$expr_reference("o_orderpriority"), duckdb$expr_constant("1-URGENT"))
                  ),
                  duckdb$expr_comparison("==", list(duckdb$expr_reference("o_orderpriority"), duckdb$expr_constant("2-HIGH")))
                )
              ),
              duckdb$expr_constant(1L),
              duckdb$expr_constant(0L)
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "high_line_count")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "if_else",
            list(
              duckdb$expr_function(
                "&",
                list(
                  duckdb$expr_function(
                    "r_base::!=",
                    list(duckdb$expr_reference("o_orderpriority"), duckdb$expr_constant("1-URGENT"))
                  ),
                  duckdb$expr_function("r_base::!=", list(duckdb$expr_reference("o_orderpriority"), duckdb$expr_constant("2-HIGH")))
                )
              ),
              duckdb$expr_constant(1L),
              duckdb$expr_constant(0L)
            )
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "low_line_count")
      tmp_expr
    }
  )
)
"arrange"
rel9 <- duckdb$rel_order(rel8, list(duckdb$expr_reference("l_shipmode")))
rel9
duckdb$rel_to_altrep(rel9)
