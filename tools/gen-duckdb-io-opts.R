# Generates R/duckdb-io-opts.R with package-local character vectors of
# read options and write-only options for DuckDB parquet and CSV formats.
# Run with: Rscript tools/gen-duckdb-io-opts.R
#
# Re-run after upgrading the duckdb package to update the options.

library(duckdb)

con <- dbConnect(duckdb())
on.exit(dbDisconnect(con, shutdown = TRUE))

# Get read options from the duckdb_functions() system catalog
get_read_opts <- function(con, fn_name) {
  res <- dbGetQuery(
    con,
    paste0(
      "SELECT parameters FROM duckdb_functions() ",
      "WHERE function_type = 'table' AND function_name = '",
      fn_name,
      "'"
    )
  )
  params <- res$parameters[[1]]
  # Remove "col0" which is the positional file path argument
  sort(params[params != "col0"])
}

# Discover valid write options for a COPY TO format by probing candidates:
# options that don't return "Unrecognized option" are considered valid.
get_write_opts <- function(con, format, candidates) {
  valid <- character()
  for (opt in candidates) {
    val <- switch(
      opt,
      "compression" = "'snappy'",
      "parquet_version" = "'V1'",
      "dateformat" = "'%Y-%m-%d'",
      "decimal_separator" = "'.'",
      "delim" = "','",
      "encoding" = "'UTF-8'",
      "escape" = "'\"'",
      "file_extension" = "'.out'",
      "filename_pattern" = "'data_{i}'",
      "hive_file_pattern" = "'data_{i}'",
      "nullstr" = "''",
      "partition_by" = "'x'",
      "prefix" = "''",
      "quote" = "'\"'",
      "sep" = "','",
      "suffix" = "''",
      "timestampformat" = "'%Y-%m-%d'",
      "compression_level" = "1",
      "row_group_size" = "100",
      "row_group_size_bytes" = "1000000",
      "file_size_bytes" = "1000000",
      "dictionary_size_limit" = "1048576",
      # Default for boolean/untyped options
      "TRUE"
    )
    sql <- paste0(
      "COPY write_test_tbl TO '",
      tempfile(),
      "' (FORMAT ",
      format,
      ", ",
      opt,
      " ",
      val,
      ")"
    )
    tryCatch(
      {
        dbExecute(con, sql)
        valid <- c(valid, opt)
      },
      error = function(e) {
        msg <- conditionMessage(e)
        # "Unrecognized option" means the option doesn't exist in this format.
        # Any other error (wrong type, not implemented, etc.) means the option
        # IS recognized but we provided a bad value -- still a valid option.
        if (!grepl("Unrecognized option", msg)) {
          valid <<- c(valid, opt)
        }
      }
    )
  }
  sort(valid)
}

dbExecute(con, "CREATE TABLE write_test_tbl AS SELECT 1 AS x, 'a' AS y")

# Comprehensive candidate lists (union of all known read + write options)
parquet_candidates <- c(
  "append",
  "binary_as_string",
  "can_have_nan",
  "codec",
  "compression",
  "compression_level",
  "debug_use_openssl",
  "dictionary_size_limit",
  "encryption_config",
  "explicit_cardinality",
  "field_ids",
  "file_extension",
  "file_row_number",
  "file_size_bytes",
  "filename",
  "filename_pattern",
  "hive_file_pattern",
  "hive_partitioning",
  "hive_types",
  "hive_types_autocast",
  "kv_metadata",
  "overwrite",
  "overwrite_or_ignore",
  "parquet_version",
  "partition_by",
  "per_thread_output",
  "preserve_order",
  "return_files",
  "return_stats",
  "row_group_size",
  "row_group_size_bytes",
  "schema",
  "union_by_name",
  "use_tmp_file",
  "write_partition_columns"
)

csv_candidates <- c(
  "all_varchar",
  "allow_quoted_nulls",
  "append",
  "auto_detect",
  "auto_type_candidates",
  "buffer_size",
  "column_names",
  "column_types",
  "columns",
  "comment",
  "compression",
  "dateformat",
  "decimal_separator",
  "delim",
  "dtypes",
  "encoding",
  "escape",
  "file_extension",
  "file_size_bytes",
  "filename",
  "filename_pattern",
  "files_to_sniff",
  "force_not_null",
  "force_quote",
  "header",
  "hive_file_pattern",
  "hive_partitioning",
  "hive_types",
  "hive_types_autocast",
  "ignore_errors",
  "max_line_size",
  "maximum_line_size",
  "names",
  "new_line",
  "normalize_names",
  "null_padding",
  "nullstr",
  "overwrite",
  "overwrite_or_ignore",
  "parallel",
  "partition_by",
  "per_thread_output",
  "prefix",
  "preserve_order",
  "quote",
  "rejects_limit",
  "rejects_scan",
  "rejects_table",
  "return_files",
  "return_stats",
  "sample_size",
  "sep",
  "skip",
  "store_rejects",
  "strict_mode",
  "suffix",
  "thousands",
  "timestampformat",
  "types",
  "union_by_name",
  "use_tmp_file",
  "write_partition_columns"
)

parquet_read_opts <- get_read_opts(con, "read_parquet")
csv_read_opts <- get_read_opts(con, "read_csv_auto")
parquet_write_opts <- get_write_opts(con, "PARQUET", parquet_candidates)
csv_write_opts <- get_write_opts(con, "CSV", csv_candidates)

# Write-only = valid for COPY TO but absent from the corresponding read function
parquet_write_only_opts <- sort(setdiff(parquet_write_opts, parquet_read_opts))
csv_write_only_opts <- sort(setdiff(csv_write_opts, csv_read_opts))

# Format a character vector as R code
fmt_vec <- function(name, values) {
  items <- paste0('  "', values, '"', collapse = ",\n")
  paste0(name, " <- c(\n", items, "\n)\n")
}

lines <- c(
  "# Generated by tools/gen-duckdb-io-opts.R \u2014 do not edit by hand.",
  paste0("# DuckDB version: ", as.character(packageVersion("duckdb"))),
  "",
  "# Options accepted by read_parquet()",
  fmt_vec("parquet_read_opts", parquet_read_opts),
  "# Options accepted by COPY ... TO (FORMAT PARQUET) but not by read_parquet()",
  fmt_vec("parquet_write_only_opts", parquet_write_only_opts),
  "# Options accepted by read_csv_auto()",
  fmt_vec("csv_read_opts", csv_read_opts),
  "# Options accepted by COPY ... TO (FORMAT CSV) but not by read_csv_auto()",
  fmt_vec("csv_write_only_opts", csv_write_only_opts)
)

out_path <- file.path("R", "duckdb-io-opts.R")
writeLines(lines, out_path)
message("Written: ", out_path)
