pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = 1)

load("tools/tpch/001.rda")

test_dplyr_q <- list()

test_dplyr_q[[1]] <- function() {
  lineitem |>
    duckplyr_select(l_shipdate, l_returnflag, l_linestatus, l_quantity, l_extendedprice, l_discount, l_tax) |>
    duckplyr_filter(l_shipdate <= as.Date("1998-09-02")) |>
    duckplyr_select(l_returnflag, l_linestatus, l_quantity, l_extendedprice, l_discount, l_tax) |>
    duckplyr_summarise(
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
    duckplyr_arrange(l_returnflag, l_linestatus)
}

test_dplyr_q[[2]] <- function() {
  ps <- partsupp |> duckplyr_select(ps_partkey, ps_suppkey, ps_supplycost)

  p <- part |>
    duckplyr_select(p_partkey, p_type, p_size, p_mfgr) |>
    duckplyr_filter(p_size == 15, grepl("BRASS$", p_type)) |>
    duckplyr_select(p_partkey, p_mfgr)

  psp <- duckplyr_inner_join(ps, p, by = c("ps_partkey" = "p_partkey"))

  sp <- supplier |>
    duckplyr_select(
      s_suppkey, s_nationkey, s_acctbal, s_name,
      s_address, s_phone, s_comment
    )

  psps <- duckplyr_inner_join(psp, sp,
    by = c("ps_suppkey" = "s_suppkey")
  ) |>
    duckplyr_select(
      ps_partkey, ps_supplycost, p_mfgr, s_nationkey,
      s_acctbal, s_name, s_address, s_phone, s_comment
    )

  nr <- duckplyr_inner_join(
    nation,
    region |> duckplyr_filter(r_name == "EUROPE"),
    by = c("n_regionkey" = "r_regionkey")
  ) |>
    duckplyr_select(n_nationkey, n_name)

  pspsnr <- duckplyr_inner_join(psps, nr, by = c("s_nationkey" = "n_nationkey")) |>
    duckplyr_select(
      ps_partkey, ps_supplycost, p_mfgr, n_name, s_acctbal,
      s_name, s_address, s_phone, s_comment
    )

  aggr <- pspsnr |>
    duckplyr_summarise(min_ps_supplycost = min(ps_supplycost), .by = ps_partkey)

  sj <- duckplyr_inner_join(pspsnr, aggr,
    by = c("ps_partkey" = "ps_partkey", "ps_supplycost" = "min_ps_supplycost")
  )


  res <- sj |>
    duckplyr_select(
      s_acctbal, s_name, n_name, ps_partkey, p_mfgr,
      s_address, s_phone, s_comment
    ) |>
    # TODO
    # duckplyr_arrange(desc(s_acctbal), n_name, s_name, ps_partkey) |>
    duckplyr_arrange(s_acctbal, n_name, s_name, ps_partkey) |>
    head(100)

  res
}

test_dplyr_q[[3]] <- function() {
  oc <- duckplyr_inner_join(
    orders |>
      duckplyr_select(o_orderkey, o_custkey, o_orderdate, o_shippriority) |>
      duckplyr_filter(o_orderdate < as.Date("1995-03-15")),
    customer |>
      duckplyr_select(c_custkey, c_mktsegment) |>
      duckplyr_filter(c_mktsegment == "BUILDING"),
    by = c("o_custkey" = "c_custkey")
  ) |>
    duckplyr_select(o_orderkey, o_orderdate, o_shippriority)

  loc <- duckplyr_inner_join(
    lineitem |>
      duckplyr_select(l_orderkey, l_shipdate, l_extendedprice, l_discount) |>
      duckplyr_filter(l_shipdate > as.Date("1995-03-15")) |>
      duckplyr_select(l_orderkey, l_extendedprice, l_discount),
    oc,
    by = c("l_orderkey" = "o_orderkey")
  )

  aggr <- loc |>
    duckplyr_mutate(volume = l_extendedprice * (1 - l_discount)) |>
    duckplyr_summarise(revenue = sum(volume), .by = c(l_orderkey, o_orderdate, o_shippriority)) |>
    duckplyr_select(l_orderkey, revenue, o_orderdate, o_shippriority) |>
    # duckplyr_arrange(desc(revenue), o_orderdate) |>
    duckplyr_arrange(revenue, o_orderdate) |>
    head(10)
  aggr
}

test_dplyr_q[[4]] <- function() {
  l <- lineitem |>
    duckplyr_select(l_orderkey, l_commitdate, l_receiptdate) |>
    duckplyr_filter(l_commitdate < l_receiptdate) |>
    duckplyr_select(l_orderkey)

  o <- orders |>
    duckplyr_select(o_orderkey, o_orderdate, o_orderpriority) |>
    duckplyr_filter(o_orderdate >= as.Date("1993-07-01"), o_orderdate < as.Date("1993-10-01")) |>
    duckplyr_select(o_orderkey, o_orderpriority)

  # distinct after join, tested and indeed faster
  lo <- duckplyr_inner_join(l, o, by = c("l_orderkey" = "o_orderkey")) |>
    distinct() |>
    duckplyr_select(o_orderpriority)

  aggr <- lo |>
    duckplyr_summarise(order_count = n(), .by = o_orderpriority) |>
    duckplyr_arrange(o_orderpriority)

  aggr
}

test_dplyr_q[[5]] <- function() {
  nr <- duckplyr_inner_join(
    nation |>
      duckplyr_select(n_nationkey, n_regionkey, n_name),
    region |>
      duckplyr_select(r_regionkey, r_name) |>
      duckplyr_filter(r_name == "ASIA"),
    by = c("n_regionkey" = "r_regionkey")
  ) |>
    duckplyr_select(n_nationkey, n_name)

  snr <- duckplyr_inner_join(
    supplier |>
      duckplyr_select(s_suppkey, s_nationkey),
    nr,
    by = c("s_nationkey" = "n_nationkey")
  ) |>
    duckplyr_select(s_suppkey, s_nationkey, n_name)

  lsnr <- duckplyr_inner_join(
    lineitem |> duckplyr_select(l_suppkey, l_orderkey, l_extendedprice, l_discount),
    snr,
    by = c("l_suppkey" = "s_suppkey")
  )

  o <- orders |>
    duckplyr_select(o_orderdate, o_orderkey, o_custkey) |>
    duckplyr_filter(o_orderdate >= as.Date("1994-01-01"), o_orderdate < as.Date("1995-01-01")) |>
    duckplyr_select(o_orderkey, o_custkey)

  oc <- duckplyr_inner_join(o, customer |> duckplyr_select(c_custkey, c_nationkey),
    by = c("o_custkey" = "c_custkey")
  ) |>
    duckplyr_select(o_orderkey, c_nationkey)

  lsnroc <- duckplyr_inner_join(lsnr, oc,
    by = c("l_orderkey" = "o_orderkey", "s_nationkey" = "c_nationkey")
  ) |>
    duckplyr_select(l_extendedprice, l_discount, n_name)

  aggr <- lsnroc |>
    duckplyr_mutate(volume = l_extendedprice * (1 - l_discount)) |>
    duckplyr_summarise(revenue = sum(volume), .by = n_name) |>
    # duckplyr_arrange(desc(revenue)) # TODO
    duckplyr_arrange(revenue)

  aggr
}

test_dplyr_q[[6]] <- function() {
  lineitem |>
    duckplyr_select(l_shipdate, l_extendedprice, l_discount, l_quantity) |>
    duckplyr_filter(
      l_shipdate >= as.Date("1994-01-01"),
      l_shipdate < as.Date("1995-01-01"),
      l_discount >= 0.05,
      l_discount <= 0.07,
      l_quantity < 24
    ) |>
    duckplyr_select(l_extendedprice, l_discount) |>
    duckplyr_summarise(revenue = sum(l_extendedprice * l_discount))
}

test_dplyr_q[[7]] <- function() {
  sn <- duckplyr_inner_join(
    supplier |>
      duckplyr_select(s_nationkey, s_suppkey),
    nation |>
      duckplyr_select(n1_nationkey = n_nationkey, n1_name = n_name) |>
      # duckplyr_filter(n1_name %in% c("FRANCE", "GERMANY")),  TODO
      duckplyr_filter(n1_name == "FRANCE" | n1_name == "GERMANY"),
    by = c("s_nationkey" = "n1_nationkey")
  ) |>
    duckplyr_select(s_suppkey, n1_name)

  cn <- duckplyr_inner_join(
    customer |>
      duckplyr_select(c_custkey, c_nationkey),
    nation |>
      duckplyr_select(n2_nationkey = n_nationkey, n2_name = n_name) |>
      # duckplyr_filter(n2_name %in% c("FRANCE", "GERMANY")),
      duckplyr_filter(n2_name == "FRANCE" | n2_name == "GERMANY"),
    by = c("c_nationkey" = "n2_nationkey")
  ) |>
    duckplyr_select(c_custkey, n2_name)

  cno <- duckplyr_inner_join(
    orders |>
      duckplyr_select(o_custkey, o_orderkey),
    cn,
    by = c("o_custkey" = "c_custkey")
  ) |>
    duckplyr_select(o_orderkey, n2_name)

  cnol <- duckplyr_inner_join(
    lineitem |>
      duckplyr_select(l_orderkey, l_suppkey, l_shipdate, l_extendedprice, l_discount) |>
      duckplyr_filter(l_shipdate >= as.Date("1995-01-01"), l_shipdate <= as.Date("1996-12-31")),
    cno,
    by = c("l_orderkey" = "o_orderkey")
  ) |>
    duckplyr_select(l_suppkey, l_shipdate, l_extendedprice, l_discount, n2_name)

  all <- duckplyr_inner_join(cnol, sn, by = c("l_suppkey" = "s_suppkey"))

  aggr <- all |>
    duckplyr_filter((n1_name == "FRANCE" & n2_name == "GERMANY") |
      (n1_name == "GERMANY" & n2_name == "FRANCE")) |>
    duckplyr_mutate(
      supp_nation = n1_name,
      cust_nation = n2_name,
      l_year = as.integer(strftime(l_shipdate, "%Y")),
      volume = l_extendedprice * (1 - l_discount)
    ) |>
    duckplyr_select(supp_nation, cust_nation, l_year, volume) |>
    duckplyr_summarise(revenue = sum(volume), .by = c(supp_nation, cust_nation, l_year)) |>
    duckplyr_arrange(supp_nation, cust_nation, l_year)

  aggr
}

test_dplyr_q[[8]] <- function() {
  nr <- duckplyr_inner_join(
    nation |>
      duckplyr_select(n1_nationkey = n_nationkey, n1_regionkey = n_regionkey),
    region |>
      duckplyr_select(r_regionkey, r_name) |>
      duckplyr_filter(r_name == "AMERICA") |>
      duckplyr_select(r_regionkey),
    by = c("n1_regionkey" = "r_regionkey")
  ) |>
    duckplyr_select(n1_nationkey)

  cnr <- duckplyr_inner_join(
    customer |>
      duckplyr_select(c_custkey, c_nationkey),
    nr,
    by = c("c_nationkey" = "n1_nationkey")
  ) |>
    duckplyr_select(c_custkey)

  ocnr <- duckplyr_inner_join(
    orders |>
      duckplyr_select(o_orderkey, o_custkey, o_orderdate) |>
      duckplyr_filter(o_orderdate >= as.Date("1995-01-01"), o_orderdate <= as.Date("1996-12-31")),
    cnr,
    by = c("o_custkey" = "c_custkey")
  ) |>
    duckplyr_select(o_orderkey, o_orderdate)

  locnr <- duckplyr_inner_join(
    lineitem |>
      duckplyr_select(l_orderkey, l_partkey, l_suppkey, l_extendedprice, l_discount),
    ocnr,
    by = c("l_orderkey" = "o_orderkey")
  ) |>
    duckplyr_select(l_partkey, l_suppkey, l_extendedprice, l_discount, o_orderdate)

  locnrp <- duckplyr_inner_join(locnr,
    part |>
      duckplyr_select(p_partkey, p_type) |>
      duckplyr_filter(p_type == "ECONOMY ANODIZED STEEL") |>
      duckplyr_select(p_partkey),
    by = c("l_partkey" = "p_partkey")
  ) |>
    duckplyr_select(l_suppkey, l_extendedprice, l_discount, o_orderdate)

  locnrps <- duckplyr_inner_join(locnrp,
    supplier |>
      duckplyr_select(s_suppkey, s_nationkey),
    by = c("l_suppkey" = "s_suppkey")
  ) |>
    duckplyr_select(l_extendedprice, l_discount, o_orderdate, s_nationkey)

  all <- duckplyr_inner_join(locnrps,
    nation |>
      duckplyr_select(n2_nationkey = n_nationkey, n2_name = n_name),
    by = c("s_nationkey" = "n2_nationkey")
  ) |>
    duckplyr_select(l_extendedprice, l_discount, o_orderdate, n2_name)

  aggr <- all |>
    duckplyr_mutate(
      o_year = as.integer(strftime(o_orderdate, "%Y")),
      volume = l_extendedprice * (1 - l_discount),
      nation = n2_name
    ) |>
    duckplyr_select(o_year, volume, nation) |>
    duckplyr_summarise(
      mkt_share = sum(ifelse(nation == "BRAZIL", volume, 0)) / sum(volume),
      .by = o_year
    ) |>
    duckplyr_arrange(o_year)
  aggr
}

test_dplyr_q[[9]] <- function() {
  p <- part |>
    duckplyr_select(p_name, p_partkey) |>
    duckplyr_filter(grepl("green", p_name)) |>
    duckplyr_select(p_partkey)

  psp <- duckplyr_inner_join(
    partsupp |>
      duckplyr_select(ps_suppkey, ps_partkey, ps_supplycost),
    p,
    by = c("ps_partkey" = "p_partkey")
  )

  sn <- duckplyr_inner_join(
    supplier |>
      duckplyr_select(s_suppkey, s_nationkey),
    nation |>
      duckplyr_select(n_nationkey, n_name),
    by = c("s_nationkey" = "n_nationkey")
  ) |>
    duckplyr_select(s_suppkey, n_name)

  pspsn <- duckplyr_inner_join(psp, sn, by = c("ps_suppkey" = "s_suppkey"))

  lpspsn <- duckplyr_inner_join(
    lineitem |>
      duckplyr_select(l_suppkey, l_partkey, l_orderkey, l_extendedprice, l_discount, l_quantity),
    pspsn,
    by = c("l_suppkey" = "ps_suppkey", "l_partkey" = "ps_partkey")
  ) |>
    duckplyr_select(l_orderkey, l_extendedprice, l_discount, l_quantity, ps_supplycost, n_name)

  all <- duckplyr_inner_join(
    orders |>
      duckplyr_select(o_orderkey, o_orderdate),
    lpspsn,
    by = c("o_orderkey" = "l_orderkey")
  ) |>
    duckplyr_select(l_extendedprice, l_discount, l_quantity, ps_supplycost, n_name, o_orderdate)

  aggr <- all |>
    duckplyr_mutate(
      nation = n_name,
      o_year = as.integer(strftime(o_orderdate, "%Y")),
      amount = l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity
    ) |>
    duckplyr_select(nation, o_year, amount) |>
    duckplyr_summarise(sum_profit = sum(amount), .by = c(nation, o_year)) |>
    # duckplyr_arrange(nation, desc(o_year)) TODO
    duckplyr_arrange(nation, o_year)

  aggr
}

test_dplyr_q[[10]] <- function() {
  l <- lineitem |>
    duckplyr_select(l_orderkey, l_returnflag, l_extendedprice, l_discount) |>
    duckplyr_filter(l_returnflag == "R") |>
    duckplyr_select(l_orderkey, l_extendedprice, l_discount)

  o <- orders |>
    duckplyr_select(o_orderkey, o_custkey, o_orderdate) |>
    duckplyr_filter(o_orderdate >= as.Date("1993-10-01"), o_orderdate < as.Date("1994-01-01")) |>
    duckplyr_select(o_orderkey, o_custkey)

  lo <- duckplyr_inner_join(l, o,
    by = c("l_orderkey" = "o_orderkey")
  ) |>
    duckplyr_select(l_extendedprice, l_discount, o_custkey)
  # first aggregate, then join with customer/nation,
  # otherwise we need to aggr over lots of cols

  lo_aggr <- lo |>
    duckplyr_mutate(volume = l_extendedprice * (1 - l_discount)) |>
    duckplyr_summarise(revenue = sum(volume), .by = o_custkey)

  c <- customer |>
    duckplyr_select(c_custkey, c_nationkey, c_name, c_acctbal, c_phone, c_address, c_comment)

  loc <- duckplyr_inner_join(lo_aggr, c, by = c("o_custkey" = "c_custkey"))

  locn <- duckplyr_inner_join(loc, nation |> duckplyr_select(n_nationkey, n_name),
    by = c("c_nationkey" = "n_nationkey")
  )

  res <- locn |>
    duckplyr_select(
      o_custkey, c_name, revenue, c_acctbal, n_name,
      c_address, c_phone, c_comment
    ) |>
    # duckplyr_arrange(desc(revenue)) |> TODO
    duckplyr_arrange(revenue) |>
    head(20)

  res
}

# gctorture2(1001)

test_dplyr_q[[1]]()

test_dplyr_q[[2]]()

test_dplyr_q[[3]]()

test_dplyr_q[[4]]()

test_dplyr_q[[5]]()

test_dplyr_q[[6]]()

test_dplyr_q[[7]]()

test_dplyr_q[[8]]()

test_dplyr_q[[9]]()

test_dplyr_q[[10]]()

asf



res <- list()

for (q in seq_along(test_dplyr_q)) {
  f <- test_dplyr_q[[q]]
  cold <- as.data.frame(f())
  time <- system.time(as.data.frame(f()))[[3]]
  print(q)
  print(time)
  res[[q]] <- data.frame(pkg = pkg, q = q, time = time)
}

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))
