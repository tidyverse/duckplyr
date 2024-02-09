qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"&\"(x, y) AS (x AND y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"|\"(x, y) AS (x OR y)"))
invisible(
  DBI::dbExecute(con, "INSTALL 'rfuns' FROM 'http://duckdb-rfuns.s3.us-east-1.amazonaws.com'")
)
invisible(DBI::dbExecute(con, "LOAD 'rfuns'"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(x, y) AS \"r_base::==\"(x, y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">\"(x, y) AS x > y"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(x, y) AS COALESCE(x, y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"n\"() AS CAST(COUNT(*) AS int32)"))
df1 <- customer
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb$rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
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
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel3 <- duckdb$rel_filter(
  rel2,
  list(
    duckdb$expr_function(
      "&",
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
                    duckdb$expr_function(
                      "|",
                      list(
                        duckdb$expr_function(
                          "|",
                          list(
                            duckdb$expr_function(
                              "|",
                              list(
                                duckdb$expr_function(
                                  "==",
                                  list(
                                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                      duckdb$expr_constant("13", experimental = experimental)
                                    } else {
                                      duckdb$expr_constant("13")
                                    },
                                    duckdb$expr_function(
                                      "substr",
                                      list(
                                        duckdb$expr_reference("c_phone"),
                                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                          duckdb$expr_constant(1L, experimental = experimental)
                                        } else {
                                          duckdb$expr_constant(1L)
                                        },
                                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                          duckdb$expr_constant(2L, experimental = experimental)
                                        } else {
                                          duckdb$expr_constant(2L)
                                        }
                                      )
                                    )
                                  )
                                ),
                                duckdb$expr_function(
                                  "==",
                                  list(
                                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                      duckdb$expr_constant("31", experimental = experimental)
                                    } else {
                                      duckdb$expr_constant("31")
                                    },
                                    duckdb$expr_function(
                                      "substr",
                                      list(
                                        duckdb$expr_reference("c_phone"),
                                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                          duckdb$expr_constant(1L, experimental = experimental)
                                        } else {
                                          duckdb$expr_constant(1L)
                                        },
                                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                          duckdb$expr_constant(2L, experimental = experimental)
                                        } else {
                                          duckdb$expr_constant(2L)
                                        }
                                      )
                                    )
                                  )
                                )
                              )
                            ),
                            duckdb$expr_function(
                              "==",
                              list(
                                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                  duckdb$expr_constant("23", experimental = experimental)
                                } else {
                                  duckdb$expr_constant("23")
                                },
                                duckdb$expr_function(
                                  "substr",
                                  list(
                                    duckdb$expr_reference("c_phone"),
                                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                      duckdb$expr_constant(1L, experimental = experimental)
                                    } else {
                                      duckdb$expr_constant(1L)
                                    },
                                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                      duckdb$expr_constant(2L, experimental = experimental)
                                    } else {
                                      duckdb$expr_constant(2L)
                                    }
                                  )
                                )
                              )
                            )
                          )
                        ),
                        duckdb$expr_function(
                          "==",
                          list(
                            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                              duckdb$expr_constant("29", experimental = experimental)
                            } else {
                              duckdb$expr_constant("29")
                            },
                            duckdb$expr_function(
                              "substr",
                              list(
                                duckdb$expr_reference("c_phone"),
                                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                  duckdb$expr_constant(1L, experimental = experimental)
                                } else {
                                  duckdb$expr_constant(1L)
                                },
                                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                  duckdb$expr_constant(2L, experimental = experimental)
                                } else {
                                  duckdb$expr_constant(2L)
                                }
                              )
                            )
                          )
                        )
                      )
                    ),
                    duckdb$expr_function(
                      "==",
                      list(
                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                          duckdb$expr_constant("30", experimental = experimental)
                        } else {
                          duckdb$expr_constant("30")
                        },
                        duckdb$expr_function(
                          "substr",
                          list(
                            duckdb$expr_reference("c_phone"),
                            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                              duckdb$expr_constant(1L, experimental = experimental)
                            } else {
                              duckdb$expr_constant(1L)
                            },
                            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                              duckdb$expr_constant(2L, experimental = experimental)
                            } else {
                              duckdb$expr_constant(2L)
                            }
                          )
                        )
                      )
                    )
                  )
                ),
                duckdb$expr_function(
                  "==",
                  list(
                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                      duckdb$expr_constant("18", experimental = experimental)
                    } else {
                      duckdb$expr_constant("18")
                    },
                    duckdb$expr_function(
                      "substr",
                      list(
                        duckdb$expr_reference("c_phone"),
                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                          duckdb$expr_constant(1L, experimental = experimental)
                        } else {
                          duckdb$expr_constant(1L)
                        },
                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                          duckdb$expr_constant(2L, experimental = experimental)
                        } else {
                          duckdb$expr_constant(2L)
                        }
                      )
                    )
                  )
                )
              )
            ),
            duckdb$expr_function(
              "==",
              list(
                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                  duckdb$expr_constant("17", experimental = experimental)
                } else {
                  duckdb$expr_constant("17")
                },
                duckdb$expr_function(
                  "substr",
                  list(
                    duckdb$expr_reference("c_phone"),
                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                      duckdb$expr_constant(1L, experimental = experimental)
                    } else {
                      duckdb$expr_constant(1L)
                    },
                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                      duckdb$expr_constant(2L, experimental = experimental)
                    } else {
                      duckdb$expr_constant(2L)
                    }
                  )
                )
              )
            )
          )
        ),
        duckdb$expr_function(
          ">",
          list(
            duckdb$expr_reference("c_acctbal"),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant(0, experimental = experimental)
            } else {
              duckdb$expr_constant(0)
            }
          )
        )
      )
    )
  )
)
rel4 <- duckdb$rel_order(rel3, list(duckdb$expr_reference("___row_number")))
rel5 <- duckdb$rel_project(
  rel4,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
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
    }
  )
)
rel6 <- duckdb$rel_aggregate(
  rel5,
  groups = list(),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("mean", list(duckdb$expr_reference("c_acctbal")))
      duckdb$expr_set_alias(tmp_expr, "acctbal_min")
      tmp_expr
    },
    {
      tmp_expr <- if ("experimental" %in% names(formals(duckdb$expr_constant))) {
        duckdb$expr_constant(1L, experimental = experimental)
      } else {
        duckdb$expr_constant(1L)
      }
      duckdb$expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    }
  )
)
rel7 <- duckdb$rel_distinct(rel6)
rel8 <- duckdb$rel_from_df(con, df1, experimental = experimental)
rel9 <- duckdb$rel_project(
  rel8,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
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
      tmp_expr <- duckdb$expr_function(
        "substr",
        list(
          duckdb$expr_reference("c_phone"),
          if ("experimental" %in% names(formals(duckdb$expr_constant))) {
            duckdb$expr_constant(1L, experimental = experimental)
          } else {
            duckdb$expr_constant(1L)
          },
          if ("experimental" %in% names(formals(duckdb$expr_constant))) {
            duckdb$expr_constant(2L, experimental = experimental)
          } else {
            duckdb$expr_constant(2L)
          }
        )
      )
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    }
  )
)
rel10 <- duckdb$rel_project(
  rel9,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
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
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- if ("experimental" %in% names(formals(duckdb$expr_constant))) {
        duckdb$expr_constant(1L, experimental = experimental)
      } else {
        duckdb$expr_constant(1L)
      }
      duckdb$expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    }
  )
)
rel11 <- duckdb$rel_set_alias(rel10, "lhs")
rel12 <- duckdb$rel_set_alias(rel7, "rhs")
rel13 <- duckdb$rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
      duckdb$expr_set_alias(tmp_expr, "c_custkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name")
      duckdb$expr_set_alias(tmp_expr, "c_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address")
      duckdb$expr_set_alias(tmp_expr, "c_address_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_nationkey")
      duckdb$expr_set_alias(tmp_expr, "c_nationkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone")
      duckdb$expr_set_alias(tmp_expr, "c_phone_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_mktsegment")
      duckdb$expr_set_alias(tmp_expr, "c_mktsegment_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment")
      duckdb$expr_set_alias(tmp_expr, "c_comment_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("join_id")
      duckdb$expr_set_alias(tmp_expr, "join_id_x")
      tmp_expr
    }
  )
)
rel14 <- duckdb$rel_project(
  rel12,
  list(
    {
      tmp_expr <- duckdb$expr_reference("acctbal_min")
      duckdb$expr_set_alias(tmp_expr, "acctbal_min_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("join_id")
      duckdb$expr_set_alias(tmp_expr, "join_id_y")
      tmp_expr
    }
  )
)
rel15 <- duckdb$rel_project(
  rel13,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey_x")
      duckdb$expr_set_alias(tmp_expr, "c_custkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name_x")
      duckdb$expr_set_alias(tmp_expr, "c_name_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address_x")
      duckdb$expr_set_alias(tmp_expr, "c_address_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_nationkey_x")
      duckdb$expr_set_alias(tmp_expr, "c_nationkey_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone_x")
      duckdb$expr_set_alias(tmp_expr, "c_phone_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal_x")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_mktsegment_x")
      duckdb$expr_set_alias(tmp_expr, "c_mktsegment_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment_x")
      duckdb$expr_set_alias(tmp_expr, "c_comment_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cntrycode_x")
      duckdb$expr_set_alias(tmp_expr, "cntrycode_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("join_id_x")
      duckdb$expr_set_alias(tmp_expr, "join_id_x")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel16 <- duckdb$rel_project(
  rel14,
  list(
    {
      tmp_expr <- duckdb$expr_reference("acctbal_min_y")
      duckdb$expr_set_alias(tmp_expr, "acctbal_min_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("join_id_y")
      duckdb$expr_set_alias(tmp_expr, "join_id_y")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel17 <- duckdb$rel_join(
  rel15,
  rel16,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("join_id_x", rel15), duckdb$expr_reference("join_id_y", rel16))
    )
  ),
  "left"
)
rel18 <- duckdb$rel_order(
  rel17,
  list(duckdb$expr_reference("___row_number_x", rel15), duckdb$expr_reference("___row_number_y", rel16))
)
rel19 <- duckdb$rel_project(
  rel18,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey_x")
      duckdb$expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_name_x")
      duckdb$expr_set_alias(tmp_expr, "c_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_address_x")
      duckdb$expr_set_alias(tmp_expr, "c_address")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_nationkey_x")
      duckdb$expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_phone_x")
      duckdb$expr_set_alias(tmp_expr, "c_phone")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal_x")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_mktsegment_x")
      duckdb$expr_set_alias(tmp_expr, "c_mktsegment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_comment_x")
      duckdb$expr_set_alias(tmp_expr, "c_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("cntrycode_x")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function(
        "___coalesce",
        list(duckdb$expr_reference("join_id_x", rel15), duckdb$expr_reference("join_id_y", rel16))
      )
      duckdb$expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("acctbal_min_y")
      duckdb$expr_set_alias(tmp_expr, "acctbal_min")
      tmp_expr
    }
  )
)
rel20 <- duckdb$rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
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
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("join_id")
      duckdb$expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("acctbal_min")
      duckdb$expr_set_alias(tmp_expr, "acctbal_min")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel21 <- duckdb$rel_filter(
  rel20,
  list(
    duckdb$expr_function(
      "&",
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
                    duckdb$expr_function(
                      "|",
                      list(
                        duckdb$expr_function(
                          "|",
                          list(
                            duckdb$expr_function(
                              "|",
                              list(
                                duckdb$expr_function(
                                  "==",
                                  list(
                                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                      duckdb$expr_constant("13", experimental = experimental)
                                    } else {
                                      duckdb$expr_constant("13")
                                    },
                                    duckdb$expr_reference("cntrycode")
                                  )
                                ),
                                duckdb$expr_function(
                                  "==",
                                  list(
                                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                      duckdb$expr_constant("31", experimental = experimental)
                                    } else {
                                      duckdb$expr_constant("31")
                                    },
                                    duckdb$expr_reference("cntrycode")
                                  )
                                )
                              )
                            ),
                            duckdb$expr_function(
                              "==",
                              list(
                                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                  duckdb$expr_constant("23", experimental = experimental)
                                } else {
                                  duckdb$expr_constant("23")
                                },
                                duckdb$expr_reference("cntrycode")
                              )
                            )
                          )
                        ),
                        duckdb$expr_function(
                          "==",
                          list(
                            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                              duckdb$expr_constant("29", experimental = experimental)
                            } else {
                              duckdb$expr_constant("29")
                            },
                            duckdb$expr_reference("cntrycode")
                          )
                        )
                      )
                    ),
                    duckdb$expr_function(
                      "==",
                      list(
                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                          duckdb$expr_constant("30", experimental = experimental)
                        } else {
                          duckdb$expr_constant("30")
                        },
                        duckdb$expr_reference("cntrycode")
                      )
                    )
                  )
                ),
                duckdb$expr_function(
                  "==",
                  list(
                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                      duckdb$expr_constant("18", experimental = experimental)
                    } else {
                      duckdb$expr_constant("18")
                    },
                    duckdb$expr_reference("cntrycode")
                  )
                )
              )
            ),
            duckdb$expr_function(
              "==",
              list(
                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                  duckdb$expr_constant("17", experimental = experimental)
                } else {
                  duckdb$expr_constant("17")
                },
                duckdb$expr_reference("cntrycode")
              )
            )
          )
        ),
        duckdb$expr_function(">", list(duckdb$expr_reference("c_acctbal"), duckdb$expr_reference("acctbal_min")))
      )
    )
  )
)
rel22 <- duckdb$rel_order(rel21, list(duckdb$expr_reference("___row_number")))
rel23 <- duckdb$rel_project(
  rel22,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
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
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("join_id")
      duckdb$expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("acctbal_min")
      duckdb$expr_set_alias(tmp_expr, "acctbal_min")
      tmp_expr
    }
  )
)
rel24 <- duckdb$rel_set_alias(rel23, "lhs")
df2 <- orders
rel25 <- duckdb$rel_from_df(con, df2, experimental = experimental)
rel26 <- duckdb$rel_set_alias(rel25, "rhs")
rel27 <- duckdb$rel_project(
  rel24,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
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
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("join_id")
      duckdb$expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("acctbal_min")
      duckdb$expr_set_alias(tmp_expr, "acctbal_min")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel28 <- duckdb$rel_join(
  rel27,
  rel26,
  list(
    duckdb$expr_function(
      "==",
      list(duckdb$expr_reference("c_custkey", rel27), duckdb$expr_reference("o_custkey", rel26))
    )
  ),
  "anti"
)
rel29 <- duckdb$rel_order(rel28, list(duckdb$expr_reference("___row_number_x", rel27)))
rel30 <- duckdb$rel_project(
  rel29,
  list(
    {
      tmp_expr <- duckdb$expr_reference("c_custkey")
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
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("join_id")
      duckdb$expr_set_alias(tmp_expr, "join_id")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("acctbal_min")
      duckdb$expr_set_alias(tmp_expr, "acctbal_min")
      tmp_expr
    }
  )
)
rel31 <- duckdb$rel_project(
  rel30,
  list(
    {
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    }
  )
)
rel32 <- duckdb$rel_project(
  rel31,
  list(
    {
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("c_acctbal")
      duckdb$expr_set_alias(tmp_expr, "c_acctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel33 <- duckdb$rel_aggregate(
  rel32,
  groups = list(duckdb$expr_reference("cntrycode")),
  aggregates = list(
    {
      tmp_expr <- duckdb$expr_function("min", list(duckdb$expr_reference("___row_number")))
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("n", list())
      duckdb$expr_set_alias(tmp_expr, "numcust")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_function("sum", list(duckdb$expr_reference("c_acctbal")))
      duckdb$expr_set_alias(tmp_expr, "totacctbal")
      tmp_expr
    }
  )
)
rel34 <- duckdb$rel_order(rel33, list(duckdb$expr_reference("___row_number")))
rel35 <- duckdb$rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("numcust")
      duckdb$expr_set_alias(tmp_expr, "numcust")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("totacctbal")
      duckdb$expr_set_alias(tmp_expr, "totacctbal")
      tmp_expr
    }
  )
)
rel36 <- duckdb$rel_project(
  rel35,
  list(
    {
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("numcust")
      duckdb$expr_set_alias(tmp_expr, "numcust")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("totacctbal")
      duckdb$expr_set_alias(tmp_expr, "totacctbal")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_window(duckdb$expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb$expr_set_alias(tmp_expr, "___row_number")
      tmp_expr
    }
  )
)
rel37 <- duckdb$rel_order(
  rel36,
  list(duckdb$expr_reference("cntrycode"), duckdb$expr_reference("___row_number"))
)
rel38 <- duckdb$rel_project(
  rel37,
  list(
    {
      tmp_expr <- duckdb$expr_reference("cntrycode")
      duckdb$expr_set_alias(tmp_expr, "cntrycode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("numcust")
      duckdb$expr_set_alias(tmp_expr, "numcust")
      tmp_expr
    },
    {
      tmp_expr <- duckdb$expr_reference("totacctbal")
      duckdb$expr_set_alias(tmp_expr, "totacctbal")
      tmp_expr
    }
  )
)
rel38
duckdb$rel_to_altrep(rel38)
