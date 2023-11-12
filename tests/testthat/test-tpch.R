test_that("TPCH queries can be parsed and run", {
  customer <- tibble::tibble(
    c_custkey = integer(0),
    c_name = character(0),
    c_address = character(0),
    c_nationkey = integer(0),
    c_phone = character(0),
    c_acctbal = numeric(0),
    c_mktsegment = character(0),
    c_comment = character(0),
  ) %>%
    as_duckplyr_df()

  lineitem <- tibble::tibble(
    l_orderkey = integer(0),
    l_partkey = integer(0),
    l_suppkey = integer(0),
    l_linenumber = integer(0),
    l_quantity = numeric(0),
    l_extendedprice = numeric(0),
    l_discount = numeric(0),
    l_tax = numeric(0),
    l_returnflag = character(0),
    l_linestatus = character(0),
    l_shipdate = as.Date(character(0)),
    l_commitdate = as.Date(character(0)),
    l_receiptdate = as.Date(character(0)),
    l_shipinstruct = character(0),
    l_shipmode = character(0),
    l_comment = character(0),
  ) %>%
    as_duckplyr_df()

  nation <- tibble::tibble(
    n_nationkey = integer(0),
    n_name = character(0),
    n_regionkey = integer(0),
    n_comment = character(0),
  ) %>%
    as_duckplyr_df()

  orders <- tibble::tibble(
    o_orderkey = integer(0),
    o_custkey = integer(0),
    o_orderstatus = character(0),
    o_totalprice = numeric(0),
    o_orderdate = as.Date(character(0)),
    o_orderpriority = character(0),
    o_clerk = character(0),
    o_shippriority = integer(0),
    o_comment = character(0),
  ) %>%
    as_duckplyr_df()

  part <- tibble::tibble(
    p_partkey = integer(0),
    p_name = character(0),
    p_mfgr = character(0),
    p_brand = character(0),
    p_type = character(0),
    p_size = integer(0),
    p_container = character(0),
    p_retailprice = numeric(0),
    p_comment = character(0),
  ) %>%
    as_duckplyr_df()

  partsupp <- tibble::tibble(
    ps_partkey = integer(0),
    ps_suppkey = integer(0),
    ps_availqty = integer(0),
    ps_supplycost = numeric(0),
    ps_comment = character(0),
  ) %>%
    as_duckplyr_df()

  region <- tibble::tibble(
    r_regionkey = integer(0),
    r_name = character(0),
    r_comment = character(0),
  ) %>%
    as_duckplyr_df()

  supplier <- tibble::tibble(
    s_suppkey = integer(0),
    s_name = character(0),
    s_address = character(0),
    s_nationkey = integer(0),
    s_phone = character(0),
    s_acctbal = numeric(0),
    s_comment = character(0),
  ) %>%
    as_duckplyr_df()

  withr::local_envvar(DUCKPLYR_FORCE = TRUE)
  local_options(duckdb.materialize_message = FALSE)

  local_bindings(
    customer = customer,
    lineitem = lineitem,
    nation = nation,
    orders = orders,
    part = part,
    partsupp = partsupp,
    region = region,
    supplier = supplier,
    .env = .GlobalEnv
  )

  expect_snapshot({
    tpch_01()
    tpch_02()
    tpch_03()
    tpch_04()
    tpch_05()
    tpch_06()
    tpch_07()
    tpch_08()
    tpch_09()
    tpch_10()
    tpch_11()
    tpch_12()
    tpch_13()
    tpch_14()
    tpch_15()
    tpch_16()
    tpch_17()
    tpch_18()
    tpch_19()
    tpch_20()
    tpch_21()
    tpch_22()
  })
})
