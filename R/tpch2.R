#' @autoglobal
tpch_11 <- function() {
  nation <- nation |>
    filter(n_name == "GERMANY")

  joined_filtered <- partsupp |>
    inner_join(na_matches = TPCH_NA_MATCHES, supplier, by = c("ps_suppkey" = "s_suppkey")) |>
    inner_join(na_matches = TPCH_NA_MATCHES, nation, by = c("s_nationkey" = "n_nationkey"))

  global_agr <- joined_filtered |>
    summarise(
      global_value = sum(ps_supplycost * ps_availqty) * 0.0001000000
    ) |>
    mutate(global_agr_key = 1L)

  partkey_agr <- joined_filtered |>
    summarise(
      value = sum(ps_supplycost * ps_availqty),
      .by = ps_partkey
    )

  partkey_agr |>
    mutate(global_agr_key = 1L) |>
    inner_join(na_matches = TPCH_NA_MATCHES, global_agr, by = "global_agr_key") |>
    filter(value > global_value) |>
    arrange(desc(value)) |>
    select(ps_partkey, value)
}

#' @autoglobal
tpch_12 <- function() {
  lineitem |>
    filter(
      l_shipmode %in% c("MAIL", "SHIP"),
      l_commitdate < l_receiptdate,
      l_shipdate < l_commitdate,
      l_receiptdate >= !!as.Date("1994-01-01"),
      l_receiptdate < !!as.Date("1995-01-01")
    ) |>
    inner_join(na_matches = TPCH_NA_MATCHES,
      orders,
      by = c("l_orderkey" = "o_orderkey")
    ) |>
    summarise(
      high_line_count = sum(
        ifelse(
          (o_orderpriority == "1-URGENT") | (o_orderpriority == "2-HIGH"),
          1L,
          0L
        )
      ),
      low_line_count = sum(
        ifelse(
          (o_orderpriority != "1-URGENT") & (o_orderpriority != "2-HIGH"),
          1L,
          0L
        )
      ),
      .by = l_shipmode
    ) |>
    arrange(l_shipmode)
}

#' @autoglobal
tpch_13 <- function() {
  c_orders <- customer |>
    left_join(na_matches = TPCH_NA_MATCHES,
      orders |>
        filter(!grepl("special.*?requests", o_comment)),
      by = c("c_custkey" = "o_custkey")
    ) |>
    summarise(
      # FIXME: sum(!is.na(o_orderkey))
      c_count = sum(ifelse(is.na(o_orderkey), 0L, 1L)),
      .by = c_custkey
    )

  c_orders |>
    summarise(custdist = n(), .by = c_count) |>
    arrange(desc(custdist), desc(c_count))
}

#' @autoglobal
tpch_14 <- function() {
  lineitem |>
    filter(
      l_shipdate >= !!as.Date("1995-09-01"),
      l_shipdate < !!as.Date("1995-10-01")
    ) |>
    inner_join(na_matches = TPCH_NA_MATCHES, part, by = c("l_partkey" = "p_partkey")) |>
    summarise(
      promo_revenue = 100 * sum(
        ifelse(grepl("^PROMO", p_type), l_extendedprice * (1 - l_discount), 0)
      ) / sum(l_extendedprice * (1 - l_discount))
    )
}

#' @autoglobal
tpch_15 <- function() {
  revenue_by_supplier <- lineitem |>
    filter(
      l_shipdate >= !!as.Date("1996-01-01"),
      l_shipdate < !!as.Date("1996-04-01")
    ) |>
    summarise(
      total_revenue = sum(l_extendedprice * (1 - l_discount)),
      .by = l_suppkey
    )

  global_revenue <- revenue_by_supplier |>
    mutate(global_agr_key = 1L) |>
    summarise(
      max_total_revenue = max(total_revenue),
      .by = global_agr_key
    )

  revenue_by_supplier |>
    mutate(global_agr_key = 1L) |>
    inner_join(na_matches = TPCH_NA_MATCHES, global_revenue, by = "global_agr_key") |>
    filter(abs(total_revenue - max_total_revenue) < 1e-9) |>
    inner_join(na_matches = TPCH_NA_MATCHES, supplier, by = c("l_suppkey" = "s_suppkey")) |>
    select(s_suppkey = l_suppkey, s_name, s_address, s_phone, total_revenue)
}


