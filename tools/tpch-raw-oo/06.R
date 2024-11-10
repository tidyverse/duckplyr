qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
df1 <- lineitem
"select"
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"select"
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
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
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    }
  )
)
"filter"
rel3 <- duckdb$rel_project(
  rel2,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
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
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
"filter"
rel4 <- duckdb$rel_filter(
  rel3,
  list(
    duckdb$expr_comparison(
      ">=",
      list(
        duckdb$expr_reference("l_shipdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1994-01-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1994-01-01"))
        }
      )
    ),
    duckdb$expr_comparison(
      "<",
      list(
        duckdb$expr_reference("l_shipdate"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(as.Date("1995-01-01"), experimental = experimental)
        } else {
          duckdb$expr_constant(as.Date("1995-01-01"))
        }
      )
    ),
    duckdb$expr_comparison(
      ">=",
      list(
        duckdb$expr_reference("l_discount"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(0.05, experimental = experimental)
        } else {
          duckdb$expr_constant(0.05)
        }
      )
    ),
    duckdb$expr_comparison(
      "<=",
      list(
        duckdb$expr_reference("l_discount"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(0.07, experimental = experimental)
        } else {
          duckdb$expr_constant(0.07)
        }
      )
    ),
    duckdb$expr_comparison(
      "<",
      list(
        duckdb$expr_reference("l_quantity"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(24, experimental = experimental)
        } else {
          duckdb$expr_constant(24)
        }
      )
    )
  )
)
"filter"
rel5 <- duckdb$rel_order(rel4, list(duckdb$expr_reference("___row_number")))
"filter"
rel6 <- duckdb$rel_project(
  rel5,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_shipdate")
      duckdb$expr_set_alias(tmp_expr, "l_shipdate")
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
      tmp_expr <- duckdb$expr_reference("l_quantity")
      duckdb$expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    }
  )
)
"select"
rel7 <- duckdb$rel_project(
  rel6,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_extendedprice")
      duckdb$expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("l_discount")
      duckdb$expr_set_alias(tmp_expr, "l_discount")
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
        "sum",
        list(
          duckdb$expr_function(
            "*",
            list(duckdb$expr_reference("l_extendedprice"), duckdb$expr_reference("l_discount"))
          )
        )
      )
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
"summarise"
rel9 <- duckdb$rel_distinct(rel8)
rel9
duckdb$rel_to_altrep(rel9)
