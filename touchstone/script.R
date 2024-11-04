library(touchstone)

source("tools/30-tpch-export.R")
source("tools/31-tpch-load-qs.R")

branch_install()

benchmark_run(
  expr_before_benchmark = {
    library(duckplyr)
    data <- qs::qread("tools/tpch/001.qs")
    .mapply(assign, list(names(data), data), list(pos = .GlobalEnv))

    customer <- as_duckplyr_df(customer)
    lineitem <- as_duckplyr_df(lineitem)
    nation <- as_duckplyr_df(nation)
    orders <- as_duckplyr_df(orders)
    part <- as_duckplyr_df(part)
    partsupp <- as_duckplyr_df(partsupp)
    region <- as_duckplyr_df(region)
    supplier <- as_duckplyr_df(supplier)
  },
  tpch_01 = nrow(duckplyr:::tpch_01()),
  n = 10
)

benchmark_analyze()
