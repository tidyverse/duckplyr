qloadm("tools/tpch/001.qs")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"___coalesce\"(a, b) AS COALESCE(a, b)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"|\"(x, y) AS (x OR y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"&\"(x, y) AS (x AND y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(a, b) AS a <= b"))
df1 <- lineitem
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_set_alias(rel1, "lhs")
df2 <- part
rel3 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel4 <- duckdb:::rel_set_alias(rel3, "rhs")
rel5 <- duckdb:::rel_join(
  rel2,
  rel4,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_partkey", rel2), duckdb:::expr_reference("p_partkey", rel4))
    )
  ),
  "inner"
)
rel6 <- duckdb:::rel_project(
  rel5,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "___coalesce",
        list(duckdb:::expr_reference("l_partkey", rel2), duckdb:::expr_reference("p_partkey", rel4))
      )
      duckdb:::expr_set_alias(tmp_expr, "l_partkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linenumber")
      duckdb:::expr_set_alias(tmp_expr, "l_linenumber")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_quantity")
      duckdb:::expr_set_alias(tmp_expr, "l_quantity")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_tax")
      duckdb:::expr_set_alias(tmp_expr, "l_tax")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_returnflag")
      duckdb:::expr_set_alias(tmp_expr, "l_returnflag")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_linestatus")
      duckdb:::expr_set_alias(tmp_expr, "l_linestatus")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
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
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipinstruct")
      duckdb:::expr_set_alias(tmp_expr, "l_shipinstruct")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipmode")
      duckdb:::expr_set_alias(tmp_expr, "l_shipmode")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_comment")
      duckdb:::expr_set_alias(tmp_expr, "l_comment")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_name")
      duckdb:::expr_set_alias(tmp_expr, "p_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_mfgr")
      duckdb:::expr_set_alias(tmp_expr, "p_mfgr")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_brand")
      duckdb:::expr_set_alias(tmp_expr, "p_brand")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_type")
      duckdb:::expr_set_alias(tmp_expr, "p_type")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_size")
      duckdb:::expr_set_alias(tmp_expr, "p_size")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_container")
      duckdb:::expr_set_alias(tmp_expr, "p_container")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_retailprice")
      duckdb:::expr_set_alias(tmp_expr, "p_retailprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("p_comment")
      duckdb:::expr_set_alias(tmp_expr, "p_comment")
      tmp_expr
    }
  )
)
rel7 <- duckdb:::rel_filter(
  rel6,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "|",
          list(
            duckdb:::expr_function(
              "&",
              list(
                duckdb:::expr_function(
                  "&",
                  list(
                    duckdb:::expr_function(
                      "&",
                      list(
                        duckdb:::expr_function(
                          "&",
                          list(
                            duckdb:::expr_function(
                              "&",
                              list(
                                duckdb:::expr_function(
                                  "&",
                                  list(
                                    duckdb:::expr_function(
                                      "&",
                                      list(
                                        duckdb:::expr_function(
                                          "==",
                                          list(
                                            duckdb:::expr_reference("p_brand"),
                                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                              duckdb:::expr_constant("Brand#12", experimental = experimental)
                                            } else {
                                              duckdb:::expr_constant("Brand#12")
                                            }
                                          )
                                        ),
                                        duckdb:::expr_function(
                                          "|",
                                          list(
                                            duckdb:::expr_function(
                                              "|",
                                              list(
                                                duckdb:::expr_function(
                                                  "|",
                                                  list(
                                                    duckdb:::expr_function(
                                                      "==",
                                                      list(
                                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                          duckdb:::expr_constant("SM CASE", experimental = experimental)
                                                        } else {
                                                          duckdb:::expr_constant("SM CASE")
                                                        },
                                                        duckdb:::expr_reference("p_container")
                                                      )
                                                    ),
                                                    duckdb:::expr_function(
                                                      "==",
                                                      list(
                                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                          duckdb:::expr_constant("SM BOX", experimental = experimental)
                                                        } else {
                                                          duckdb:::expr_constant("SM BOX")
                                                        },
                                                        duckdb:::expr_reference("p_container")
                                                      )
                                                    )
                                                  )
                                                ),
                                                duckdb:::expr_function(
                                                  "==",
                                                  list(
                                                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                      duckdb:::expr_constant("SM PACK", experimental = experimental)
                                                    } else {
                                                      duckdb:::expr_constant("SM PACK")
                                                    },
                                                    duckdb:::expr_reference("p_container")
                                                  )
                                                )
                                              )
                                            ),
                                            duckdb:::expr_function(
                                              "==",
                                              list(
                                                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                  duckdb:::expr_constant("SM PKG", experimental = experimental)
                                                } else {
                                                  duckdb:::expr_constant("SM PKG")
                                                },
                                                duckdb:::expr_reference("p_container")
                                              )
                                            )
                                          )
                                        )
                                      )
                                    ),
                                    duckdb:::expr_function(
                                      ">=",
                                      list(
                                        duckdb:::expr_reference("l_quantity"),
                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                          duckdb:::expr_constant(1, experimental = experimental)
                                        } else {
                                          duckdb:::expr_constant(1)
                                        }
                                      )
                                    )
                                  )
                                ),
                                duckdb:::expr_function(
                                  "<=",
                                  list(
                                    duckdb:::expr_reference("l_quantity"),
                                    duckdb:::expr_function(
                                      "+",
                                      list(
                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                          duckdb:::expr_constant(1, experimental = experimental)
                                        } else {
                                          duckdb:::expr_constant(1)
                                        },
                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                          duckdb:::expr_constant(10, experimental = experimental)
                                        } else {
                                          duckdb:::expr_constant(10)
                                        }
                                      )
                                    )
                                  )
                                )
                              )
                            ),
                            duckdb:::expr_function(
                              ">=",
                              list(
                                duckdb:::expr_reference("p_size"),
                                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                  duckdb:::expr_constant(1, experimental = experimental)
                                } else {
                                  duckdb:::expr_constant(1)
                                }
                              )
                            )
                          )
                        ),
                        duckdb:::expr_function(
                          "<=",
                          list(
                            duckdb:::expr_reference("p_size"),
                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                              duckdb:::expr_constant(5, experimental = experimental)
                            } else {
                              duckdb:::expr_constant(5)
                            }
                          )
                        )
                      )
                    ),
                    duckdb:::expr_function(
                      "|",
                      list(
                        duckdb:::expr_function(
                          "==",
                          list(
                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                              duckdb:::expr_constant("AIR", experimental = experimental)
                            } else {
                              duckdb:::expr_constant("AIR")
                            },
                            duckdb:::expr_reference("l_shipmode")
                          )
                        ),
                        duckdb:::expr_function(
                          "==",
                          list(
                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                              duckdb:::expr_constant("AIR REG", experimental = experimental)
                            } else {
                              duckdb:::expr_constant("AIR REG")
                            },
                            duckdb:::expr_reference("l_shipmode")
                          )
                        )
                      )
                    )
                  )
                ),
                duckdb:::expr_function(
                  "==",
                  list(
                    duckdb:::expr_reference("l_shipinstruct"),
                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                      duckdb:::expr_constant("DELIVER IN PERSON", experimental = experimental)
                    } else {
                      duckdb:::expr_constant("DELIVER IN PERSON")
                    }
                  )
                )
              )
            ),
            duckdb:::expr_function(
              "&",
              list(
                duckdb:::expr_function(
                  "&",
                  list(
                    duckdb:::expr_function(
                      "&",
                      list(
                        duckdb:::expr_function(
                          "&",
                          list(
                            duckdb:::expr_function(
                              "&",
                              list(
                                duckdb:::expr_function(
                                  "&",
                                  list(
                                    duckdb:::expr_function(
                                      "&",
                                      list(
                                        duckdb:::expr_function(
                                          "==",
                                          list(
                                            duckdb:::expr_reference("p_brand"),
                                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                              duckdb:::expr_constant("Brand#23", experimental = experimental)
                                            } else {
                                              duckdb:::expr_constant("Brand#23")
                                            }
                                          )
                                        ),
                                        duckdb:::expr_function(
                                          "|",
                                          list(
                                            duckdb:::expr_function(
                                              "|",
                                              list(
                                                duckdb:::expr_function(
                                                  "|",
                                                  list(
                                                    duckdb:::expr_function(
                                                      "==",
                                                      list(
                                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                          duckdb:::expr_constant("MED BAG", experimental = experimental)
                                                        } else {
                                                          duckdb:::expr_constant("MED BAG")
                                                        },
                                                        duckdb:::expr_reference("p_container")
                                                      )
                                                    ),
                                                    duckdb:::expr_function(
                                                      "==",
                                                      list(
                                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                          duckdb:::expr_constant("MED BOX", experimental = experimental)
                                                        } else {
                                                          duckdb:::expr_constant("MED BOX")
                                                        },
                                                        duckdb:::expr_reference("p_container")
                                                      )
                                                    )
                                                  )
                                                ),
                                                duckdb:::expr_function(
                                                  "==",
                                                  list(
                                                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                      duckdb:::expr_constant("MED PKG", experimental = experimental)
                                                    } else {
                                                      duckdb:::expr_constant("MED PKG")
                                                    },
                                                    duckdb:::expr_reference("p_container")
                                                  )
                                                )
                                              )
                                            ),
                                            duckdb:::expr_function(
                                              "==",
                                              list(
                                                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                  duckdb:::expr_constant("MED PACK", experimental = experimental)
                                                } else {
                                                  duckdb:::expr_constant("MED PACK")
                                                },
                                                duckdb:::expr_reference("p_container")
                                              )
                                            )
                                          )
                                        )
                                      )
                                    ),
                                    duckdb:::expr_function(
                                      ">=",
                                      list(
                                        duckdb:::expr_reference("l_quantity"),
                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                          duckdb:::expr_constant(10, experimental = experimental)
                                        } else {
                                          duckdb:::expr_constant(10)
                                        }
                                      )
                                    )
                                  )
                                ),
                                duckdb:::expr_function(
                                  "<=",
                                  list(
                                    duckdb:::expr_reference("l_quantity"),
                                    duckdb:::expr_function(
                                      "+",
                                      list(
                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                          duckdb:::expr_constant(10, experimental = experimental)
                                        } else {
                                          duckdb:::expr_constant(10)
                                        },
                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                          duckdb:::expr_constant(10, experimental = experimental)
                                        } else {
                                          duckdb:::expr_constant(10)
                                        }
                                      )
                                    )
                                  )
                                )
                              )
                            ),
                            duckdb:::expr_function(
                              ">=",
                              list(
                                duckdb:::expr_reference("p_size"),
                                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                  duckdb:::expr_constant(1, experimental = experimental)
                                } else {
                                  duckdb:::expr_constant(1)
                                }
                              )
                            )
                          )
                        ),
                        duckdb:::expr_function(
                          "<=",
                          list(
                            duckdb:::expr_reference("p_size"),
                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                              duckdb:::expr_constant(10, experimental = experimental)
                            } else {
                              duckdb:::expr_constant(10)
                            }
                          )
                        )
                      )
                    ),
                    duckdb:::expr_function(
                      "|",
                      list(
                        duckdb:::expr_function(
                          "==",
                          list(
                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                              duckdb:::expr_constant("AIR", experimental = experimental)
                            } else {
                              duckdb:::expr_constant("AIR")
                            },
                            duckdb:::expr_reference("l_shipmode")
                          )
                        ),
                        duckdb:::expr_function(
                          "==",
                          list(
                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                              duckdb:::expr_constant("AIR REG", experimental = experimental)
                            } else {
                              duckdb:::expr_constant("AIR REG")
                            },
                            duckdb:::expr_reference("l_shipmode")
                          )
                        )
                      )
                    )
                  )
                ),
                duckdb:::expr_function(
                  "==",
                  list(
                    duckdb:::expr_reference("l_shipinstruct"),
                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                      duckdb:::expr_constant("DELIVER IN PERSON", experimental = experimental)
                    } else {
                      duckdb:::expr_constant("DELIVER IN PERSON")
                    }
                  )
                )
              )
            )
          )
        ),
        duckdb:::expr_function(
          "&",
          list(
            duckdb:::expr_function(
              "&",
              list(
                duckdb:::expr_function(
                  "&",
                  list(
                    duckdb:::expr_function(
                      "&",
                      list(
                        duckdb:::expr_function(
                          "&",
                          list(
                            duckdb:::expr_function(
                              "&",
                              list(
                                duckdb:::expr_function(
                                  "&",
                                  list(
                                    duckdb:::expr_function(
                                      "==",
                                      list(
                                        duckdb:::expr_reference("p_brand"),
                                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                          duckdb:::expr_constant("Brand#34", experimental = experimental)
                                        } else {
                                          duckdb:::expr_constant("Brand#34")
                                        }
                                      )
                                    ),
                                    duckdb:::expr_function(
                                      "|",
                                      list(
                                        duckdb:::expr_function(
                                          "|",
                                          list(
                                            duckdb:::expr_function(
                                              "|",
                                              list(
                                                duckdb:::expr_function(
                                                  "==",
                                                  list(
                                                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                      duckdb:::expr_constant("LG CASE", experimental = experimental)
                                                    } else {
                                                      duckdb:::expr_constant("LG CASE")
                                                    },
                                                    duckdb:::expr_reference("p_container")
                                                  )
                                                ),
                                                duckdb:::expr_function(
                                                  "==",
                                                  list(
                                                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                      duckdb:::expr_constant("LG BOX", experimental = experimental)
                                                    } else {
                                                      duckdb:::expr_constant("LG BOX")
                                                    },
                                                    duckdb:::expr_reference("p_container")
                                                  )
                                                )
                                              )
                                            ),
                                            duckdb:::expr_function(
                                              "==",
                                              list(
                                                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                                  duckdb:::expr_constant("LG PACK", experimental = experimental)
                                                } else {
                                                  duckdb:::expr_constant("LG PACK")
                                                },
                                                duckdb:::expr_reference("p_container")
                                              )
                                            )
                                          )
                                        ),
                                        duckdb:::expr_function(
                                          "==",
                                          list(
                                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                              duckdb:::expr_constant("LG PKG", experimental = experimental)
                                            } else {
                                              duckdb:::expr_constant("LG PKG")
                                            },
                                            duckdb:::expr_reference("p_container")
                                          )
                                        )
                                      )
                                    )
                                  )
                                ),
                                duckdb:::expr_function(
                                  ">=",
                                  list(
                                    duckdb:::expr_reference("l_quantity"),
                                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                      duckdb:::expr_constant(20, experimental = experimental)
                                    } else {
                                      duckdb:::expr_constant(20)
                                    }
                                  )
                                )
                              )
                            ),
                            duckdb:::expr_function(
                              "<=",
                              list(
                                duckdb:::expr_reference("l_quantity"),
                                duckdb:::expr_function(
                                  "+",
                                  list(
                                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                      duckdb:::expr_constant(20, experimental = experimental)
                                    } else {
                                      duckdb:::expr_constant(20)
                                    },
                                    if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                                      duckdb:::expr_constant(10, experimental = experimental)
                                    } else {
                                      duckdb:::expr_constant(10)
                                    }
                                  )
                                )
                              )
                            )
                          )
                        ),
                        duckdb:::expr_function(
                          ">=",
                          list(
                            duckdb:::expr_reference("p_size"),
                            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                              duckdb:::expr_constant(1, experimental = experimental)
                            } else {
                              duckdb:::expr_constant(1)
                            }
                          )
                        )
                      )
                    ),
                    duckdb:::expr_function(
                      "<=",
                      list(
                        duckdb:::expr_reference("p_size"),
                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                          duckdb:::expr_constant(15, experimental = experimental)
                        } else {
                          duckdb:::expr_constant(15)
                        }
                      )
                    )
                  )
                ),
                duckdb:::expr_function(
                  "|",
                  list(
                    duckdb:::expr_function(
                      "==",
                      list(
                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                          duckdb:::expr_constant("AIR", experimental = experimental)
                        } else {
                          duckdb:::expr_constant("AIR")
                        },
                        duckdb:::expr_reference("l_shipmode")
                      )
                    ),
                    duckdb:::expr_function(
                      "==",
                      list(
                        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                          duckdb:::expr_constant("AIR REG", experimental = experimental)
                        } else {
                          duckdb:::expr_constant("AIR REG")
                        },
                        duckdb:::expr_reference("l_shipmode")
                      )
                    )
                  )
                )
              )
            ),
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("l_shipinstruct"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("DELIVER IN PERSON", experimental = experimental)
                } else {
                  duckdb:::expr_constant("DELIVER IN PERSON")
                }
              )
            )
          )
        )
      )
    )
  )
)
rel8 <- duckdb:::rel_aggregate(
  rel7,
  groups = list(),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function(
      "sum",
      list(
        duckdb:::expr_function(
          "*",
          list(
            duckdb:::expr_reference("l_extendedprice"),
            duckdb:::expr_function(
              "-",
              list(
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant(1, experimental = experimental)
                } else {
                  duckdb:::expr_constant(1)
                },
                duckdb:::expr_reference("l_discount")
              )
            )
          )
        )
      )
    )
    duckdb:::expr_set_alias(tmp_expr, "revenue")
    tmp_expr
  })
)
rel9 <- duckdb:::rel_distinct(rel8)
rel9
duckdb:::rel_to_altrep(rel9)
