tpc_h11 <- function() {
  nation <- nation |>
    duckplyr_filter(n_name == "GERMANY")

  joined_filtered <- partsupp |>
    duckplyr_inner_join(supplier, by = c("ps_suppkey" = "s_suppkey")) |>
    duckplyr_inner_join(nation, by = c("s_nationkey" = "n_nationkey"))

  global_agr <- joined_filtered |>
    duckplyr_summarise(
      global_value = sum(ps_supplycost * ps_availqty) * 0.0001000000
    ) |>
    duckplyr_mutate(global_agr_key = 1L)

  partkey_agr <- joined_filtered |>
    group_by(ps_partkey) |>
    duckplyr_summarise(value = sum(ps_supplycost * ps_availqty))

  partkey_agr |>
    duckplyr_mutate(global_agr_key = 1L) |>
    duckplyr_inner_join(global_agr, by = "global_agr_key") |>
    duckplyr_filter(value > global_value) |>
    duckplyr_arrange(desc(value)) |>
    duckplyr_select(ps_partkey, value) |>
    collect()
}

tpc_h12 <- function() {
  lineitem |>
    duckplyr_filter(
      l_shipmode %in% c("MAIL", "SHIP"),
      l_commitdate < l_receiptdate,
      l_shipdate < l_commitdate,
      l_receiptdate >= as.Date("1994-01-01"),
      l_receiptdate < as.Date("1995-01-01")
    ) |>
    duckplyr_inner_join(
      orders,
      by = c("l_orderkey" = "o_orderkey")
    ) |>
    group_by(l_shipmode) |>
    duckplyr_summarise(
      high_line_count = sum(
        if_else(
          (o_orderpriority == "1-URGENT") | (o_orderpriority == "2-HIGH"),
          1L,
          0L
        )
      ),
      low_line_count = sum(
        if_else(
          (o_orderpriority != "1-URGENT") & (o_orderpriority != "2-HIGH"),
          1L,
          0L
        )
      )
    ) |>
    ungroup() |>
    duckplyr_arrange(l_shipmode) |>
    collect()
}

tpc_h13 <- function() {
  c_orders <- customer |>
    duckplyr_left_join(
      orders |>
        duckplyr_filter(!grepl("special.*?requests", o_comment)),
      by = c("c_custkey" = "o_custkey")
    ) |>
    group_by(c_custkey) |>
    duckplyr_summarise(
      c_count = sum(!is.na(o_orderkey))
    )

  c_orders |>
    group_by(c_count) |>
    duckplyr_summarise(custdist = n()) |>
    ungroup() |>
    duckplyr_arrange(desc(custdist), desc(c_count)) |>
    collect()
}

tpc_h14 <- function() {
  lineitem |>
    duckplyr_filter(
      l_shipdate >= as.Date("1995-01-01"),
      l_shipdate < as.Date("1995-10-01")
    ) |>
    duckplyr_inner_join(part, by = c("l_partkey" = "p_partkey")) |>
    duckplyr_summarise(
      promo_revenue = 100 * sum(
        if_else(grepl("^PROMO", p_type), l_extendedprice * (1 - l_discount), 0)
      ) / sum(l_extendedprice * (1 - l_discount))
    ) |>
    collect()
}

tpc_h15 <- function() {
  revenue_by_supplier <- lineitem |>
    duckplyr_filter(
      l_shipdate >= as.Date("1996-01-01"),
      l_shipdate < as.Date("1996-04-01")
    ) |>
    group_by(l_suppkey) |>
    duckplyr_summarise(
      total_revenue = sum(l_extendedprice * (1 - l_discount))
    )

  global_revenue <- revenue_by_supplier |>
    duckplyr_mutate(global_agr_key = 1L) |>
    group_by(global_agr_key) |>
    duckplyr_summarise(
      max_total_revenue = max(total_revenue)
    )

  revenue_by_supplier |>
    duckplyr_mutate(global_agr_key = 1L) |>
    duckplyr_inner_join(global_revenue, by = "global_agr_key") |>
    duckplyr_filter(abs(total_revenue - max_total_revenue) < 1e-9) |>
    duckplyr_inner_join(supplier, by = c("l_suppkey" = "s_suppkey")) |>
    duckplyr_select(s_suppkey = l_suppkey, s_name, s_address, s_phone, total_revenue) |>
    collect()
}


