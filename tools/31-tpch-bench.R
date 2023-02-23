pkgload::load_all()

test_dplyr_q <- list()

tables <- c("lineitem", "partsupp", "part", "supplier", "nation", "orders", "customer", "region")
env <- environment()


lapply(tables, function(t) {
  assign(t, arrow::read_parquet(fs::path("tools/tpch/001", paste0(t, ".parquet"))), env=env)
  NULL
})



test_dplyr_q[[1]] <- function() {
  lineitem |>
    select(l_shipdate, l_returnflag, l_linestatus, l_quantity,
           l_extendedprice, l_discount, l_tax) |>
    filter(l_shipdate <= as.Date("1998-09-02")) |>
    select(l_returnflag, l_linestatus, l_quantity, l_extendedprice, l_discount, l_tax) |>
    group_by(l_returnflag, l_linestatus) |>
    summarise(
      sum_qty = sum(l_quantity),
      sum_base_price = sum(l_extendedprice),
      sum_disc_price = sum(l_extendedprice * (1 - l_discount)),
      sum_charge = sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)),
      avg_qty = mean(l_quantity),
      avg_price = mean(l_extendedprice),
      avg_disc = mean(l_discount),
      count_order = n()
    ) |>
    arrange(l_returnflag, l_linestatus)
}

test_dplyr_q[[2]] <- function() {
  ps <- partsupp |> select(ps_partkey, ps_suppkey, ps_supplycost)

  p <- part |>
    select(p_partkey, p_type, p_size, p_mfgr) |>
    filter(p_size == 15, grepl("BRASS$", p_type)) |>
    select(p_partkey, p_mfgr)

  psp <- inner_join(ps, p, by = c("ps_partkey" = "p_partkey"))

  sp <- supplier |>
    select(s_suppkey, s_nationkey, s_acctbal, s_name,
           s_address, s_phone, s_comment)

  psps <- inner_join(psp, sp,
                     by = c("ps_suppkey" = "s_suppkey")) |>
    select(ps_partkey, ps_supplycost, p_mfgr, s_nationkey,
           s_acctbal, s_name, s_address, s_phone, s_comment)

  nr <- inner_join(nation,
                   region |> filter(r_name == "EUROPE"),
                   by = c("n_regionkey" = "r_regionkey")) |>
    select(n_nationkey, n_name)

  pspsnr <- inner_join(psps, nr,
                       by = c("s_nationkey" = "n_nationkey")) |>
    select(ps_partkey, ps_supplycost, p_mfgr, n_name, s_acctbal,
           s_name, s_address, s_phone, s_comment)

  aggr <- pspsnr |>
    group_by(ps_partkey) |>
    summarise(min_ps_supplycost = min(ps_supplycost))

  sj <- inner_join(pspsnr, aggr,
                   by=c("ps_partkey" = "ps_partkey", "ps_supplycost" = "min_ps_supplycost"))


  res <- sj |>
    select(s_acctbal, s_name, n_name, ps_partkey, p_mfgr,
           s_address, s_phone, s_comment) |>
    # TODO
    #arrange(desc(s_acctbal), n_name, s_name, ps_partkey) |>
    arrange(s_acctbal, n_name, s_name, ps_partkey) |>

    head(100)

  res
}

test_dplyr_q[[3]] <- function() {
  oc <- inner_join(
    orders |>
      select(o_orderkey, o_custkey, o_orderdate, o_shippriority) |>
      filter(o_orderdate < as.Date("1995-03-15")),
    customer |>
      select(c_custkey, c_mktsegment) |>
      filter(c_mktsegment == "BUILDING"),
    by = c("o_custkey" = "c_custkey")
  ) |>
    select(o_orderkey, o_orderdate, o_shippriority)

  loc <- inner_join(
    lineitem |>
      select(l_orderkey, l_shipdate, l_extendedprice, l_discount) |>
      filter(l_shipdate > as.Date("1995-03-15")) |>
      select(l_orderkey, l_extendedprice, l_discount),
    oc, by = c("l_orderkey" = "o_orderkey")
  )

  aggr <- loc |> mutate(volume=l_extendedprice * (1 - l_discount)) |>
    group_by(l_orderkey, o_orderdate, o_shippriority) |>
    summarise(revenue = sum(volume)) |>
    select(l_orderkey, revenue, o_orderdate, o_shippriority) |>
    #arrange(desc(revenue), o_orderdate) |>
    arrange(revenue, o_orderdate) |>
    head(10)
  aggr
}

