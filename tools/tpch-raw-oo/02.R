qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(x, y) AS x = y"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"grepl\"(pattern, x) AS regexp_matches(x, pattern)")
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(x, y) AS COALESCE(x, y)"))
invisible(
  DBI::dbExecute(con, "CREATE MACRO \"___eq_na_matches_na\"(x, y) AS (x IS NOT DISTINCT FROM y)")
)
invisible(DBI::dbExecute(con, "CREATE MACRO \"desc\"(x) AS (-x)"))
df1 <- partsupp
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb$rel_project(
  rel1,
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
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    }
  )
)
df2 <- part
rel3 <- duckdb$rel_from_df(con, df2, experimental = experimental)
rel4 <- duckdb$rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
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
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    }
  )
)
rel5 <- duckdb$rel_project(
  rel4,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
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
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel6 <- duckdb$rel_filter(
  rel5,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference("p_size"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant(15, experimental = experimental)
        } else {
          duckdb$expr_constant(15)
        }
      )
    ),
    duckdb$expr_function(
      "grepl",
      list(
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("BRASS$", experimental = experimental)
        } else {
          duckdb$expr_constant("BRASS$")
        },
        duckdb$expr_reference("p_type")
      )
    )
  )
)
rel7 <- duckdb$rel_order(rel6, list(duckdb$expr_reference("___row_number")))
rel8 <- duckdb$rel_project(
  rel7,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
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
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    }
  )
)
rel9 <- duckdb$rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    }
  )
)
rel10 <- duckdb$rel_set_alias(rel9, "lhs")
rel11 <- duckdb$rel_set_alias(rel2, "rhs")
rel12 <- duckdb$rel_project(
  rel10,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel13 <- duckdb$rel_project(
  rel11,
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
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel14 <- duckdb$rel_join(
  rel12,
  rel13,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("p_partkey", rel12), duckdb$expr_reference("ps_partkey", rel13))
    )
  ),
  "inner"
)
rel15 <- duckdb$rel_order(
  rel14,
  list(duckdb$expr_reference("___row_number_x", rel12), duckdb$expr_reference("___row_number_y", rel13))
)
rel16 <- duckdb$rel_project(
  rel15,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("p_partkey", rel12), duckdb$expr_reference("ps_partkey", rel13))
      )
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_suppkey")
      duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    }
  )
)
df3 <- supplier
rel17 <- duckdb$rel_from_df(con, df3, experimental = experimental)
rel18 <- duckdb$rel_project(
  rel17,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel19 <- duckdb$rel_set_alias(rel16, "lhs")
rel20 <- duckdb$rel_set_alias(rel18, "rhs")
rel21 <- duckdb$rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_suppkey")
      duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel22 <- duckdb$rel_project(
  rel20,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_suppkey")
      duckdb$expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
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
rel23 <- duckdb$rel_join(
  rel21,
  rel22,
  list(
    duckdb$expr_function(
      "___eq_na_matches_na",
      list(duckdb$expr_reference("ps_suppkey", rel21), duckdb$expr_reference("s_suppkey", rel22))
    )
  ),
  "inner"
)
rel24 <- duckdb$rel_order(
  rel23,
  list(duckdb$expr_reference("___row_number_x", rel21), duckdb$expr_reference("___row_number_y", rel22))
)
rel25 <- duckdb$rel_project(
  rel24,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("ps_suppkey", rel21), duckdb$expr_reference("s_suppkey", rel22))
      )
      duckdb$expr_set_alias(tmp_expr, "ps_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel26 <- duckdb$rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
df4 <- region
rel27 <- duckdb$rel_from_df(con, df4, experimental = experimental)
rel28 <- duckdb$rel_project(
  rel27,
  list(
    {
      tmp_expr <- duckdb$expr_reference("r_regionkey")
      duckdb$expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_name")
      duckdb$expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_comment")
      duckdb$expr_set_alias(tmp_expr, "r_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel29 <- duckdb$rel_filter(
  rel28,
  list(
    duckdb$expr_function(
      "==",
      list(
        duckdb$expr_reference("r_name"),
        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
          duckdb$expr_constant("EUROPE", experimental = experimental)
        } else {
          duckdb$expr_constant("EUROPE")
        }
      )
    )
  )
)
rel30 <- duckdb$rel_order(rel29, list(duckdb$expr_reference("___row_number")))
rel31 <- duckdb$rel_project(
  rel30,
  list(
    {
      tmp_expr <- duckdb$expr_reference("r_regionkey")
      duckdb$expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_name")
      duckdb$expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_comment")
      duckdb$expr_set_alias(tmp_expr, "r_comment")
      tmp_expr
    }
  )
)
df5 <- nation
rel32 <- duckdb$rel_from_df(con, df5, experimental = experimental)
rel33 <- duckdb$rel_set_alias(rel32, "lhs")
rel34 <- duckdb$rel_set_alias(rel31, "rhs")
rel35 <- duckdb$rel_project(
  rel33,
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
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel36 <- duckdb$rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb$expr_reference("r_regionkey")
      duckdb$expr_set_alias(tmp_expr, "r_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_name")
      duckdb$expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_comment")
      duckdb$expr_set_alias(tmp_expr, "r_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel37 <- duckdb$rel_join(
  rel35,
  rel36,
  list(
    duckdb$expr_function(
      "___eq_na_matches_na",
      list(duckdb$expr_reference("n_regionkey", rel35), duckdb$expr_reference("r_regionkey", rel36))
    )
  ),
  "inner"
)
rel38 <- duckdb$rel_order(
  rel37,
  list(duckdb$expr_reference("___row_number_x", rel35), duckdb$expr_reference("___row_number_y", rel36))
)
rel39 <- duckdb$rel_project(
  rel38,
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
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("n_regionkey", rel35), duckdb$expr_reference("r_regionkey", rel36))
      )
      duckdb$expr_set_alias(tmp_expr, "n_regionkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_comment")
      duckdb$expr_set_alias(tmp_expr, "n_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_name")
      duckdb$expr_set_alias(tmp_expr, "r_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("r_comment")
      duckdb$expr_set_alias(tmp_expr, "r_comment")
      tmp_expr
    }
  )
)
rel40 <- duckdb$rel_project(
  rel39,
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
    }
  )
)
rel41 <- duckdb$rel_set_alias(rel26, "lhs")
rel42 <- duckdb$rel_set_alias(rel40, "rhs")
rel43 <- duckdb$rel_project(
  rel41,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_nationkey")
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
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
rel44 <- duckdb$rel_project(
  rel42,
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel45 <- duckdb$rel_join(
  rel43,
  rel44,
  list(
    duckdb$expr_function(
      "___eq_na_matches_na",
      list(duckdb$expr_reference("s_nationkey", rel43), duckdb$expr_reference("n_nationkey", rel44))
    )
  ),
  "inner"
)
rel46 <- duckdb$rel_order(
  rel45,
  list(duckdb$expr_reference("___row_number_x", rel43), duckdb$expr_reference("___row_number_y", rel44))
)
rel47 <- duckdb$rel_project(
  rel46,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("s_nationkey", rel43), duckdb$expr_reference("n_nationkey", rel44))
      )
      duckdb$expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    }
  )
)
rel48 <- duckdb$rel_project(
  rel47,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel49 <- duckdb$rel_project(
  rel48,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
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
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel50 <- duckdb$rel_aggregate(
  rel49,
  groups = list(duckdb$expr_reference("p_partkey")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("___row_number")))
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("ps_supplycost")))
      duckdb$expr_set_alias(tmp_expr, "min_ps_supplycost")
      tmp_expr
    }
  )
)
rel51 <- duckdb$rel_order(rel50, list(duckdb$expr_reference("___row_number")))
rel52 <- duckdb$rel_project(
  rel51,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("min_ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "min_ps_supplycost")
      tmp_expr
    }
  )
)
rel53 <- duckdb$rel_set_alias(rel48, "lhs")
rel54 <- duckdb$rel_set_alias(rel52, "rhs")
rel55 <- duckdb$rel_project(
  rel53,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_name")
      duckdb$expr_set_alias(tmp_expr, "s_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_address")
      duckdb$expr_set_alias(tmp_expr, "s_address_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_phone")
      duckdb$expr_set_alias(tmp_expr, "s_phone_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment_x")
      tmp_expr
    }
  )
)
rel56 <- duckdb$rel_project(
  rel54,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("min_ps_supplycost")
      duckdb$expr_set_alias(tmp_expr, "min_ps_supplycost_y")
      tmp_expr
    }
  )
)
rel57 <- duckdb$rel_project(
  rel55,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey_x")
      duckdb$expr_set_alias(tmp_expr, "p_partkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("ps_supplycost_x")
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr_x")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name_x")
      duckdb$expr_set_alias(tmp_expr, "n_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal_x")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_name_x")
      duckdb$expr_set_alias(tmp_expr, "s_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_address_x")
      duckdb$expr_set_alias(tmp_expr, "s_address_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_phone_x")
      duckdb$expr_set_alias(tmp_expr, "s_phone_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_comment_x")
      duckdb$expr_set_alias(tmp_expr, "s_comment_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel58 <- duckdb$rel_project(
  rel56,
  list(
    {
      tmp_expr <- duckdb$expr_reference("p_partkey_y")
      duckdb$expr_set_alias(tmp_expr, "p_partkey_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("min_ps_supplycost_y")
      duckdb$expr_set_alias(tmp_expr, "min_ps_supplycost_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel59 <- duckdb$rel_join(
  rel57,
  rel58,
  list(
    duckdb$expr_function(
      "___eq_na_matches_na",
      list(duckdb$expr_reference("p_partkey_x", rel57), duckdb$expr_reference("p_partkey_y", rel58))
    ),
    duckdb$expr_function(
      "___eq_na_matches_na",
      list(duckdb$expr_reference("ps_supplycost_x", rel57), duckdb$expr_reference("min_ps_supplycost_y", rel58))
    )
  ),
  "inner"
)
rel60 <- duckdb$rel_order(
  rel59,
  list(duckdb$expr_reference("___row_number_x", rel57), duckdb$expr_reference("___row_number_y", rel58))
)
rel61 <- duckdb$rel_project(
  rel60,
  list(
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("p_partkey_x", rel57), duckdb$expr_reference("p_partkey_y", rel58))
      )
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("ps_supplycost_x", rel57), duckdb$expr_reference("min_ps_supplycost_y", rel58))
      )
      duckdb$expr_set_alias(tmp_expr, "ps_supplycost")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr_x")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name_x")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal_x")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_name_x")
      duckdb$expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_address_x")
      duckdb$expr_set_alias(tmp_expr, "s_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_phone_x")
      duckdb$expr_set_alias(tmp_expr, "s_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_comment_x")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel62 <- duckdb$rel_project(
  rel61,
  list(
    {
      tmp_expr <- duckdb$expr_reference("s_acctbal")
      duckdb$expr_set_alias(tmp_expr, "s_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("s_name")
      duckdb$expr_set_alias(tmp_expr, "s_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("n_name")
      duckdb$expr_set_alias(tmp_expr, "n_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_partkey")
      duckdb$expr_set_alias(tmp_expr, "p_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("p_mfgr")
      duckdb$expr_set_alias(tmp_expr, "p_mfgr")
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
      tmp_expr <- duckdb$expr_reference("s_comment")
      duckdb$expr_set_alias(tmp_expr, "s_comment")
      tmp_expr
    }
  )
)
rel63 <- duckdb$rel_order(
  rel62,
  list(duckdb$expr_function("desc", list(duckdb$expr_reference("s_acctbal"))), duckdb$expr_reference("n_name"), duckdb$expr_reference("s_name"), duckdb$expr_reference("p_partkey"))
)
rel64 <- duckdb$rel_limit(rel63, 100)
rel64
duckdb$rel_to_altrep(rel64)
