qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(DBI::dbExecute(con, 'CREATE MACRO "!"(x) AS (NOT x)'))
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "grepl"(pattern, x) AS (CASE WHEN x IS NULL THEN FALSE ELSE regexp_matches(x, pattern) END)'
  )
)
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS (x == y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(
  DBI::dbExecute(
    con,
    'CREATE MACRO "if_else"(test, yes, no) AS (CASE WHEN test IS NULL THEN NULL ELSE CASE WHEN test THEN yes ELSE no END END)'
  )
)
invisible(DBI::dbExecute(con, 'CREATE MACRO "is.na"(x) AS (x IS NULL)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "n"() AS CAST(COUNT(*) AS int32)'))
df1 <- orders
"filter"
rel1 <- duckdb$rel_from_df(con, df1)
"filter"
rel2 <- duckdb$rel_filter(
  rel1,
  list(
    duckdb$expr_function(
      "!",
      list(
        duckdb$expr_function(
          "grepl",
          list(duckdb$expr_constant("special.*?requests"), duckdb$expr_reference("o_comment"))
        )
      )
    )
  )
)
df2 <- customer
"left_join"
rel3 <- duckdb$rel_from_df(con, df2)
"left_join"
rel4 <- duckdb$rel_set_alias(rel3, "lhs")
"left_join"
rel5 <- duckdb$rel_set_alias(rel2, "rhs")
"left_join"
rel6 <- duckdb$rel_join(
  rel4,
  rel5,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("c_custkey", rel4), duckdb$expr_reference("o_custkey", rel5))
    )
  ),
  "left"
)
"left_join"
rel7 <- duckdb$rel_project(
  rel6,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("c_custkey", rel4), duckdb$expr_reference("o_custkey", rel5))
      )
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_nationkey")
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_mktsegment")
      duckdb$expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("o_orderkey")
      duckdb$expr_set_alias(tmp_expr, "o_orderkey")
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
  groups = list(duckdb$expr_reference("c_custkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
        "sum",
        list(
          duckdb$expr_function(
            "if_else",
            list(duckdb$expr_function("is.na", list(duckdb$expr_reference("o_orderkey"))), duckdb$expr_constant(0L), duckdb$expr_constant(1L))
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "c_count")
      tmp_expr
    }
  )
)
"summarise"
rel9 <- duckdb$rel_aggregate(
  rel8,
  groups = list(duckdb$expr_reference("c_count")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("n", list())
      duckdb$expr_set_alias(tmp_expr, "custdist")
      tmp_expr
    }
  )
)
"arrange"
rel10 <- duckdb$rel_order(rel9, list(duckdb$expr_reference("custdist"), duckdb$expr_reference("c_count")))
rel10
duckdb$rel_to_altrep(rel10)