test_dplyr_q[[4]] <- function() {
  l <- lineitem |>
    select(l_orderkey, l_commitdate, l_receiptdate) |>
    filter(l_commitdate < l_receiptdate) |>
    select(l_orderkey)

  o <- orders |>
    select(o_orderkey, o_orderdate, o_orderpriority) |>
    filter(o_orderdate >= as.Date("1993-07-01"), o_orderdate < as.Date("1993-10-01")) |>
    select(o_orderkey, o_orderpriority)

  # distinct after join, tested and indeed faster
  lo <- inner_join(l, o, by = c("l_orderkey" = "o_orderkey")) |>
    distinct() |>
    select(o_orderpriority)

  aggr <- lo |>
    group_by(o_orderpriority) |>
    summarise(order_count = n()) |>
    arrange(o_orderpriority)

  aggr
}

test_dplyr_q[[5]] <- function() {
  nr <- inner_join(
    nation |>
      select(n_nationkey, n_regionkey, n_name),
    region |>
      select(r_regionkey, r_name) |>
      filter(r_name == "ASIA"),
    by = c("n_regionkey" = "r_regionkey")
  ) |>
    select(n_nationkey, n_name)

  snr <- inner_join(
    supplier |>
      select(s_suppkey, s_nationkey),
    nr,
    by = c("s_nationkey" = "n_nationkey")
  ) |>
    select(s_suppkey, s_nationkey, n_name)

  lsnr <- inner_join(
    lineitem |> select(l_suppkey, l_orderkey, l_extendedprice, l_discount),
    snr, by = c("l_suppkey" = "s_suppkey"))

  o <- orders |>
    select(o_orderdate, o_orderkey, o_custkey) |>
    filter(o_orderdate >= as.Date("1994-01-01"), o_orderdate < as.Date("1995-01-01")) |>
    select(o_orderkey, o_custkey)

  oc <- inner_join(o, customer |> select(c_custkey, c_nationkey),
                   by = c("o_custkey" = "c_custkey")) |>
    select(o_orderkey, c_nationkey)

  lsnroc <- inner_join(lsnr, oc,
                       by = c("l_orderkey" = "o_orderkey", "s_nationkey" = "c_nationkey")) |>
    select(l_extendedprice, l_discount, n_name)

  aggr <- lsnroc |>
    mutate(volume=l_extendedprice * (1 - l_discount)) |>
    group_by(n_name) |>
    summarise(revenue = sum(volume)) |>
    #arrange(desc(revenue)) # TODO
    arrange(revenue)

  aggr
}

test_dplyr_q[[6]] <- function() {
  lineitem |>
    select(l_shipdate, l_extendedprice, l_discount, l_quantity) |>
    filter(l_shipdate >= as.Date("1994-01-01"),
           l_shipdate < as.Date("1995-01-01"),
           l_discount >= 0.05,
           l_discount <= 0.07,
           l_quantity < 24) |>
    select(l_extendedprice, l_discount) |>
    summarise(revenue = sum(l_extendedprice * l_discount))
}