#' @autoglobal
tpch_16 <- function() {
  part_filtered <- part |>
    filter(
      p_brand != "Brand#45",
      !grepl("^MEDIUM POLISHED", p_type),
      p_size %in% c(49, 14, 23, 45, 19, 3, 36, 9)
    )

  supplier_filtered <- supplier |>
    filter(!grepl("Customer.*?Complaints", s_comment))

  partsupp_filtered <- partsupp |>
    inner_join(na_matches = TPCH_NA_MATCHES, supplier_filtered, by = c("ps_suppkey" = "s_suppkey")) |>
    select(ps_partkey, ps_suppkey)

  part_filtered |>
    inner_join(na_matches = TPCH_NA_MATCHES, partsupp_filtered, by = c("p_partkey" = "ps_partkey")) |>
    summarise(
      supplier_cnt = n_distinct(ps_suppkey),
      .by = c(p_brand, p_type, p_size)
    ) |>
    select(p_brand, p_type, p_size, supplier_cnt) |>
    arrange(desc(supplier_cnt), p_brand, p_type, p_size)
}

#' @autoglobal
tpch_17 <- function() {
  parts_filtered <- part |>
    filter(
      p_brand == "Brand#23",
      p_container == "MED BOX"
    )

  joined <- lineitem |>
    inner_join(na_matches = TPCH_NA_MATCHES, parts_filtered, by = c("l_partkey" = "p_partkey"))

  quantity_by_part <- joined |>
    summarise(quantity_threshold = 0.2 * mean(l_quantity), .by = l_partkey)

  joined |>
    inner_join(na_matches = TPCH_NA_MATCHES, quantity_by_part, by = "l_partkey") |>
    filter(l_quantity < quantity_threshold) |>
    summarise(avg_yearly = sum(l_extendedprice) / 7.0)
}

#' @autoglobal
tpch_18 <- function() {
  big_orders <- lineitem |>
    summarise(sum = sum(l_quantity), .by = l_orderkey) |>
    filter(sum > 300)

  orders |>
    inner_join(na_matches = TPCH_NA_MATCHES, big_orders, by = c("o_orderkey" = "l_orderkey")) |>
    inner_join(na_matches = TPCH_NA_MATCHES, customer, by = c("o_custkey" = "c_custkey")) |>
    select(
      c_name,
      c_custkey = o_custkey, o_orderkey,
      o_orderdate, o_totalprice, sum
    ) |>
    arrange(desc(o_totalprice), o_orderdate) |>
    head(100)
}

#' @autoglobal
tpch_19 <- function() {
  joined <- lineitem |>
    inner_join(na_matches = TPCH_NA_MATCHES, part, by = c("l_partkey" = "p_partkey"))

  result <- joined |>
    filter(
      (
        p_brand == "Brand#12" &
          p_container %in% c("SM CASE", "SM BOX", "SM PACK", "SM PKG") &
          l_quantity >= 1 &
          l_quantity <= (1 + 10) &
          p_size >= 1 &
          p_size <= 5 &
          l_shipmode %in% c("AIR", "AIR REG") &
          l_shipinstruct == "DELIVER IN PERSON"
      ) |
        (
          p_brand == "Brand#23" &
            p_container %in% c("MED BAG", "MED BOX", "MED PKG", "MED PACK") &
            l_quantity >= 10 &
            l_quantity <= (10 + 10) &
            p_size >= 1 &
            p_size <= 10 &
            l_shipmode %in% c("AIR", "AIR REG") &
            l_shipinstruct == "DELIVER IN PERSON"
        ) |
        (
          p_brand == "Brand#34" &
            p_container %in% c("LG CASE", "LG BOX", "LG PACK", "LG PKG") &
            l_quantity >= 20 &
            l_quantity <= (20 + 10) &
            p_size >= 1 &
            p_size <= 15 &
            l_shipmode %in% c("AIR", "AIR REG") &
            l_shipinstruct == "DELIVER IN PERSON"
        )
    )

  result |>
    summarise(
      revenue = sum(l_extendedprice * (1 - l_discount))
    )
}

