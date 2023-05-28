qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"<\"(a, b) AS a < b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n\"() AS (COUNT(*))"))
df1 <- lineitem
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_project(
  rel1,
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
rel3 <- duckdb:::rel_filter(
  rel2,
  list(
    duckdb:::expr_function(
      "<",
      list(duckdb:::expr_reference("l_commitdate"), duckdb:::expr_reference("l_receiptdate"))
    )
  )
)
rel4 <- duckdb:::rel_project(
  rel3,
  list({
    tmp_expr <- duckdb:::expr_reference("l_orderkey")
    duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
    tmp_expr
  })
)
df2 <- orders
rel5 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel6 <- duckdb:::rel_project(
  rel5,
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
rel7 <- duckdb:::rel_filter(
  rel6,
  list(
    duckdb:::expr_function(
      ">=",
      list(
        duckdb:::expr_reference("o_orderdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1993-07-01", experimental = experimental)
            } else {
              duckdb:::expr_constant("1993-07-01")
            }
          )
        )
      )
    ),
    duckdb:::expr_function(
      "<",
      list(
        duckdb:::expr_reference("o_orderdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1993-10-01", experimental = experimental)
            } else {
              duckdb:::expr_constant("1993-10-01")
            }
          )
        )
      )
    )
  )
)
rel8 <- duckdb:::rel_project(
  rel7,
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
rel9 <- duckdb:::rel_set_alias(rel4, "lhs")
rel10 <- duckdb:::rel_set_alias(rel8, "rhs")
rel11 <- duckdb:::rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel12 <- duckdb:::rel_project(
  rel10,
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
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel13 <- duckdb:::rel_join(
  rel11,
  rel12,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel11), duckdb:::expr_reference("o_orderkey", rel12))
    )
  ),
  "inner"
)
rel14 <- duckdb:::rel_order(
  rel13,
  list(duckdb:::expr_reference("___row_number_x", rel11), duckdb:::expr_reference("___row_number_y", rel12))
)
rel15 <- duckdb:::rel_project(
  rel14,
  list(
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_orderkey", rel11), duckdb:::expr_reference("o_orderkey", rel12))
      )
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
rel16 <- duckdb:::rel_project(
  rel15,
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
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel17 <- duckdb:::rel_project(
  rel16,
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
    },
    duckdb:::expr_reference("___row_number"),
    {
      tmp_expr <- duckdb:::expr_window(
        duckdb:::expr_function("row_number", list()),
        list(
          l_orderkey = {
            tmp_expr <- duckdb:::expr_reference("l_orderkey")
            duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
            tmp_expr
          },
          o_orderpriority = {
            tmp_expr <- duckdb:::expr_reference("o_orderpriority")
            duckdb:::expr_set_alias(tmp_expr, "o_orderpriority")
            tmp_expr
          }
        ),
        list(),
        offset_expr = NULL,
        default_expr = NULL
      )
      duckdb:::expr_set_alias(tmp_expr, "___row_number_by")
      tmp_expr
    }
  )
)
rel18 <- duckdb:::rel_filter(
  rel17,
  list(
    duckdb:::expr_function(
      "==",
      list(
        duckdb:::expr_reference("___row_number_by"),
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant(1L, experimental = experimental)
        } else {
          duckdb:::expr_constant(1L)
        }
      )
    )
  )
)
rel19 <- duckdb:::rel_order(rel18, list(duckdb:::expr_reference("___row_number")))
rel20 <- duckdb:::rel_project(
  rel19,
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
rel21 <- duckdb:::rel_project(
  rel20,
  list({
    tmp_expr <- duckdb:::expr_reference("o_orderpriority")
    duckdb:::expr_set_alias(tmp_expr, "o_orderpriority")
    tmp_expr
  })
)
rel22 <- duckdb:::rel_aggregate(
  rel21,
  groups = list(duckdb:::expr_reference("o_orderpriority")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function("n", list())
    duckdb:::expr_set_alias(tmp_expr, "order_count")
    tmp_expr
  })
)
rel23 <- duckdb:::rel_order(rel22, list(duckdb:::expr_reference("o_orderpriority")))
rel23
duckdb:::rel_to_altrep(rel23)
