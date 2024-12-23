# Generated by 70-touchstone-gen.R, do not edit by hand

library(touchstone)

source("tools/30-tpch-export.R")
source("tools/31-tpch-load-qs.R")

branch_install()

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_01` = collect(duckplyr:::tpch_01()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_02` = collect(duckplyr:::tpch_02()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_03` = collect(duckplyr:::tpch_03()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_04` = collect(duckplyr:::tpch_04()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_05` = collect(duckplyr:::tpch_05()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_06` = collect(duckplyr:::tpch_06()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_07` = collect(duckplyr:::tpch_07()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_08` = collect(duckplyr:::tpch_08()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_09` = collect(duckplyr:::tpch_09()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_10` = collect(duckplyr:::tpch_10()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_11` = collect(duckplyr:::tpch_11()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_12` = collect(duckplyr:::tpch_12()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_13` = collect(duckplyr:::tpch_13()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_14` = collect(duckplyr:::tpch_14()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_15` = collect(duckplyr:::tpch_15()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_16` = collect(duckplyr:::tpch_16()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_17` = collect(duckplyr:::tpch_17()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_18` = collect(duckplyr:::tpch_18()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_19` = collect(duckplyr:::tpch_19()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_20` = collect(duckplyr:::tpch_20()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_21` = collect(duckplyr:::tpch_21()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/100.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `100_tpch_22` = collect(duckplyr:::tpch_22()),
  n = 3
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_01` = collect(duckplyr:::tpch_01()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_02` = collect(duckplyr:::tpch_02()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_03` = collect(duckplyr:::tpch_03()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_04` = collect(duckplyr:::tpch_04()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_05` = collect(duckplyr:::tpch_05()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_06` = collect(duckplyr:::tpch_06()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_07` = collect(duckplyr:::tpch_07()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_08` = collect(duckplyr:::tpch_08()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_09` = collect(duckplyr:::tpch_09()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_10` = collect(duckplyr:::tpch_10()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_11` = collect(duckplyr:::tpch_11()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_12` = collect(duckplyr:::tpch_12()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_13` = collect(duckplyr:::tpch_13()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_14` = collect(duckplyr:::tpch_14()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_15` = collect(duckplyr:::tpch_15()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_16` = collect(duckplyr:::tpch_16()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_17` = collect(duckplyr:::tpch_17()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_18` = collect(duckplyr:::tpch_18()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_19` = collect(duckplyr:::tpch_19()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_20` = collect(duckplyr:::tpch_20()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_21` = collect(duckplyr:::tpch_21()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/010.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `010_tpch_22` = collect(duckplyr:::tpch_22()),
  n = 10
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_01` = collect(duckplyr:::tpch_01()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_02` = collect(duckplyr:::tpch_02()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_03` = collect(duckplyr:::tpch_03()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_04` = collect(duckplyr:::tpch_04()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_05` = collect(duckplyr:::tpch_05()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_06` = collect(duckplyr:::tpch_06()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_07` = collect(duckplyr:::tpch_07()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_08` = collect(duckplyr:::tpch_08()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_09` = collect(duckplyr:::tpch_09()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_10` = collect(duckplyr:::tpch_10()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_11` = collect(duckplyr:::tpch_11()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_12` = collect(duckplyr:::tpch_12()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_13` = collect(duckplyr:::tpch_13()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_14` = collect(duckplyr:::tpch_14()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_15` = collect(duckplyr:::tpch_15()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_16` = collect(duckplyr:::tpch_16()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_17` = collect(duckplyr:::tpch_17()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_18` = collect(duckplyr:::tpch_18()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_19` = collect(duckplyr:::tpch_19()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_20` = collect(duckplyr:::tpch_20()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_21` = collect(duckplyr:::tpch_21()),
  n = 30
)

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duck_tbl(customer)
    lineitem <- as_duck_tbl(lineitem)
    nation <- as_duck_tbl(nation)
    orders <- as_duck_tbl(orders)
    part <- as_duck_tbl(part)
    partsupp <- as_duck_tbl(partsupp)
    region <- as_duck_tbl(region)
    supplier <- as_duck_tbl(supplier)
  },
  `001_tpch_22` = collect(duckplyr:::tpch_22()),
  n = 30
)
benchmark_analyze()
