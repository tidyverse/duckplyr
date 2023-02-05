library(duckdb)
library(rlang)
library(magrittr)

con <- dbConnect(duckdb())


# relational --------------------------------------------------------------


# Define < operator
dbExecute(con, 'CREATE MACRO "<"(a, b) AS a < b')

# Define mutate() expression
all_columns <- purrr::map(names(nycflights13::flights), duckdb:::expr_reference)
concat_expr <- duckdb:::expr_function("concat", list(
  duckdb:::expr_reference("origin"),
  duckdb:::expr_constant("-"),
  duckdb:::expr_reference("dest")
))
duckdb:::expr_set_alias(concat_expr, "rel")

# Define summarize() expression
mean_arr_delay_expr <- duckdb:::expr_function("avg", list(duckdb:::expr_reference("arr_delay")))
duckdb:::expr_set_alias(mean_arr_delay_expr, "mean_arr_delay")

rel_result <-
  duckdb:::rel_from_df(con, nycflights13::flights) %>%
  duckdb:::rel_project(list2(!!!all_columns, concat_expr)) %>%
  duckdb:::rel_filter(list(duckdb:::expr_function("<", list(duckdb:::expr_reference("dep_time"), duckdb:::expr_constant(1000L))))) %>%
  duckdb:::rel_aggregate(list(duckdb:::expr_reference("rel")), list(mean_arr_delay_expr)) %>%
  duckdb:::rel_order(list(duckdb:::expr_function("-", list(duckdb:::expr_reference("mean_arr_delay")))))

rel_result

rel_result %>%
  as.data.frame()


# dbplyr ------------------------------------------------------------------

library(tidyverse)

duckdb_register(con, "flights", nycflights13::flights)

dbplyr_result <-
  dplyr::tbl(con, "flights") %>%
  mutate(rel = paste0(origin, "-", dest)) %>%
  filter(dep_time < 1000) %>%
  group_by(rel) %>%
  summarize(mean_arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(mean_arr_delay))

dbplyr_result %>%
  show_query()

dbplyr_result