tpc_h16 <- function() {
  part_filtered <- part |>
    duckplyr_filter(
      p_brand != "Brand#45",
      !grepl("^MEDIUM POLISHED", p_type),
      p_size %in% c(49, 14, 23, 45, 19, 3, 36, 9)
    )

  supplier_filtered <- supplier |>
    duckplyr_filter(!grepl("Customer.*?Complaints", s_comment))

  partsupp_filtered <- partsupp |>
    duckplyr_inner_join(supplier_filtered, by = c("ps_suppkey" = "s_suppkey")) |>
    duckplyr_select(ps_partkey, ps_suppkey)

  part_filtered |>
    duckplyr_inner_join(partsupp_filtered, by = c("p_partkey" = "ps_partkey")) |>
    group_by(p_brand, p_type, p_size) |>
    duckplyr_summarise(supplier_cnt = n_distinct(ps_suppkey)) |>
    ungroup() |>
    duckplyr_select(p_brand, p_type, p_size, supplier_cnt) |>
    duckplyr_arrange(desc(supplier_cnt), p_brand, p_type, p_size) |>
    collect()
}

tpc_h17 <- function() {
  parts_filtered <- part |>
    duckplyr_filter(
      p_brand == "Brand#23",
      p_container == "MED BOX"
    )

  joined <- lineitem |>
    duckplyr_inner_join(parts_filtered, by = c("l_partkey" = "p_partkey"))

  quantity_by_part <- joined |>
    group_by(l_partkey) |>
    duckplyr_summarise(quantity_threshold = 0.2 * mean(l_quantity))

  joined |>
    duckplyr_inner_join(quantity_by_part, by = "l_partkey") |>
    duckplyr_filter(l_quantity < quantity_threshold) |>
    duckplyr_summarise(avg_yearly = sum(l_extendedprice) / 7.0) |>
    collect()
}

tpc_h18 <- function() {
  big_orders <- lineitem |>
    group_by(l_orderkey) |>
    duckplyr_summarise(`sum(l_quantity)` = sum(l_quantity)) |>
    duckplyr_filter(`sum(l_quantity)` > 300)

  orders |>
    duckplyr_inner_join(big_orders, by = c("o_orderkey" = "l_orderkey")) |>
    duckplyr_inner_join(customer, by = c("o_custkey" = "c_custkey")) |>
    duckplyr_select(
      c_name,
      c_custkey = o_custkey, o_orderkey,
      o_orderdate, o_totalprice, `sum(l_quantity)`
    ) |>
    duckplyr_arrange(desc(o_totalprice), o_orderdate) |>
    head(100) |>
    collect()
}