#' @autoglobal
tpch_20 <- function() {
  supplier_ca <- supplier |>
    inner_join(na_matches = TPCH_NA_MATCHES,
      nation |> filter(n_name == "CANADA"),
      by = c("s_nationkey" = "n_nationkey")
    ) |>
    select(s_suppkey, s_name, s_address)

  part_forest <- part |>
    filter(grepl("^forest", p_name))

  partsupp_forest_ca <- partsupp |>
    semi_join(na_matches = TPCH_NA_MATCHES, supplier_ca, c("ps_suppkey" = "s_suppkey")) |>
    semi_join(na_matches = TPCH_NA_MATCHES, part_forest, by = c("ps_partkey" = "p_partkey"))

  qty_threshold <- lineitem |>
    filter(
      l_shipdate >= !!as.Date("1994-01-01"),
      l_shipdate < !!as.Date("1995-01-01")
    ) |>
    semi_join(na_matches = TPCH_NA_MATCHES, partsupp_forest_ca, by = c("l_partkey" = "ps_partkey", "l_suppkey" = "ps_suppkey")) |>
    summarise(qty_threshold = 0.5 * sum(l_quantity), .by = l_suppkey)

  partsupp_forest_ca_filtered <- partsupp_forest_ca |>
    inner_join(na_matches = TPCH_NA_MATCHES,
      qty_threshold,
      by = c("ps_suppkey" = "l_suppkey")
    ) |>
    filter(ps_availqty > qty_threshold)

  supplier_ca |>
    semi_join(na_matches = TPCH_NA_MATCHES, partsupp_forest_ca_filtered, by = c("s_suppkey" = "ps_suppkey")) |>
    select(s_name, s_address) |>
    arrange(s_name)
}

#' @autoglobal
tpch_21 <- function() {
  orders_with_more_than_one_supplier <- lineitem |>
    count(l_orderkey, l_suppkey) |>
    summarise(n_supplier = n(), .by = l_orderkey) |>
    filter(n_supplier > 1)

  line_items_needed <- lineitem |>
    semi_join(na_matches = TPCH_NA_MATCHES, orders_with_more_than_one_supplier, by = "l_orderkey") |>
    inner_join(na_matches = TPCH_NA_MATCHES, orders, by = c("l_orderkey" = "o_orderkey")) |>
    filter(o_orderstatus == "F") |>
    summarise(
      failed_delivery_commit = any(l_receiptdate > l_commitdate),
      .by = c(l_orderkey, l_suppkey)
    ) |>
    summarise(
      n_supplier = n(),
      num_failed = sum(ifelse(failed_delivery_commit, 1, 0)),
      .by = l_orderkey
    ) |>
    filter(n_supplier > 1 & num_failed == 1)

  line_items <- lineitem |>
    semi_join(na_matches = TPCH_NA_MATCHES, line_items_needed, by = "l_orderkey")

  supplier |>
    inner_join(na_matches = TPCH_NA_MATCHES, line_items, by = c("s_suppkey" = "l_suppkey")) |>
    filter(l_receiptdate > l_commitdate) |>
    inner_join(na_matches = TPCH_NA_MATCHES, nation, by = c("s_nationkey" = "n_nationkey")) |>
    filter(n_name == "SAUDI ARABIA") |>
    summarise(numwait = n(), .by = s_name) |>
    arrange(desc(numwait), s_name) |>
    head(100)
}

#' @autoglobal
tpch_22 <- function() {
  acctbal_mins <- customer |>
    filter(
      # FIXME: substr(c_phone, 1, 2)
      substr(c_phone, 1L, 2L) %in% c("13", "31", "23", "29", "30", "18", "17") &
        c_acctbal > 0
    ) |>
    # FIXME: mean(na.rm = TRUE)
    summarise(acctbal_min = mean(c_acctbal), join_id = 1L)

  customer |>
    # FIXME: substr(c_phone, 1, 2)
    mutate(cntrycode = substr(c_phone, 1L, 2L), join_id = 1L) |>
    left_join(na_matches = TPCH_NA_MATCHES, acctbal_mins, by = "join_id") |>
    filter(
      cntrycode %in% c("13", "31", "23", "29", "30", "18", "17") &
        c_acctbal > acctbal_min
    ) |>
    anti_join(na_matches = TPCH_NA_MATCHES, orders, by = c("c_custkey" = "o_custkey")) |>
    select(cntrycode, c_acctbal) |>
    summarise(
      numcust = n(),
      totacctbal = sum(c_acctbal),
      .by = cntrycode
    ) |>
    arrange(cntrycode)
}
