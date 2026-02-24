# Package index

## Using duckplyr

- [`duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
  [`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
  [`is_duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
  : duckplyr data frames
- [`read_parquet_duckdb()`](https://duckplyr.tidyverse.org/reference/read_parquet_duckdb.md)
  : Read Parquet files using DuckDB
- [`read_csv_duckdb()`](https://duckplyr.tidyverse.org/reference/read_csv_duckdb.md)
  : Read CSV files using DuckDB
- [`read_json_duckdb()`](https://duckplyr.tidyverse.org/reference/read_json_duckdb.md)
  : Read JSON files using DuckDB
- [`read_file_duckdb()`](https://duckplyr.tidyverse.org/reference/read_file_duckdb.md)
  : Read files using DuckDB
- [`read_tbl_duckdb()`](https://duckplyr.tidyverse.org/reference/read_tbl_duckdb.md)
  **\[experimental\]** : Read a table from a DuckDB database file
- [`read_sql_duckdb()`](https://duckplyr.tidyverse.org/reference/read_sql_duckdb.md)
  **\[experimental\]** : Return SQL query as duckdb_tibble

## dplyr verbs

### Computing and materializing data

- [`compute(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/compute.duckplyr_df.md)
  : Compute results
- [`compute_parquet()`](https://duckplyr.tidyverse.org/reference/compute_parquet.md)
  : Compute results to a Parquet file
- [`compute_csv()`](https://duckplyr.tidyverse.org/reference/compute_csv.md)
  : Compute results to a CSV file
- [`as_tbl()`](https://duckplyr.tidyverse.org/reference/as_tbl.md)
  **\[experimental\]** : Convert a duckplyr frame to a dbplyr table
- [`collect(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/collect.duckplyr_df.md)
  : Force conversion to a data frame
- [`pull(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/pull.duckplyr_df.md)
  : Extract a single column
- [`explain(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/explain.duckplyr_df.md)
  : Explain details of a tbl

### Verbs that affect rows

- [`arrange(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/arrange.duckplyr_df.md)
  : Order rows using column values
- [`distinct(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/distinct.duckplyr_df.md)
  : Keep distinct/unique rows
- [`filter(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/filter.duckplyr_df.md)
  [`filter_out(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/filter.duckplyr_df.md)
  : Keep rows that match a condition
- [`slice_head(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/slice_head.duckplyr_df.md)
  : Subset rows using their positions
- [`head(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/head.duckplyr_df.md)
  : Return the First Parts of an Object

### Verbs that affect columns

- [`mutate(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/mutate.duckplyr_df.md)
  : Create, modify, and delete columns
- [`transmute(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/transmute.duckplyr_df.md)
  **\[superseded\]** : Create, modify, and delete columns
- [`select(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/select.duckplyr_df.md)
  : Keep or drop columns using their names and types
- [`rename(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/rename.duckplyr_df.md)
  : Rename columns
- [`relocate(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/relocate.duckplyr_df.md)
  : Change column order

### Grouping and summarising verbs

- [`count(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/count.duckplyr_df.md)
  : Count the observations in each group
- [`summarise(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/summarise.duckplyr_df.md)
  : Summarise each group down to one row

### Verbs that work with multiple tables

- [`left_join(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/left_join.duckplyr_df.md)
  : Left join
- [`right_join(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/right_join.duckplyr_df.md)
  : Right join
- [`inner_join(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/inner_join.duckplyr_df.md)
  : Inner join
- [`full_join(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/full_join.duckplyr_df.md)
  : Full join
- [`semi_join(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/semi_join.duckplyr_df.md)
  : Semi join
- [`anti_join(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/anti_join.duckplyr_df.md)
  : Anti join
- [`intersect(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/intersect.duckplyr_df.md)
  : Intersect
- [`union(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/union.duckplyr_df.md)
  : Union
- [`union_all(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/union_all.duckplyr_df.md)
  : Union of all
- [`setdiff(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/setdiff.duckplyr_df.md)
  : Set difference
- [`symdiff(`*`<duckplyr_df>`*`)`](https://duckplyr.tidyverse.org/reference/symdiff.duckplyr_df.md)
  : Symmetric difference

### Unsupported verbs

- [`unsupported`](https://duckplyr.tidyverse.org/reference/unsupported.md)
  : Verbs not implemented in duckplyr

## Using duckplyr for all data frames

- [`methods_overwrite()`](https://duckplyr.tidyverse.org/reference/methods_overwrite.md)
  [`methods_restore()`](https://duckplyr.tidyverse.org/reference/methods_overwrite.md)
  : Forward all dplyr methods to duckplyr

### Datasets

- [`flights_df()`](https://duckplyr.tidyverse.org/reference/flights_df.md)
  : Flight data

## Configuration, telemetry, and internals

- [`config`](https://duckplyr.tidyverse.org/reference/config.md) :
  Configuration options
- [`fallback_sitrep()`](https://duckplyr.tidyverse.org/reference/fallback.md)
  [`fallback_config()`](https://duckplyr.tidyverse.org/reference/fallback.md)
  [`fallback_review()`](https://duckplyr.tidyverse.org/reference/fallback.md)
  [`fallback_upload()`](https://duckplyr.tidyverse.org/reference/fallback.md)
  [`fallback_purge()`](https://duckplyr.tidyverse.org/reference/fallback.md)
  : Fallback to dplyr
- [`stats_show()`](https://duckplyr.tidyverse.org/reference/stats_show.md)
  : Show stats
- [`last_rel()`](https://duckplyr.tidyverse.org/reference/last_rel.md) :
  Retrieve details about the most recent computation
- [`db_exec()`](https://duckplyr.tidyverse.org/reference/db_exec.md) :
  Execute a statement for the default connection

## Relational operations and expressions

- [`new_relational()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_to_df()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_filter()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_project()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_aggregate()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_order()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_join()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_limit()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_distinct()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_set_intersect()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_set_diff()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_set_symdiff()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_union_all()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_explain()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_alias()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_set_alias()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  [`rel_names()`](https://duckplyr.tidyverse.org/reference/new_relational.md)
  : Relational implementer's interface
- [`new_relexpr()`](https://duckplyr.tidyverse.org/reference/new_relexpr.md)
  [`relexpr_reference()`](https://duckplyr.tidyverse.org/reference/new_relexpr.md)
  [`relexpr_constant()`](https://duckplyr.tidyverse.org/reference/new_relexpr.md)
  [`relexpr_function()`](https://duckplyr.tidyverse.org/reference/new_relexpr.md)
  [`relexpr_comparison()`](https://duckplyr.tidyverse.org/reference/new_relexpr.md)
  [`relexpr_window()`](https://duckplyr.tidyverse.org/reference/new_relexpr.md)
  [`relexpr_set_alias()`](https://duckplyr.tidyverse.org/reference/new_relexpr.md)
  : Relational expressions
