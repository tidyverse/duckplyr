qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
invisible(DBI::dbExecute(con, 'CREATE MACRO "=="(x, y) AS (x == y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(duckdb$rapi_load_rfuns(drv@database_ref))
invisible(DBI::dbExecute(con, 'CREATE MACRO "|"(x, y) AS (x OR y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "&"(x, y) AS (x AND y)'))
df1 <- lineitem
"inner_join"
rel1 <- duckdb$rel_from_df(con, df1)
"inner_join"
rel2 <- duckdb$rel_set_alias(rel1, "lhs")
df2 <- part
"inner_join"
rel3 <- duckdb$rel_from_df(con, df2)
"inner_join"
rel4 <- duckdb$rel_set_alias(rel3, "rhs")
"inner_join"
rel5 <- duckdb$rel_project(
  rel2,
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
"inner_join"
rel6 <- duckdb$rel_project(
  rel4,
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
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
"inner_join"
rel7 <- duckdb$rel_join(
  rel5,
  rel6,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("l_partkey", rel5), duckdb$expr_reference("p_partkey", rel6))
    )
  ),
  "inner"
)
"inner_join"
rel8 <- duckdb$rel_order(
  rel7,
  list(duckdb$expr_reference("___row_number_x", rel5), duckdb$expr_reference("___row_number_y", rel6))
)
"inner_join"
rel9 <- duckdb$rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb$expr_reference("l_orderkey")
      duckdb$expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("l_partkey", rel5), duckdb$expr_reference("p_partkey", rel6))
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
"filter"
rel10 <- duckdb$rel_project(
  rel9,
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
rel11 <- duckdb$rel_filter(
  rel10,
  list(
    duckdb$expr_function(
      "|",
      list(
        duckdb$expr_function(
          "|",
          list(
            duckdb$expr_function(
              "&",
              list(
                duckdb$expr_function(
                  "&",
                  list(
                    duckdb$expr_function(
                      "&",
                      list(
                        duckdb$expr_function(
                          "&",
                          list(
                            duckdb$expr_function(
                              "&",
                              list(
                                duckdb$expr_function(
                                  "&",
                                  list(
                                    duckdb$expr_function(
                                      "&",
                                      list(
                                        duckdb$expr_comparison("==", list(duckdb$expr_reference("p_brand"), duckdb$expr_constant("Brand#12"))),
                                        duckdb$expr_function(
                                          "___coalesce",
                                          list(
                                            duckdb$expr_function(
                                              "|",
                                              list(
                                                duckdb$expr_function(
                                                  "|",
                                                  list(
                                                    duckdb$expr_function(
                                                      "|",
                                                      list(
                                                        duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("SM CASE"))),
                                                        duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("SM BOX")))
                                                      )
                                                    ),
                                                    duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("SM PACK")))
                                                  )
                                                ),
                                                duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("SM PKG")))
                                              )
                                            ),
                                            duckdb$expr_constant(FALSE)
                                          )
                                        )
                                      )
                                    ),
                                    duckdb$expr_comparison(">=", list(duckdb$expr_reference("l_quantity"), duckdb$expr_constant(1)))
                                  )
                                ),
                                duckdb$expr_function(
                                  "r_base::<=",
                                  list(
                                    duckdb$expr_reference("l_quantity"),
                                    duckdb$expr_function("+", list(duckdb$expr_constant(1), duckdb$expr_constant(10)))
                                  )
                                )
                              )
                            ),
                            duckdb$expr_comparison(">=", list(duckdb$expr_reference("p_size"), duckdb$expr_constant(1)))
                          )
                        ),
                        duckdb$expr_comparison("<=", list(duckdb$expr_reference("p_size"), duckdb$expr_constant(5)))
                      )
                    ),
                    duckdb$expr_function(
                      "___coalesce",
                      list(
                        duckdb$expr_function(
                          "|",
                          list(
                            duckdb$expr_function("r_base::==", list(duckdb$expr_reference("l_shipmode"), duckdb$expr_constant("AIR"))),
                            duckdb$expr_function("r_base::==", list(duckdb$expr_reference("l_shipmode"), duckdb$expr_constant("AIR REG")))
                          )
                        ),
                        duckdb$expr_constant(FALSE)
                      )
                    )
                  )
                ),
                duckdb$expr_comparison(
                  "==",
                  list(duckdb$expr_reference("l_shipinstruct"), duckdb$expr_constant("DELIVER IN PERSON"))
                )
              )
            ),
            duckdb$expr_function(
              "&",
              list(
                duckdb$expr_function(
                  "&",
                  list(
                    duckdb$expr_function(
                      "&",
                      list(
                        duckdb$expr_function(
                          "&",
                          list(
                            duckdb$expr_function(
                              "&",
                              list(
                                duckdb$expr_function(
                                  "&",
                                  list(
                                    duckdb$expr_function(
                                      "&",
                                      list(
                                        duckdb$expr_comparison("==", list(duckdb$expr_reference("p_brand"), duckdb$expr_constant("Brand#23"))),
                                        duckdb$expr_function(
                                          "___coalesce",
                                          list(
                                            duckdb$expr_function(
                                              "|",
                                              list(
                                                duckdb$expr_function(
                                                  "|",
                                                  list(
                                                    duckdb$expr_function(
                                                      "|",
                                                      list(
                                                        duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("MED BAG"))),
                                                        duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("MED BOX")))
                                                      )
                                                    ),
                                                    duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("MED PKG")))
                                                  )
                                                ),
                                                duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("MED PACK")))
                                              )
                                            ),
                                            duckdb$expr_constant(FALSE)
                                          )
                                        )
                                      )
                                    ),
                                    duckdb$expr_comparison(">=", list(duckdb$expr_reference("l_quantity"), duckdb$expr_constant(10)))
                                  )
                                ),
                                duckdb$expr_function(
                                  "r_base::<=",
                                  list(
                                    duckdb$expr_reference("l_quantity"),
                                    duckdb$expr_function("+", list(duckdb$expr_constant(10), duckdb$expr_constant(10)))
                                  )
                                )
                              )
                            ),
                            duckdb$expr_comparison(">=", list(duckdb$expr_reference("p_size"), duckdb$expr_constant(1)))
                          )
                        ),
                        duckdb$expr_comparison("<=", list(duckdb$expr_reference("p_size"), duckdb$expr_constant(10)))
                      )
                    ),
                    duckdb$expr_function(
                      "___coalesce",
                      list(
                        duckdb$expr_function(
                          "|",
                          list(
                            duckdb$expr_function("r_base::==", list(duckdb$expr_reference("l_shipmode"), duckdb$expr_constant("AIR"))),
                            duckdb$expr_function("r_base::==", list(duckdb$expr_reference("l_shipmode"), duckdb$expr_constant("AIR REG")))
                          )
                        ),
                        duckdb$expr_constant(FALSE)
                      )
                    )
                  )
                ),
                duckdb$expr_comparison(
                  "==",
                  list(duckdb$expr_reference("l_shipinstruct"), duckdb$expr_constant("DELIVER IN PERSON"))
                )
              )
            )
          )
        ),
        duckdb$expr_function(
          "&",
          list(
            duckdb$expr_function(
              "&",
              list(
                duckdb$expr_function(
                  "&",
                  list(
                    duckdb$expr_function(
                      "&",
                      list(
                        duckdb$expr_function(
                          "&",
                          list(
                            duckdb$expr_function(
                              "&",
                              list(
                                duckdb$expr_function(
                                  "&",
                                  list(
                                    duckdb$expr_comparison("==", list(duckdb$expr_reference("p_brand"), duckdb$expr_constant("Brand#34"))),
                                    duckdb$expr_function(
                                      "___coalesce",
                                      list(
                                        duckdb$expr_function(
                                          "|",
                                          list(
                                            duckdb$expr_function(
                                              "|",
                                              list(
                                                duckdb$expr_function(
                                                  "|",
                                                  list(
                                                    duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("LG CASE"))),
                                                    duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("LG BOX")))
                                                  )
                                                ),
                                                duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("LG PACK")))
                                              )
                                            ),
                                            duckdb$expr_function("r_base::==", list(duckdb$expr_reference("p_container"), duckdb$expr_constant("LG PKG")))
                                          )
                                        ),
                                        duckdb$expr_constant(FALSE)
                                      )
                                    )
                                  )
                                ),
                                duckdb$expr_comparison(">=", list(duckdb$expr_reference("l_quantity"), duckdb$expr_constant(20)))
                              )
                            ),
                            duckdb$expr_function(
                              "r_base::<=",
                              list(
                                duckdb$expr_reference("l_quantity"),
                                duckdb$expr_function("+", list(duckdb$expr_constant(20), duckdb$expr_constant(10)))
                              )
                            )
                          )
                        ),
                        duckdb$expr_comparison(">=", list(duckdb$expr_reference("p_size"), duckdb$expr_constant(1)))
                      )
                    ),
                    duckdb$expr_comparison("<=", list(duckdb$expr_reference("p_size"), duckdb$expr_constant(15)))
                  )
                ),
                duckdb$expr_function(
                  "___coalesce",
                  list(
                    duckdb$expr_function(
                      "|",
                      list(
                        duckdb$expr_function("r_base::==", list(duckdb$expr_reference("l_shipmode"), duckdb$expr_constant("AIR"))),
                        duckdb$expr_function("r_base::==", list(duckdb$expr_reference("l_shipmode"), duckdb$expr_constant("AIR REG")))
                      )
                    ),
                    duckdb$expr_constant(FALSE)
                  )
                )
              )
            ),
            duckdb$expr_comparison(
              "==",
              list(duckdb$expr_reference("l_shipinstruct"), duckdb$expr_constant("DELIVER IN PERSON"))
            )
          )
        )
      )
    )
  )
)
"filter"
rel12 <- duckdb$rel_order(rel11, list(duckdb$expr_reference("___row_number")))
"filter"
rel13 <- duckdb$rel_project(
  rel12,
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
rel14 <- duckdb$rel_aggregate(
  rel13,
  groups = list(),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function(
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
      duckdb$expr_set_alias(tmp_expr, "revenue")
      tmp_expr
    }
  )
)
"summarise"
rel15 <- duckdb$rel_distinct(rel14)
rel15
duckdb$rel_to_altrep(rel15)