tpc_h19 <- function() {
  joined <- lineitem |>
    duckplyr_inner_join(part, by = c("l_partkey" = "p_partkey"))

  result <- joined |>
    duckplyr_filter(
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
    duckplyr_summarise(
      revenue = sum(l_extendedprice * (1 - l_discount))
    ) |>
    collect()
}

tpc_h20 <- function() {
  supplier_ca <- supplier |>
    duckplyr_inner_join(
      nation |> duckplyr_filter(n_name == "CANADA"),
      by = c("s_nationkey" = "n_nationkey")
    ) |>
    duckplyr_select(s_suppkey, s_name, s_address)

  part_forest <- part |>
    duckplyr_filter(grepl("^forest", p_name))

  partsupp_forest_ca <- partsupp |>
    duckplyr_semi_join(supplier_ca, c("ps_suppkey" = "s_suppkey")) |>
    duckplyr_semi_join(part_forest, by = c("ps_partkey" = "p_partkey"))

  qty_threshold <- lineitem |>
    duckplyr_filter(
      l_shipdate >= as.Date("1994-01-01"),
      l_shipdate < as.Date("1995-01-01")
    ) |>
    duckplyr_semi_join(partsupp_forest_ca, by = c("l_partkey" = "ps_partkey", "l_suppkey" = "ps_suppkey")) |>
    group_by(l_suppkey) |>
    duckplyr_summarise(qty_threshold = 0.5 * sum(l_quantity))

  partsupp_forest_ca_filtered <- partsupp_forest_ca |>
    duckplyr_inner_join(
      qty_threshold,
      by = c("ps_suppkey" = "l_suppkey")
    ) |>
    duckplyr_filter(ps_availqty > qty_threshold)

  supplier_ca |>
    duckplyr_semi_join(partsupp_forest_ca_filtered, by = c("s_suppkey" = "ps_suppkey")) |>
    duckplyr_select(s_name, s_address) |>
    duckplyr_arrange(s_name) |>
    collect()
}

tpc_h21 <- function() {
  orders_with_more_than_one_supplier <- lineitem |>
    group_by(l_orderkey) |>
    duckplyr_count(l_suppkey) |>
    group_by(l_orderkey) |>
    duckplyr_summarise(n_supplier = n()) |>
    duckplyr_filter(n_supplier > 1)

  line_items_needed <- lineitem |>
    duckplyr_semi_join(orders_with_more_than_one_supplier) |>
    duckplyr_inner_join(orders, by = c("l_orderkey" = "o_orderkey")) |>
    duckplyr_filter(o_orderstatus == "F") |>
    group_by(l_orderkey, l_suppkey) |>
    duckplyr_summarise(failed_delivery_commit = any(l_receiptdate > l_commitdate)) |>
    group_by(l_orderkey) |>
    duckplyr_summarise(n_supplier = n(), num_failed = sum(failed_delivery_commit)) |>
    duckplyr_filter(n_supplier > 1 & num_failed == 1)

  line_items <- lineitem |>
    duckplyr_semi_join(line_items_needed)

  supplier |>
    duckplyr_inner_join(line_items, by = c("s_suppkey" = "l_suppkey")) |>
    duckplyr_filter(l_receiptdate > l_commitdate) |>
    duckplyr_inner_join(nation, by = c("s_nationkey" = "n_nationkey")) |>
    duckplyr_filter(n_name == "SAUDI ARABIA") |>
    group_by(s_name) |>
    duckplyr_summarise(numwait = n()) |>
    ungroup() |>
    duckplyr_arrange(desc(numwait), s_name) |>
    head(100) |>
    collect()
}

tpc_h22 <- function() {
  acctbal_mins <- customer |>
    duckplyr_filter(
      substr(c_phone, 1, 2) %in% c("13", "31", "23", "29", "30", "18", "17") &
        c_acctbal > 0
    ) |>
    duckplyr_summarise(acctbal_min = mean(c_acctbal, na.rm = TRUE), join_id = 1L)

  customer |>
    duckplyr_mutate(cntrycode = substr(c_phone, 1, 2), join_id = 1L) |>
    duckplyr_left_join(acctbal_mins, by = "join_id") |>
    duckplyr_filter(
      cntrycode %in% c("13", "31", "23", "29", "30", "18", "17") &
        c_acctbal > acctbal_min
    ) |>
    anti_join(orders, by = c("c_custkey" = "o_custkey")) |>
    duckplyr_select(cntrycode, c_acctbal) |>
    group_by(cntrycode) |>
    duckplyr_summarise(
      numcust = n(),
      totacctbal = sum(c_acctbal)
    ) |>
    ungroup() |>
    duckplyr_arrange(cntrycode) |>
    collect()
}
