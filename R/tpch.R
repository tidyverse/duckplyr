select_opt <- select
# select_opt <- function(x, ...) x

TPCH_NA_MATCHES <- "never"

#' @autoglobal
tpch_01 <- function() {
  lineitem |>
    select_opt(l_shipdate, l_returnflag, l_linestatus, l_quantity, l_extendedprice, l_discount, l_tax) |>
    filter(l_shipdate <= !!as.Date("1998-09-02")) |>
    select_opt(l_returnflag, l_linestatus, l_quantity, l_extendedprice, l_discount, l_tax) |>
    summarise(
      sum_qty = sum(l_quantity),
      sum_base_price = sum(l_extendedprice),
      sum_disc_price = sum(l_extendedprice * (1 - l_discount)),
      sum_charge = sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)),
      avg_qty = mean(l_quantity),
      avg_price = mean(l_extendedprice),
      avg_disc = mean(l_discount),
      count_order = n(),
      .by = c(l_returnflag, l_linestatus)
    ) |>
    arrange(l_returnflag, l_linestatus)
}

#' @autoglobal
tpch_02 <- function() {
  ps <- partsupp |> select_opt(ps_partkey, ps_suppkey, ps_supplycost)

  p <- part |>
    select_opt(p_partkey, p_type, p_size, p_mfgr) |>
    filter(p_size == 15, grepl("BRASS$", p_type)) |>
    select_opt(p_partkey, p_mfgr)

  psp <- inner_join(na_matches = TPCH_NA_MATCHES, p, ps, by = c("p_partkey" = "ps_partkey"))

  sp <- supplier |>
    select_opt(
      s_suppkey, s_nationkey, s_acctbal, s_name,
      s_address, s_phone, s_comment
    )

  psps <- inner_join(psp, sp,
    by = c("ps_suppkey" = "s_suppkey")
  ) |>
    select_opt(
      p_partkey, ps_supplycost, p_mfgr, s_nationkey,
      s_acctbal, s_name, s_address, s_phone, s_comment
    )

  nr <- inner_join(
    nation,
    region |> filter(r_name == "EUROPE"),
    by = c("n_regionkey" = "r_regionkey")
  ) |>
    select_opt(n_nationkey, n_name)

  pspsnr <- inner_join(psps, nr, by = c("s_nationkey" = "n_nationkey")) |>
    select_opt(
      p_partkey, ps_supplycost, p_mfgr, n_name, s_acctbal,
      s_name, s_address, s_phone, s_comment
    )

  aggr <- pspsnr |>
    summarise(min_ps_supplycost = min(ps_supplycost), .by = p_partkey)

  sj <- inner_join(pspsnr, aggr,
    by = c(
      "p_partkey" = "p_partkey",
      "ps_supplycost" = "min_ps_supplycost"
    )
  )

  res <- sj |>
    select(
      s_acctbal, s_name, n_name, p_partkey, p_mfgr,
      s_address, s_phone, s_comment
    ) |>
    arrange(desc(s_acctbal), n_name, s_name, p_partkey) |>
    head(100)

  res
}

#' @autoglobal
tpch_03 <- function() {
  oc <- inner_join(
    orders |>
      select_opt(o_orderkey, o_custkey, o_orderdate, o_shippriority) |>
      filter(o_orderdate < !!as.Date("1995-03-15")),
    customer |>
      select_opt(c_custkey, c_mktsegment) |>
      filter(c_mktsegment == "BUILDING"),
    by = c("o_custkey" = "c_custkey")
  ) |>
    select_opt(o_orderkey, o_orderdate, o_shippriority)

  loc <- inner_join(
    lineitem |>
      select_opt(l_orderkey, l_shipdate, l_extendedprice, l_discount) |>
      filter(l_shipdate > !!as.Date("1995-03-15")) |>
      select_opt(l_orderkey, l_extendedprice, l_discount),
    oc,
    by = c("l_orderkey" = "o_orderkey")
  )

  aggr <- loc |>
    mutate(volume = l_extendedprice * (1 - l_discount)) |>
    summarise(revenue = sum(volume), .by = c(l_orderkey, o_orderdate, o_shippriority)) |>
    select(l_orderkey, revenue, o_orderdate, o_shippriority) |>
    arrange(desc(revenue), o_orderdate) |>
    head(10)
  aggr
}

