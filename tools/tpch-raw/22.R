qloadm("tools/tpch/001.qs")
duckdb <- asNamespace("duckdb")
drv <- duckdb::duckdb()
con <- DBI::dbConnect(drv)
experimental <- FALSE
invisible(duckdb$rapi_load_rfuns(drv@database_ref))
invisible(DBI::dbExecute(con, 'CREATE MACRO "&"(x, y) AS (x AND y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "___coalesce"(x, y) AS COALESCE(x, y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "|"(x, y) AS (x OR y)'))
invisible(DBI::dbExecute(con, 'CREATE MACRO "n"() AS CAST(COUNT(*) AS int32)'))
df1 <- customer
"filter"
rel1 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"filter"
rel2 <- duckdb$rel_filter(
  rel1,
  list(
    duckdb$expr_function(
      "&",
      list(
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
                                      "r_base::==",
                                      list(
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
                                        ),
                                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                          duckdb$expr_constant("13", experimental = experimental)
                                        } else {
                                          duckdb$expr_constant("13")
                                        }
                                      )
                                    ),
                                    duckdb$expr_function(
                                      "r_base::==",
                                      list(
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
                                        ),
                                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                          duckdb$expr_constant("31", experimental = experimental)
                                        } else {
                                          duckdb$expr_constant("31")
                                        }
                                      )
                                    )
                                  )
                                ),
                                duckdb$expr_function(
                                  "r_base::==",
                                  list(
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
                                    ),
                                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                      duckdb$expr_constant("23", experimental = experimental)
                                    } else {
                                      duckdb$expr_constant("23")
                                    }
                                  )
                                )
                              )
                            ),
                            duckdb$expr_function(
                              "r_base::==",
                              list(
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
                                ),
                                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                  duckdb$expr_constant("29", experimental = experimental)
                                } else {
                                  duckdb$expr_constant("29")
                                }
                              )
                            )
                          )
                        ),
                        duckdb$expr_function(
                          "r_base::==",
                          list(
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
                            ),
                            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                              duckdb$expr_constant("30", experimental = experimental)
                            } else {
                              duckdb$expr_constant("30")
                            }
                          )
                        )
                      )
                    ),
                    duckdb$expr_function(
                      "r_base::==",
                      list(
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
                        ),
                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                          duckdb$expr_constant("18", experimental = experimental)
                        } else {
                          duckdb$expr_constant("18")
                        }
                      )
                    )
                  )
                ),
                duckdb$expr_function(
                  "r_base::==",
                  list(
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
                    ),
                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                      duckdb$expr_constant("17", experimental = experimental)
                    } else {
                      duckdb$expr_constant("17")
                    }
                  )
                )
              )
            ),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant(FALSE, experimental = experimental)
            } else {
              duckdb$expr_constant(FALSE)
            }
          )
        ),
        duckdb$expr_comparison(
          cmp_op = ">",
          exprs = list(
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
"summarise"
rel3 <- duckdb$rel_aggregate(
  rel2,
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
"summarise"
rel4 <- duckdb$rel_distinct(rel3)
"mutate"
rel5 <- duckdb$rel_from_df(con, df1, experimental = experimental)
"mutate"
rel6 <- duckdb$rel_project(
  rel5,
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
"mutate"
rel7 <- duckdb$rel_project(
  rel6,
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
"left_join"
rel8 <- duckdb$rel_set_alias(rel7, "lhs")
"left_join"
rel9 <- duckdb$rel_set_alias(rel4, "rhs")
"left_join"
rel10 <- duckdb$rel_project(
  rel8,
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
"left_join"
rel11 <- duckdb$rel_project(
  rel9,
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
"left_join"
rel12 <- duckdb$rel_join(
  rel10,
  rel11,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("join_id_x", rel10), duckdb$expr_reference("join_id_y", rel11))
    )
  ),
  "left"
)
"left_join"
rel13 <- duckdb$rel_project(
  rel12,
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
        list(duckdb$expr_reference("join_id_x", rel10), duckdb$expr_reference("join_id_y", rel11))
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
"filter"
rel14 <- duckdb$rel_filter(
  rel13,
  list(
    duckdb$expr_function(
      "&",
      list(
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
                                      "r_base::==",
                                      list(
                                        duckdb$expr_reference("cntrycode"),
                                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                          duckdb$expr_constant("13", experimental = experimental)
                                        } else {
                                          duckdb$expr_constant("13")
                                        }
                                      )
                                    ),
                                    duckdb$expr_function(
                                      "r_base::==",
                                      list(
                                        duckdb$expr_reference("cntrycode"),
                                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                          duckdb$expr_constant("31", experimental = experimental)
                                        } else {
                                          duckdb$expr_constant("31")
                                        }
                                      )
                                    )
                                  )
                                ),
                                duckdb$expr_function(
                                  "r_base::==",
                                  list(
                                    duckdb$expr_reference("cntrycode"),
                                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                      duckdb$expr_constant("23", experimental = experimental)
                                    } else {
                                      duckdb$expr_constant("23")
                                    }
                                  )
                                )
                              )
                            ),
                            duckdb$expr_function(
                              "r_base::==",
                              list(
                                duckdb$expr_reference("cntrycode"),
                                if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                                  duckdb$expr_constant("29", experimental = experimental)
                                } else {
                                  duckdb$expr_constant("29")
                                }
                              )
                            )
                          )
                        ),
                        duckdb$expr_function(
                          "r_base::==",
                          list(
                            duckdb$expr_reference("cntrycode"),
                            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                              duckdb$expr_constant("30", experimental = experimental)
                            } else {
                              duckdb$expr_constant("30")
                            }
                          )
                        )
                      )
                    ),
                    duckdb$expr_function(
                      "r_base::==",
                      list(
                        duckdb$expr_reference("cntrycode"),
                        if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                          duckdb$expr_constant("18", experimental = experimental)
                        } else {
                          duckdb$expr_constant("18")
                        }
                      )
                    )
                  )
                ),
                duckdb$expr_function(
                  "r_base::==",
                  list(
                    duckdb$expr_reference("cntrycode"),
                    if ("experimental" %in% names(formals(duckdb$expr_constant))) {
                      duckdb$expr_constant("17", experimental = experimental)
                    } else {
                      duckdb$expr_constant("17")
                    }
                  )
                )
              )
            ),
            if ("experimental" %in% names(formals(duckdb$expr_constant))) {
              duckdb$expr_constant(FALSE, experimental = experimental)
            } else {
              duckdb$expr_constant(FALSE)
            }
          )
        ),
        duckdb$expr_comparison(
          cmp_op = ">",
          exprs = list(duckdb$expr_reference("c_acctbal"), duckdb$expr_reference("acctbal_min"))
        )
      )
    )
  )
)
"anti_join"
rel15 <- duckdb$rel_set_alias(rel14, "lhs")
df2 <- orders
"anti_join"
rel16 <- duckdb$rel_from_df(con, df2, experimental = experimental)
"anti_join"
rel17 <- duckdb$rel_set_alias(rel16, "rhs")
"anti_join"
rel18 <- duckdb$rel_join(
  rel15,
  rel17,
  list(
    duckdb$expr_comparison(
      "==",
      list(duckdb$expr_reference("c_custkey", rel15), duckdb$expr_reference("o_custkey", rel17))
    )
  ),
  "anti"
)
"select"
rel19 <- duckdb$rel_project(
  rel18,
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
"summarise"
rel20 <- duckdb$rel_aggregate(
  rel19,
  groups = list(duckdb$expr_reference("cntrycode")),
  aggregates = list(
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
"arrange"
rel21 <- duckdb$rel_order(rel20, list(duckdb$expr_reference("cntrycode")))
rel21
duckdb$rel_to_altrep(rel21)
