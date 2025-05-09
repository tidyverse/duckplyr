# Generated by meta_replay_to_fun_file(), do not edit by hand
# nocov start
tpch_raw_oo_03 <- function(con, experimental) {
  df1 <- orders
  "select"
  rel1 <- duckdb$rel_from_df(con, df1)
  "select"
  rel2 <- duckdb$rel_project(
    rel1,
    list(
      {
        tmp_expr <- duckdb$expr_reference("o_orderkey")
        duckdb$expr_set_alias(tmp_expr, "o_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_custkey")
        duckdb$expr_set_alias(tmp_expr, "o_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      }
    )
  )
  "filter"
  rel3 <- duckdb$rel_project(
    rel2,
    list(
      {
        tmp_expr <- duckdb$expr_reference("o_orderkey")
        duckdb$expr_set_alias(tmp_expr, "o_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_custkey")
        duckdb$expr_set_alias(tmp_expr, "o_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
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
        "<",
        list(duckdb$expr_reference("o_orderdate"), duckdb$expr_constant(as.Date("1995-03-15")))
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
        tmp_expr <- duckdb$expr_reference("o_orderkey")
        duckdb$expr_set_alias(tmp_expr, "o_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_custkey")
        duckdb$expr_set_alias(tmp_expr, "o_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      }
    )
  )
  df2 <- customer
  "select"
  rel7 <- duckdb$rel_from_df(con, df2)
  "select"
  rel8 <- duckdb$rel_project(
    rel7,
    list(
      {
        tmp_expr <- duckdb$expr_reference("c_custkey")
        duckdb$expr_set_alias(tmp_expr, "c_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("c_mktsegment")
        duckdb$expr_set_alias(tmp_expr, "c_mktsegment")
        tmp_expr
      }
    )
  )
  "filter"
  rel9 <- duckdb$rel_project(
    rel8,
    list(
      {
        tmp_expr <- duckdb$expr_reference("c_custkey")
        duckdb$expr_set_alias(tmp_expr, "c_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("c_mktsegment")
        duckdb$expr_set_alias(tmp_expr, "c_mktsegment")
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
  rel10 <- duckdb$rel_filter(
    rel9,
    list(
      duckdb$expr_comparison("==", list(duckdb$expr_reference("c_mktsegment"), duckdb$expr_constant("BUILDING")))
    )
  )
  "filter"
  rel11 <- duckdb$rel_order(rel10, list(duckdb$expr_reference("___row_number")))
  "filter"
  rel12 <- duckdb$rel_project(
    rel11,
    list(
      {
        tmp_expr <- duckdb$expr_reference("c_custkey")
        duckdb$expr_set_alias(tmp_expr, "c_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("c_mktsegment")
        duckdb$expr_set_alias(tmp_expr, "c_mktsegment")
        tmp_expr
      }
    )
  )
  "inner_join"
  rel13 <- duckdb$rel_set_alias(rel6, "lhs")
  "inner_join"
  rel14 <- duckdb$rel_set_alias(rel12, "rhs")
  "inner_join"
  rel15 <- duckdb$rel_project(
    rel13,
    list(
      {
        tmp_expr <- duckdb$expr_reference("o_orderkey")
        duckdb$expr_set_alias(tmp_expr, "o_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_custkey")
        duckdb$expr_set_alias(tmp_expr, "o_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number_x")
        tmp_expr
      }
    )
  )
  "inner_join"
  rel16 <- duckdb$rel_project(
    rel14,
    list(
      {
        tmp_expr <- duckdb$expr_reference("c_custkey")
        duckdb$expr_set_alias(tmp_expr, "c_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("c_mktsegment")
        duckdb$expr_set_alias(tmp_expr, "c_mktsegment")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number_y")
        tmp_expr
      }
    )
  )
  "inner_join"
  rel17 <- duckdb$rel_join(
    rel15,
    rel16,
    list(
      duckdb$expr_function(
        "___eq_na_matches_na",
        list(duckdb$expr_reference("o_custkey", rel15), duckdb$expr_reference("c_custkey", rel16))
      )
    ),
    "inner"
  )
  "inner_join"
  rel18 <- duckdb$rel_order(
    rel17,
    list(duckdb$expr_reference("___row_number_x", rel15), duckdb$expr_reference("___row_number_y", rel16))
  )
  "inner_join"
  rel19 <- duckdb$rel_project(
    rel18,
    list(
      {
        tmp_expr <- duckdb$expr_reference("o_orderkey")
        duckdb$expr_set_alias(tmp_expr, "o_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_function(
          "___coalesce",
          list(duckdb$expr_reference("o_custkey", rel15), duckdb$expr_reference("c_custkey", rel16))
        )
        duckdb$expr_set_alias(tmp_expr, "o_custkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("c_mktsegment")
        duckdb$expr_set_alias(tmp_expr, "c_mktsegment")
        tmp_expr
      }
    )
  )
  "select"
  rel20 <- duckdb$rel_project(
    rel19,
    list(
      {
        tmp_expr <- duckdb$expr_reference("o_orderkey")
        duckdb$expr_set_alias(tmp_expr, "o_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      }
    )
  )
  df3 <- lineitem
  "select"
  rel21 <- duckdb$rel_from_df(con, df3)
  "select"
  rel22 <- duckdb$rel_project(
    rel21,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
        tmp_expr
      },
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
      }
    )
  )
  "filter"
  rel23 <- duckdb$rel_project(
    rel22,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
        tmp_expr
      },
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
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number")
        tmp_expr
      }
    )
  )
  "filter"
  rel24 <- duckdb$rel_filter(
    rel23,
    list(
      duckdb$expr_comparison(
        ">",
        list(duckdb$expr_reference("l_shipdate"), duckdb$expr_constant(as.Date("1995-03-15")))
      )
    )
  )
  "filter"
  rel25 <- duckdb$rel_order(rel24, list(duckdb$expr_reference("___row_number")))
  "filter"
  rel26 <- duckdb$rel_project(
    rel25,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
        tmp_expr
      },
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
      }
    )
  )
  "select"
  rel27 <- duckdb$rel_project(
    rel26,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
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
      }
    )
  )
  "inner_join"
  rel28 <- duckdb$rel_set_alias(rel27, "lhs")
  "inner_join"
  rel29 <- duckdb$rel_set_alias(rel20, "rhs")
  "inner_join"
  rel30 <- duckdb$rel_project(
    rel28,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
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
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number_x")
        tmp_expr
      }
    )
  )
  "inner_join"
  rel31 <- duckdb$rel_project(
    rel29,
    list(
      {
        tmp_expr <- duckdb$expr_reference("o_orderkey")
        duckdb$expr_set_alias(tmp_expr, "o_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number_y")
        tmp_expr
      }
    )
  )
  "inner_join"
  rel32 <- duckdb$rel_join(
    rel30,
    rel31,
    list(
      duckdb$expr_function(
        "___eq_na_matches_na",
        list(duckdb$expr_reference("l_orderkey", rel30), duckdb$expr_reference("o_orderkey", rel31))
      )
    ),
    "inner"
  )
  "inner_join"
  rel33 <- duckdb$rel_order(
    rel32,
    list(duckdb$expr_reference("___row_number_x", rel30), duckdb$expr_reference("___row_number_y", rel31))
  )
  "inner_join"
  rel34 <- duckdb$rel_project(
    rel33,
    list(
      {
        tmp_expr <- duckdb$expr_function(
          "___coalesce",
          list(duckdb$expr_reference("l_orderkey", rel30), duckdb$expr_reference("o_orderkey", rel31))
        )
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
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
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      }
    )
  )
  "mutate"
  rel35 <- duckdb$rel_project(
    rel34,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
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
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_function(
          "*",
          list(
            duckdb$expr_reference("l_extendedprice"),
            duckdb$expr_function("-", list(duckdb$expr_constant(1), duckdb$expr_reference("l_discount")))
          )
        )
        duckdb$expr_set_alias(tmp_expr, "volume")
        tmp_expr
      }
    )
  )
  "summarise"
  rel36 <- duckdb$rel_project(
    rel35,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
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
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("volume")
        duckdb$expr_set_alias(tmp_expr, "volume")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number")
        tmp_expr
      }
    )
  )
  "summarise"
  rel37 <- duckdb$rel_aggregate(
    rel36,
    groups = list(duckdb$expr_reference("l_orderkey"), duckdb$expr_reference("o_orderdate"), duckdb$expr_reference("o_shippriority")),
    aggregates = list(
      {
        tmp_expr <- duckdb$expr_function("___min_na", list(duckdb$expr_reference("___row_number")))
        duckdb$expr_set_alias(tmp_expr, "___row_number")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_function("sum", list(duckdb$expr_reference("volume")))
        duckdb$expr_set_alias(tmp_expr, "revenue")
        tmp_expr
      }
    )
  )
  "summarise"
  rel38 <- duckdb$rel_order(rel37, list(duckdb$expr_reference("___row_number")))
  "summarise"
  rel39 <- duckdb$rel_project(
    rel38,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("revenue")
        duckdb$expr_set_alias(tmp_expr, "revenue")
        tmp_expr
      }
    )
  )
  "select"
  rel40 <- duckdb$rel_project(
    rel39,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("revenue")
        duckdb$expr_set_alias(tmp_expr, "revenue")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      }
    )
  )
  "arrange"
  rel41 <- duckdb$rel_project(
    rel40,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("revenue")
        duckdb$expr_set_alias(tmp_expr, "revenue")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number")
        tmp_expr
      }
    )
  )
  "arrange"
  rel42 <- duckdb$rel_order(
    rel41,
    list(duckdb$expr_reference("revenue"), duckdb$expr_reference("o_orderdate"), duckdb$expr_reference("___row_number"))
  )
  "arrange"
  rel43 <- duckdb$rel_project(
    rel42,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_orderkey")
        duckdb$expr_set_alias(tmp_expr, "l_orderkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("revenue")
        duckdb$expr_set_alias(tmp_expr, "revenue")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_orderdate")
        duckdb$expr_set_alias(tmp_expr, "o_orderdate")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("o_shippriority")
        duckdb$expr_set_alias(tmp_expr, "o_shippriority")
        tmp_expr
      }
    )
  )
  "slice_head"
  rel44 <- duckdb$rel_limit(rel43, 10)
  rel44
  duckdb$rel_to_altrep(rel44)
}
# nocov end