#' @autoglobal
tpch_04 <- function() {
  l <- lineitem |>
    select_opt(l_orderkey, l_commitdate, l_receiptdate) |>
    filter(l_commitdate < l_receiptdate) |>
    select(l_orderkey)

  o <- orders |>
    select_opt(o_orderkey, o_orderdate, o_orderpriority) |>
    filter(o_orderdate >= !!as.Date("1993-07-01"), o_orderdate < !!as.Date("1993-10-01")) |>
    select(o_orderkey, o_orderpriority)

  # distinct after join, tested and indeed faster
  lo <- inner_join(na_matches = TPCH_NA_MATCHES, l, o, by = c("l_orderkey" = "o_orderkey")) |>
    distinct() |>
    select_opt(o_orderpriority)

  aggr <- lo |>
    summarise(order_count = n(), .by = o_orderpriority) |>
    arrange(o_orderpriority)

  aggr
}

#' @autoglobal
tpch_05 <- function() {
  nr <- inner_join(na_matches = TPCH_NA_MATCHES,
    nation |>
      select_opt(n_nationkey, n_regionkey, n_name),
    region |>
      select_opt(r_regionkey, r_name) |>
      filter(r_name == "ASIA"),
    by = c("n_regionkey" = "r_regionkey")
  ) |>
    select_opt(n_nationkey, n_name)

  snr <- inner_join(na_matches = TPCH_NA_MATCHES,
    supplier |>
      select_opt(s_suppkey, s_nationkey),
    nr,
    by = c("s_nationkey" = "n_nationkey")
  ) |>
    select_opt(s_suppkey, s_nationkey, n_name)

  lsnr <- inner_join(na_matches = TPCH_NA_MATCHES,
    lineitem |> select_opt(l_suppkey, l_orderkey, l_extendedprice, l_discount),
    snr,
    by = c("l_suppkey" = "s_suppkey")
  )

  o <- orders |>
    select_opt(o_orderdate, o_orderkey, o_custkey) |>
    filter(o_orderdate >= !!as.Date("1994-01-01"), o_orderdate < !!as.Date("1995-01-01")) |>
    select_opt(o_orderkey, o_custkey)

  oc <- inner_join(na_matches = TPCH_NA_MATCHES, o, customer |> select_opt(c_custkey, c_nationkey),
    by = c("o_custkey" = "c_custkey")
  ) |>
    select_opt(o_orderkey, c_nationkey)

  lsnroc <- inner_join(na_matches = TPCH_NA_MATCHES, lsnr, oc,
    by = c("l_orderkey" = "o_orderkey", "s_nationkey" = "c_nationkey")
  ) |>
    select_opt(l_extendedprice, l_discount, n_name)

  aggr <- lsnroc |>
    mutate(volume = l_extendedprice * (1 - l_discount)) |>
    summarise(revenue = sum(volume), .by = n_name) |>
    arrange(desc(revenue))

  aggr
}

#' @autoglobal
tpch_06 <- function() {
  lineitem |>
    select_opt(l_shipdate, l_extendedprice, l_discount, l_quantity) |>
    filter(
      l_shipdate >= !!as.Date("1994-01-01"),
      l_shipdate < !!as.Date("1995-01-01"),
      l_discount >= 0.05,
      l_discount <= 0.07,
      l_quantity < 24
    ) |>
    select_opt(l_extendedprice, l_discount) |>
    summarise(revenue = sum(l_extendedprice * l_discount))
}