test_dplyr_q[[7]] <- function() {
  sn <- inner_join(
    supplier |>
      select(s_nationkey, s_suppkey),
    nation |>
      select(n1_nationkey = n_nationkey, n1_name = n_name) |>
      #filter(n1_name %in% c("FRANCE", "GERMANY")),  TODO
      filter(n1_name == "FRANCE" | n1_name == "GERMANY"),
    by = c("s_nationkey" = "n1_nationkey")) |>
    select(s_suppkey, n1_name)

  cn <- inner_join(
    customer |>
      select(c_custkey, c_nationkey),
    nation |>
      select(n2_nationkey = n_nationkey, n2_name = n_name) |>
      #filter(n2_name %in% c("FRANCE", "GERMANY")),
      filter(n2_name == "FRANCE" | n2_name == "GERMANY"),
    by = c("c_nationkey" = "n2_nationkey")) |>
    select(c_custkey, n2_name)

  cno <- inner_join(
    orders |>
      select(o_custkey, o_orderkey),
    cn, by = c("o_custkey" = "c_custkey")) |>
    select(o_orderkey, n2_name)

  cnol <- inner_join(
    lineitem |>
      select(l_orderkey, l_suppkey, l_shipdate, l_extendedprice, l_discount) |>
      filter(l_shipdate >= as.Date("1995-01-01"), l_shipdate <= as.Date("1996-12-31")),
    cno,
    by = c("l_orderkey" = "o_orderkey")) |>
    select(l_suppkey, l_shipdate, l_extendedprice, l_discount, n2_name)

  all <- inner_join(cnol, sn, by = c("l_suppkey" = "s_suppkey"))

  aggr <- all |>
    filter((n1_name == "FRANCE" & n2_name == "GERMANY") |
             (n1_name == "GERMANY" & n2_name == "FRANCE")) |>
    mutate(
      supp_nation = n1_name,
      cust_nation = n2_name,
      l_year = as.integer(strftime(l_shipdate, "%Y")),
      volume = l_extendedprice * (1 - l_discount)) |>
    select(supp_nation, cust_nation, l_year, volume) |>
    group_by(supp_nation, cust_nation, l_year) |>
    summarise(revenue = sum(volume)) |>
    arrange(supp_nation, cust_nation, l_year)

  aggr
}

test_dplyr_q[[8]] <- function() {
  nr <- inner_join(
    nation |>
      select(n1_nationkey = n_nationkey, n1_regionkey = n_regionkey),
    region |>
      select(r_regionkey, r_name) |>
      filter(r_name == "AMERICA") |>
      select(r_regionkey),
    by = c("n1_regionkey" = "r_regionkey")) |>
    select(n1_nationkey)

  cnr <- inner_join(
    customer |>
      select(c_custkey, c_nationkey),
    nr, by = c("c_nationkey" = "n1_nationkey")) |>
    select(c_custkey)

  ocnr <- inner_join(
    orders |>
      select(o_orderkey, o_custkey, o_orderdate) |>
      filter(o_orderdate >= as.Date("1995-01-01"), o_orderdate <= as.Date("1996-12-31")),
    cnr, by = c("o_custkey" = "c_custkey")) |>
    select(o_orderkey, o_orderdate)

  locnr <- inner_join(
    lineitem |>
      select(l_orderkey, l_partkey, l_suppkey, l_extendedprice, l_discount),
    ocnr, by=c("l_orderkey" = "o_orderkey")) |>
    select(l_partkey, l_suppkey, l_extendedprice, l_discount, o_orderdate)

  locnrp <- inner_join(locnr,
                       part |>
                         select(p_partkey, p_type) |>
                         filter(p_type == "ECONOMY ANODIZED STEEL") |>
                         select(p_partkey),
                       by = c("l_partkey" = "p_partkey")) |>
    select(l_suppkey, l_extendedprice, l_discount, o_orderdate)

  locnrps <- inner_join(locnrp,
                        supplier |>
                          select(s_suppkey, s_nationkey),
                        by = c("l_suppkey" = "s_suppkey")) |>
    select(l_extendedprice, l_discount, o_orderdate, s_nationkey)

  all <- inner_join(locnrps,
                    nation |>
                      select(n2_nationkey = n_nationkey, n2_name = n_name),
                    by = c("s_nationkey" = "n2_nationkey")) |>
    select(l_extendedprice, l_discount, o_orderdate, n2_name)

  aggr <- all |>
    mutate(
      o_year = as.integer(strftime(o_orderdate, "%Y")),
      volume = l_extendedprice * (1 - l_discount),
      nation = n2_name) |>
    select(o_year, volume, nation) |>
    group_by(o_year) |>
    summarise(mkt_share = sum(ifelse(nation == "BRAZIL", volume, 0)) / sum(volume)) |>
    arrange(o_year)
  aggr
}

