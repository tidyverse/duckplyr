# Generated by meta_replay_to_fun_file(), do not edit by hand
# nocov start
tpch_raw_oo_20 <- function(con, experimental) {
  df1 <- nation
  "filter"
  rel1 <- duckdb$rel_from_df(con, df1)
  "filter"
  rel2 <- duckdb$rel_project(
    rel1,
    list(
      {
        tmp_expr <- duckdb$expr_reference("n_nationkey")
        duckdb$expr_set_alias(tmp_expr, "n_nationkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_name")
        duckdb$expr_set_alias(tmp_expr, "n_name")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_regionkey")
        duckdb$expr_set_alias(tmp_expr, "n_regionkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_comment")
        duckdb$expr_set_alias(tmp_expr, "n_comment")
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
  rel3 <- duckdb$rel_filter(
    rel2,
    list(
      duckdb$expr_comparison("==", list(duckdb$expr_reference("n_name"), duckdb$expr_constant("CANADA")))
    )
  )
  "filter"
  rel4 <- duckdb$rel_order(rel3, list(duckdb$expr_reference("___row_number")))
  "filter"
  rel5 <- duckdb$rel_project(
    rel4,
    list(
      {
        tmp_expr <- duckdb$expr_reference("n_nationkey")
        duckdb$expr_set_alias(tmp_expr, "n_nationkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_name")
        duckdb$expr_set_alias(tmp_expr, "n_name")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_regionkey")
        duckdb$expr_set_alias(tmp_expr, "n_regionkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_comment")
        duckdb$expr_set_alias(tmp_expr, "n_comment")
        tmp_expr
      }
    )
  )
  df2 <- supplier
  "inner_join"
  rel6 <- duckdb$rel_from_df(con, df2)
  "inner_join"
  rel7 <- duckdb$rel_set_alias(rel6, "lhs")
  "inner_join"
  rel8 <- duckdb$rel_set_alias(rel5, "rhs")
  "inner_join"
  rel9 <- duckdb$rel_project(
    rel7,
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
        duckdb$expr_set_alias(tmp_expr, "___row_number_x")
        tmp_expr
      }
    )
  )
  "inner_join"
  rel10 <- duckdb$rel_project(
    rel8,
    list(
      {
        tmp_expr <- duckdb$expr_reference("n_nationkey")
        duckdb$expr_set_alias(tmp_expr, "n_nationkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_name")
        duckdb$expr_set_alias(tmp_expr, "n_name")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_regionkey")
        duckdb$expr_set_alias(tmp_expr, "n_regionkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_comment")
        duckdb$expr_set_alias(tmp_expr, "n_comment")
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
  rel11 <- duckdb$rel_join(
    rel9,
    rel10,
    list(
      duckdb$expr_function(
        "==",
        list(duckdb$expr_reference("s_nationkey", rel9), duckdb$expr_reference("n_nationkey", rel10))
      )
    ),
    "inner"
  )
  "inner_join"
  rel12 <- duckdb$rel_order(
    rel11,
    list(duckdb$expr_reference("___row_number_x", rel9), duckdb$expr_reference("___row_number_y", rel10))
  )
  "inner_join"
  rel13 <- duckdb$rel_project(
    rel12,
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
        tmp_expr <- duckdb$expr_function(
          "___coalesce",
          list(duckdb$expr_reference("s_nationkey", rel9), duckdb$expr_reference("n_nationkey", rel10))
        )
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
        tmp_expr <- duckdb$expr_reference("n_name")
        duckdb$expr_set_alias(tmp_expr, "n_name")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_regionkey")
        duckdb$expr_set_alias(tmp_expr, "n_regionkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("n_comment")
        duckdb$expr_set_alias(tmp_expr, "n_comment")
        tmp_expr
      }
    )
  )
  "select"
  rel14 <- duckdb$rel_project(
    rel13,
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
      }
    )
  )
  df3 <- part
  "filter"
  rel15 <- duckdb$rel_from_df(con, df3)
  "filter"
  rel16 <- duckdb$rel_project(
    rel15,
    list(
      {
        tmp_expr <- duckdb$expr_reference("p_partkey")
        duckdb$expr_set_alias(tmp_expr, "p_partkey")
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
      },
      {
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number")
        tmp_expr
      }
    )
  )
  "filter"
  rel17 <- duckdb$rel_filter(
    rel16,
    list(
      duckdb$expr_function("grepl", list(duckdb$expr_constant("^forest"), duckdb$expr_reference("p_name")))
    )
  )
  "filter"
  rel18 <- duckdb$rel_order(rel17, list(duckdb$expr_reference("___row_number")))
  "filter"
  rel19 <- duckdb$rel_project(
    rel18,
    list(
      {
        tmp_expr <- duckdb$expr_reference("p_partkey")
        duckdb$expr_set_alias(tmp_expr, "p_partkey")
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
  df4 <- partsupp
  "semi_join"
  rel20 <- duckdb$rel_from_df(con, df4)
  "semi_join"
  rel21 <- duckdb$rel_set_alias(rel20, "lhs")
  "semi_join"
  rel22 <- duckdb$rel_set_alias(rel14, "rhs")
  "semi_join"
  rel23 <- duckdb$rel_project(
    rel21,
    list(
      {
        tmp_expr <- duckdb$expr_reference("ps_partkey")
        duckdb$expr_set_alias(tmp_expr, "ps_partkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_suppkey")
        duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_availqty")
        duckdb$expr_set_alias(tmp_expr, "ps_availqty")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_supplycost")
        duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_comment")
        duckdb$expr_set_alias(tmp_expr, "ps_comment")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number_x")
        tmp_expr
      }
    )
  )
  "semi_join"
  rel24 <- duckdb$rel_join(
    rel23,
    rel22,
    list(
      duckdb$expr_function(
        "==",
        list(duckdb$expr_reference("ps_suppkey", rel23), duckdb$expr_reference("s_suppkey", rel22))
      )
    ),
    "semi"
  )
  "semi_join"
  rel25 <- duckdb$rel_order(rel24, list(duckdb$expr_reference("___row_number_x", rel23)))
  "semi_join"
  rel26 <- duckdb$rel_project(
    rel25,
    list(
      {
        tmp_expr <- duckdb$expr_reference("ps_partkey")
        duckdb$expr_set_alias(tmp_expr, "ps_partkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_suppkey")
        duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_availqty")
        duckdb$expr_set_alias(tmp_expr, "ps_availqty")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_supplycost")
        duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_comment")
        duckdb$expr_set_alias(tmp_expr, "ps_comment")
        tmp_expr
      }
    )
  )
  "semi_join"
  rel27 <- duckdb$rel_set_alias(rel26, "lhs")
  "semi_join"
  rel28 <- duckdb$rel_set_alias(rel19, "rhs")
  "semi_join"
  rel29 <- duckdb$rel_project(
    rel27,
    list(
      {
        tmp_expr <- duckdb$expr_reference("ps_partkey")
        duckdb$expr_set_alias(tmp_expr, "ps_partkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_suppkey")
        duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_availqty")
        duckdb$expr_set_alias(tmp_expr, "ps_availqty")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_supplycost")
        duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_comment")
        duckdb$expr_set_alias(tmp_expr, "ps_comment")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number_x")
        tmp_expr
      }
    )
  )
  "semi_join"
  rel30 <- duckdb$rel_join(
    rel29,
    rel28,
    list(
      duckdb$expr_function(
        "==",
        list(duckdb$expr_reference("ps_partkey", rel29), duckdb$expr_reference("p_partkey", rel28))
      )
    ),
    "semi"
  )
  "semi_join"
  rel31 <- duckdb$rel_order(rel30, list(duckdb$expr_reference("___row_number_x", rel29)))
  "semi_join"
  rel32 <- duckdb$rel_project(
    rel31,
    list(
      {
        tmp_expr <- duckdb$expr_reference("ps_partkey")
        duckdb$expr_set_alias(tmp_expr, "ps_partkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_suppkey")
        duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_availqty")
        duckdb$expr_set_alias(tmp_expr, "ps_availqty")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_supplycost")
        duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_comment")
        duckdb$expr_set_alias(tmp_expr, "ps_comment")
        tmp_expr
      }
    )
  )
  df5 <- lineitem
  "filter"
  rel33 <- duckdb$rel_from_df(con, df5)
  "filter"
  rel34 <- duckdb$rel_project(
    rel33,
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
  "filter"
  rel35 <- duckdb$rel_filter(
    rel34,
    list(
      duckdb$expr_comparison(
        ">=",
        list(duckdb$expr_reference("l_shipdate"), duckdb$expr_constant(as.Date("1994-01-01")))
      ),
      duckdb$expr_comparison(
        "<",
        list(duckdb$expr_reference("l_shipdate"), duckdb$expr_constant(as.Date("1995-01-01")))
      )
    )
  )
  "filter"
  rel36 <- duckdb$rel_order(rel35, list(duckdb$expr_reference("___row_number")))
  "filter"
  rel37 <- duckdb$rel_project(
    rel36,
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
  "semi_join"
  rel38 <- duckdb$rel_set_alias(rel37, "lhs")
  "semi_join"
  rel39 <- duckdb$rel_set_alias(rel32, "rhs")
  "semi_join"
  rel40 <- duckdb$rel_project(
    rel38,
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
        duckdb$expr_set_alias(tmp_expr, "___row_number_x")
        tmp_expr
      }
    )
  )
  "semi_join"
  rel41 <- duckdb$rel_join(
    rel40,
    rel39,
    list(
      duckdb$expr_function(
        "==",
        list(duckdb$expr_reference("l_partkey", rel40), duckdb$expr_reference("ps_partkey", rel39))
      ),
      duckdb$expr_function(
        "==",
        list(duckdb$expr_reference("l_suppkey", rel40), duckdb$expr_reference("ps_suppkey", rel39))
      )
    ),
    "semi"
  )
  "semi_join"
  rel42 <- duckdb$rel_order(rel41, list(duckdb$expr_reference("___row_number_x", rel40)))
  "semi_join"
  rel43 <- duckdb$rel_project(
    rel42,
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
  "summarise"
  rel44 <- duckdb$rel_project(
    rel43,
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
  "summarise"
  rel45 <- duckdb$rel_aggregate(
    rel44,
    groups = list(duckdb$expr_reference("l_suppkey")),
    aggregates = list(
      {
        tmp_expr <- duckdb$expr_function("___min_na", list(duckdb$expr_reference("___row_number")))
        duckdb$expr_set_alias(tmp_expr, "___row_number")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_function(
          "*",
          list(duckdb$expr_constant(0.5), duckdb$expr_function("sum", list(duckdb$expr_reference("l_quantity"))))
        )
        duckdb$expr_set_alias(tmp_expr, "qty_threshold")
        tmp_expr
      }
    )
  )
  "summarise"
  rel46 <- duckdb$rel_order(rel45, list(duckdb$expr_reference("___row_number")))
  "summarise"
  rel47 <- duckdb$rel_project(
    rel46,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_suppkey")
        duckdb$expr_set_alias(tmp_expr, "l_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("qty_threshold")
        duckdb$expr_set_alias(tmp_expr, "qty_threshold")
        tmp_expr
      }
    )
  )
  "inner_join"
  rel48 <- duckdb$rel_set_alias(rel32, "lhs")
  "inner_join"
  rel49 <- duckdb$rel_set_alias(rel47, "rhs")
  "inner_join"
  rel50 <- duckdb$rel_project(
    rel48,
    list(
      {
        tmp_expr <- duckdb$expr_reference("ps_partkey")
        duckdb$expr_set_alias(tmp_expr, "ps_partkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_suppkey")
        duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_availqty")
        duckdb$expr_set_alias(tmp_expr, "ps_availqty")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_supplycost")
        duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_comment")
        duckdb$expr_set_alias(tmp_expr, "ps_comment")
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
  rel51 <- duckdb$rel_project(
    rel49,
    list(
      {
        tmp_expr <- duckdb$expr_reference("l_suppkey")
        duckdb$expr_set_alias(tmp_expr, "l_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("qty_threshold")
        duckdb$expr_set_alias(tmp_expr, "qty_threshold")
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
  rel52 <- duckdb$rel_join(
    rel50,
    rel51,
    list(
      duckdb$expr_function(
        "==",
        list(duckdb$expr_reference("ps_suppkey", rel50), duckdb$expr_reference("l_suppkey", rel51))
      )
    ),
    "inner"
  )
  "inner_join"
  rel53 <- duckdb$rel_order(
    rel52,
    list(duckdb$expr_reference("___row_number_x", rel50), duckdb$expr_reference("___row_number_y", rel51))
  )
  "inner_join"
  rel54 <- duckdb$rel_project(
    rel53,
    list(
      {
        tmp_expr <- duckdb$expr_reference("ps_partkey")
        duckdb$expr_set_alias(tmp_expr, "ps_partkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_function(
          "___coalesce",
          list(duckdb$expr_reference("ps_suppkey", rel50), duckdb$expr_reference("l_suppkey", rel51))
        )
        duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_availqty")
        duckdb$expr_set_alias(tmp_expr, "ps_availqty")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_supplycost")
        duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_comment")
        duckdb$expr_set_alias(tmp_expr, "ps_comment")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("qty_threshold")
        duckdb$expr_set_alias(tmp_expr, "qty_threshold")
        tmp_expr
      }
    )
  )
  "filter"
  rel55 <- duckdb$rel_project(
    rel54,
    list(
      {
        tmp_expr <- duckdb$expr_reference("ps_partkey")
        duckdb$expr_set_alias(tmp_expr, "ps_partkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_suppkey")
        duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_availqty")
        duckdb$expr_set_alias(tmp_expr, "ps_availqty")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_supplycost")
        duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_comment")
        duckdb$expr_set_alias(tmp_expr, "ps_comment")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("qty_threshold")
        duckdb$expr_set_alias(tmp_expr, "qty_threshold")
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
  rel56 <- duckdb$rel_filter(
    rel55,
    list(
      duckdb$expr_comparison(
        ">",
        list(duckdb$expr_reference("ps_availqty"), duckdb$expr_reference("qty_threshold"))
      )
    )
  )
  "filter"
  rel57 <- duckdb$rel_order(rel56, list(duckdb$expr_reference("___row_number")))
  "filter"
  rel58 <- duckdb$rel_project(
    rel57,
    list(
      {
        tmp_expr <- duckdb$expr_reference("ps_partkey")
        duckdb$expr_set_alias(tmp_expr, "ps_partkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_suppkey")
        duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_availqty")
        duckdb$expr_set_alias(tmp_expr, "ps_availqty")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_supplycost")
        duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("ps_comment")
        duckdb$expr_set_alias(tmp_expr, "ps_comment")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("qty_threshold")
        duckdb$expr_set_alias(tmp_expr, "qty_threshold")
        tmp_expr
      }
    )
  )
  "semi_join"
  rel59 <- duckdb$rel_set_alias(rel14, "lhs")
  "semi_join"
  rel60 <- duckdb$rel_set_alias(rel58, "rhs")
  "semi_join"
  rel61 <- duckdb$rel_project(
    rel59,
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
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number_x")
        tmp_expr
      }
    )
  )
  "semi_join"
  rel62 <- duckdb$rel_join(
    rel61,
    rel60,
    list(
      duckdb$expr_function(
        "==",
        list(duckdb$expr_reference("s_suppkey", rel61), duckdb$expr_reference("ps_suppkey", rel60))
      )
    ),
    "semi"
  )
  "semi_join"
  rel63 <- duckdb$rel_order(rel62, list(duckdb$expr_reference("___row_number_x", rel61)))
  "semi_join"
  rel64 <- duckdb$rel_project(
    rel63,
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
      }
    )
  )
  "select"
  rel65 <- duckdb$rel_project(
    rel64,
    list(
      {
        tmp_expr <- duckdb$expr_reference("s_name")
        duckdb$expr_set_alias(tmp_expr, "s_name")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("s_address")
        duckdb$expr_set_alias(tmp_expr, "s_address")
        tmp_expr
      }
    )
  )
  "arrange"
  rel66 <- duckdb$rel_project(
    rel65,
    list(
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
        tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
        duckdb$expr_set_alias(tmp_expr, "___row_number")
        tmp_expr
      }
    )
  )
  "arrange"
  rel67 <- duckdb$rel_order(rel66, list(duckdb$expr_reference("s_name"), duckdb$expr_reference("___row_number")))
  "arrange"
  rel68 <- duckdb$rel_project(
    rel67,
    list(
      {
        tmp_expr <- duckdb$expr_reference("s_name")
        duckdb$expr_set_alias(tmp_expr, "s_name")
        tmp_expr
      },
      {
        tmp_expr <- duckdb$expr_reference("s_address")
        duckdb$expr_set_alias(tmp_expr, "s_address")
        tmp_expr
      }
    )
  )
  rel68
  duckdb$rel_to_altrep(rel68)
}
# nocov end