#' @autoglobal
tpch_07 <- function() {
  sn <- inner_join(na_matches = TPCH_NA_MATCHES,
    supplier |>
      select_opt(s_nationkey, s_suppkey),
    nation |>
      select(n1_nationkey = n_nationkey, n1_name = n_name) |>
      # filter(n1_name %in% c("FRANCE", "GERMANY")),  TODO
      filter(n1_name == "FRANCE" | n1_name == "GERMANY"),
    by = c("s_nationkey" = "n1_nationkey")
  ) |>
    select_opt(s_suppkey, n1_name)

  cn <- inner_join(na_matches = TPCH_NA_MATCHES,
    customer |>
      select_opt(c_custkey, c_nationkey),
    nation |>
      select(n2_nationkey = n_nationkey, n2_name = n_name) |>
      # filter(n2_name %in% c("FRANCE", "GERMANY")),
      filter(n2_name == "FRANCE" | n2_name == "GERMANY"),
    by = c("c_nationkey" = "n2_nationkey")
  ) |>
    select_opt(c_custkey, n2_name)

  cno <- inner_join(na_matches = TPCH_NA_MATCHES,
    orders |>
      select_opt(o_custkey, o_orderkey),
    cn,
    by = c("o_custkey" = "c_custkey")
  ) |>
    select_opt(o_orderkey, n2_name)

  cnol <- inner_join(na_matches = TPCH_NA_MATCHES,
    lineitem |>
      select_opt(l_orderkey, l_suppkey, l_shipdate, l_extendedprice, l_discount) |>
      filter(l_shipdate >= !!as.Date("1995-01-01"), l_shipdate <= !!as.Date("1996-12-31")),
    cno,
    by = c("l_orderkey" = "o_orderkey")
  ) |>
    select_opt(l_suppkey, l_shipdate, l_extendedprice, l_discount, n2_name)

  all <- inner_join(na_matches = TPCH_NA_MATCHES, cnol, sn, by = c("l_suppkey" = "s_suppkey"))

  aggr <- all |>
    filter((n1_name == "FRANCE" & n2_name == "GERMANY") |
      (n1_name == "GERMANY" & n2_name == "FRANCE")) |>
    mutate(
      supp_nation = n1_name,
      cust_nation = n2_name,
      l_year = as.integer(strftime(l_shipdate, "%Y")),
      volume = l_extendedprice * (1 - l_discount)
    ) |>
    select_opt(supp_nation, cust_nation, l_year, volume) |>
    summarise(revenue = sum(volume), .by = c(supp_nation, cust_nation, l_year)) |>
    arrange(supp_nation, cust_nation, l_year)

  aggr
}

#' @autoglobal
tpch_08 <- function() {
  nr <- inner_join(na_matches = TPCH_NA_MATCHES,
    nation |>
      select(n1_nationkey = n_nationkey, n1_regionkey = n_regionkey),
    region |>
      select_opt(r_regionkey, r_name) |>
      filter(r_name == "AMERICA") |>
      select_opt(r_regionkey),
    by = c("n1_regionkey" = "r_regionkey")
  ) |>
    select_opt(n1_nationkey)

  cnr <- inner_join(na_matches = TPCH_NA_MATCHES,
    customer |>
      select_opt(c_custkey, c_nationkey),
    nr,
    by = c("c_nationkey" = "n1_nationkey")
  ) |>
    select_opt(c_custkey)

  ocnr <- inner_join(na_matches = TPCH_NA_MATCHES,
    orders |>
      select_opt(o_orderkey, o_custkey, o_orderdate) |>
      filter(o_orderdate >= !!as.Date("1995-01-01"), o_orderdate <= !!as.Date("1996-12-31")),
    cnr,
    by = c("o_custkey" = "c_custkey")
  ) |>
    select_opt(o_orderkey, o_orderdate)

  locnr <- inner_join(na_matches = TPCH_NA_MATCHES,
    lineitem |>
      select_opt(l_orderkey, l_partkey, l_suppkey, l_extendedprice, l_discount),
    ocnr,
    by = c("l_orderkey" = "o_orderkey")
  ) |>
    select_opt(l_partkey, l_suppkey, l_extendedprice, l_discount, o_orderdate)

  locnrp <- inner_join(na_matches = TPCH_NA_MATCHES, locnr,
    part |>
      select_opt(p_partkey, p_type) |>
      filter(p_type == "ECONOMY ANODIZED STEEL") |>
      select_opt(p_partkey),
    by = c("l_partkey" = "p_partkey")
  ) |>
    select_opt(l_suppkey, l_extendedprice, l_discount, o_orderdate)

  locnrps <- inner_join(na_matches = TPCH_NA_MATCHES, locnrp,
    supplier |>
      select_opt(s_suppkey, s_nationkey),
    by = c("l_suppkey" = "s_suppkey")
  ) |>
    select_opt(l_extendedprice, l_discount, o_orderdate, s_nationkey)

  all <- inner_join(na_matches = TPCH_NA_MATCHES, locnrps,
    nation |>
      select(n2_nationkey = n_nationkey, n2_name = n_name),
    by = c("s_nationkey" = "n2_nationkey")
  ) |>
    select_opt(l_extendedprice, l_discount, o_orderdate, n2_name)

  aggr <- all |>
    mutate(
      o_year =  as.integer(strftime(o_orderdate, "%Y")),
      volume = l_extendedprice * (1 - l_discount),
      nation = n2_name
    ) |>
    select_opt(o_year, volume, nation) |>
    summarise(
      mkt_share = sum(ifelse(nation == "BRAZIL", volume, 0)) / sum(volume),
      .by = o_year
    ) |>
    arrange(o_year)
  aggr
}