test_dplyr_q[[9]] <- function() {
  p <- part |>
    select(p_name, p_partkey) |>
    filter(grepl("green", p_name)) |>
    select(p_partkey)

  psp <- inner_join(
    partsupp |>
      select(ps_suppkey, ps_partkey, ps_supplycost),
    p, by = c("ps_partkey" = "p_partkey"))

  sn <- inner_join(
    supplier |>
      select(s_suppkey, s_nationkey),
    nation |>
      select(n_nationkey, n_name),
    by = c("s_nationkey" = "n_nationkey")) |>
    select(s_suppkey, n_name)

  pspsn <- inner_join(psp, sn, by = c("ps_suppkey" = "s_suppkey"))

  lpspsn <- inner_join(
    lineitem |>
      select(l_suppkey, l_partkey, l_orderkey, l_extendedprice, l_discount, l_quantity),
    pspsn,
    by = c("l_suppkey" = "ps_suppkey", "l_partkey" = "ps_partkey")) |>
    select(l_orderkey, l_extendedprice, l_discount, l_quantity, ps_supplycost, n_name)

  all <- inner_join(
    orders |>
      select(o_orderkey, o_orderdate),
    lpspsn,
    by = c("o_orderkey"= "l_orderkey" )) |>
    select(l_extendedprice, l_discount, l_quantity, ps_supplycost, n_name, o_orderdate)

  aggr <- all |>
    mutate(
      nation = n_name,
      o_year = as.integer(strftime(o_orderdate, "%Y")),
      amount = l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity) |>
    select(nation, o_year, amount) |>
    group_by(nation, o_year) |>
    summarise(sum_profit = sum(amount)) |>
    #arrange(nation, desc(o_year)) TODO
    arrange(nation, o_year)

  aggr
}

test_dplyr_q[[10]] <- function() {
  l <- lineitem |>
    select(l_orderkey, l_returnflag, l_extendedprice, l_discount) |>
    filter(l_returnflag == "R") |>
    select(l_orderkey, l_extendedprice, l_discount)

  o <- orders |>
    select(o_orderkey, o_custkey, o_orderdate) |>
    filter(o_orderdate >= as.Date("1993-10-01"), o_orderdate < as.Date("1994-01-01")) |>
    select(o_orderkey, o_custkey)

  lo <- inner_join(l, o,
                   by = c("l_orderkey" = "o_orderkey")) |>
    select(l_extendedprice, l_discount, o_custkey)
  # first aggregate, then join with customer/nation,
  # otherwise we need to aggr over lots of cols

  lo_aggr <- lo |> mutate(volume=l_extendedprice * (1 - l_discount)) |>
    group_by(o_custkey) |>
    summarise(revenue = sum(volume))

  c <- customer |>
    select(c_custkey, c_nationkey, c_name, c_acctbal, c_phone, c_address, c_comment)

  loc <- inner_join(lo_aggr, c, by = c("o_custkey" = "c_custkey"))

  locn <- inner_join(loc, nation |> select(n_nationkey, n_name),
                     by = c("c_nationkey" = "n_nationkey"))

  res <- locn |>
    select(o_custkey, c_name, revenue, c_acctbal, n_name,
           c_address, c_phone, c_comment) |>
    #arrange(desc(revenue)) |> TODO
    arrange(revenue) |>

    head(20)

  res
}



res <- list()

for (q in seq_along(test_dplyr_q)) {
  f <- test_dplyr_q[[q]]
  cold <- as.data.frame(f())
  time <- system.time(as.data.frame(f()))[[3]]
  print(q)
  print(time)
  res[[q]] <- data.frame(pkg=pkg, q=q, time = time)
}

df <- do.call(rbind, res)
write.csv(df, paste0("res-", pkg, ".csv"))

