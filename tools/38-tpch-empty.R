pkgload::load_all()

Sys.setenv(DUCKPLYR_FORCE = TRUE)
Sys.setenv(DUCKPLYR_EXPERIMENTAL = FALSE)
Sys.setenv(DUCKPLYR_META_SKIP = FALSE)

# Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)

qloadm("tools/tpch/001.qs")

# prep_fun <- function(x) as_duckplyr_df(x)
prep_fun <- function(x) as_duckplyr_df(x[0, ])

customer <- prep_fun(customer)
lineitem <- prep_fun(lineitem)
nation <- prep_fun(nation)
orders <- prep_fun(orders)
part <- prep_fun(part)
partsupp <- prep_fun(partsupp)
region <- prep_fun(region)
supplier <- prep_fun(supplier)

run <- function(x) { force(x); invisible() }

res <- bench::mark(
  run(tpch_01()),
  run(tpch_02()),
  run(tpch_03()),
  run(tpch_04()),
  run(tpch_05()),
  run(tpch_06()),
  run(tpch_07()),
  run(tpch_08()),
  run(tpch_09()),
  run(tpch_10()),
  run(tpch_11()),
  run(tpch_12()),
  run(tpch_13()),
  run(tpch_14()),
  run(tpch_15()),
  run(tpch_16()),
  run(tpch_17()),
  run(tpch_18()),
  run(tpch_19()),
  run(tpch_20()),
  run(tpch_21()),
  run(tpch_22()),
  invisible(NULL)
)

res |>
  arrange(desc(median))

# profvis::profvis(for (i in 1:20) run(tpch_08()))
#
# rel_stats_clean()
# run(tpch_08())
# rel_stats_get()