#' @autoglobal
tpch_09 <- function() {
  p <- part |>
    select_opt(p_name, p_partkey) |>
    filter(grepl("green", p_name)) |>
    select_opt(p_partkey)

  psp <- inner_join(na_matches = TPCH_NA_MATCHES,
    partsupp |>
      select_opt(ps_suppkey, ps_partkey, ps_supplycost),
    p,
    by = c("ps_partkey" = "p_partkey")
  )

  sn <- inner_join(na_matches = TPCH_NA_MATCHES,
    supplier |>
      select_opt(s_suppkey, s_nationkey),
    nation |>
      select_opt(n_nationkey, n_name),
    by = c("s_nationkey" = "n_nationkey")
  ) |>
    select_opt(s_suppkey, n_name)

  pspsn <- inner_join(na_matches = TPCH_NA_MATCHES, psp, sn, by = c("ps_suppkey" = "s_suppkey"))

  lpspsn <- inner_join(na_matches = TPCH_NA_MATCHES,
    lineitem |>
      select_opt(l_suppkey, l_partkey, l_orderkey, l_extendedprice, l_discount, l_quantity),
    pspsn,
    by = c("l_suppkey" = "ps_suppkey", "l_partkey" = "ps_partkey")
  ) |>
    select_opt(l_orderkey, l_extendedprice, l_discount, l_quantity, ps_supplycost, n_name)

  all <- inner_join(na_matches = TPCH_NA_MATCHES,
    orders |>
      select_opt(o_orderkey, o_orderdate),
    lpspsn,
    by = c("o_orderkey" = "l_orderkey")
  ) |>
    select_opt(l_extendedprice, l_discount, l_quantity, ps_supplycost, n_name, o_orderdate)

  aggr <- all |>
    mutate(
      nation = n_name,
      o_year = as.integer(strftime(o_orderdate, "%Y")),
      amount = l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity
    ) |>
    select_opt(nation, o_year, amount) |>
    summarise(sum_profit = sum(amount), .by = c(nation, o_year)) |>
    arrange(nation, desc(o_year))

  aggr
}

#' @autoglobal
tpch_10 <- function() {
  l <- lineitem |>
    select_opt(l_orderkey, l_returnflag, l_extendedprice, l_discount) |>
    filter(l_returnflag == "R") |>
    select_opt(l_orderkey, l_extendedprice, l_discount)

  o <- orders |>
    select_opt(o_orderkey, o_custkey, o_orderdate) |>
    filter(o_orderdate >= !!as.Date("1993-10-01"), o_orderdate < !!as.Date("1994-01-01")) |>
    select_opt(o_orderkey, o_custkey)

  lo <- inner_join(na_matches = TPCH_NA_MATCHES, l, o,
    by = c("l_orderkey" = "o_orderkey")
  ) |>
    select_opt(l_extendedprice, l_discount, o_custkey)
  # first aggregate, then join with customer/nation,
  # otherwise we need to aggr over lots of cols

  lo_aggr <- lo |>
    mutate(volume = l_extendedprice * (1 - l_discount)) |>
    summarise(revenue = sum(volume), .by = o_custkey)

  c <- customer |>
    select_opt(c_custkey, c_nationkey, c_name, c_acctbal, c_phone, c_address, c_comment)

  loc <- inner_join(na_matches = TPCH_NA_MATCHES, c, lo_aggr, by = c("c_custkey" = "o_custkey"))

  locn <- inner_join(na_matches = TPCH_NA_MATCHES, loc, nation |> select_opt(n_nationkey, n_name),
    by = c("c_nationkey" = "n_nationkey")
  )

  res <- locn |>
    select(
      c_custkey, c_name, revenue, c_acctbal, n_name,
      c_address, c_phone, c_comment
    ) |>
    arrange(desc(revenue)) |>
    head(20)

  res
}
