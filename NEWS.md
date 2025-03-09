<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# duckplyr 1.0.1.9002 (2025-03-09)

## Chore

- Check loadability of extensino in test (#636).


# duckplyr 1.0.1.9001 (2025-02-28)

## fledge

- CRAN release v1.0.1 (#624).


# duckplyr 1.0.1.9000 (2025-02-22)

## Bug fixes

- Correct formatting for controlled fallbacks with `Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)`.


# duckplyr 1.0.1 (2025-02-21)

## Bug fixes

- Check if extensions can be loaded before running examples and vignettes (#620).

- Show source of error if data frame cannot be converted to duck frame (#614).

- Correct formatting for controlled fallbacks with `Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)`

## Chore

- Require duckdb \>= 1.2.0 (#619).

- Break this version with duckdb 2.0.0 (#623).

## Documentation

- Separate `?compute_parquet` and `?compute_csv` (#610, #622).

- Italicize book title in README (@wibeasley, #607).

- Fix typo in `filter(.by = ...)` error message (@maelle, #611).

- Fix link in documentation (#600, #601).


# duckplyr 1.0.0 (2025-02-02)

## Features

### Large data

- Improved support for handling large data from files and S3: ingestion with `read_parquet_duckdb()` and others, and materialization with `as_duckdb_tibble()`, `compute.duckplyr_df()` and `compute_file()`. See `vignette("large")` for details.

- Control automatic materialization of duckplyr frames with the new `prudence` argument to `as_duckdb_tibble()`, `duckdb_tibble()`, `compute.duckplyr_df()` and `compute_file()`. See `vignette("prudence")` for details.

### New functions

- `read_csv_duckdb()` and others, deprecating `duckplyr_df_from_csv()` and `df_from_csv()` (#210, #396, #459).

- `read_sql_duckdb()` (experimental) to run SQL queries against the default DuckDB connection and return the result as a duckplyr frame (duckdb/duckdb-r#32, #397).

- `db_exec()` to execute configuration queries against the default duckdb connection (#39, #165, #227, #404, #459).

- `duckdb_tibble()` (#382, #457).

- `as_duckdb_tibble()`, replaces `as_duckplyr_tibble()` and `as_duckplyr_df()` (#383, #457) and supports dbplyr connections to a duckdb database (#86, #211, #226).

- `compute_parquet()` and `compute_csv()`, implement `compute.duckplyr_df()` (#409, #430).

- `fallback_config()` to create a configuration file for the settings that do not affect behavior (#216, #426).

- `is_duckdb_tibble()`, deprecates `is_duckplyr_df()` (#391, #392).

- `last_rel()` to retrieve the last relation object used in materialization (#209, #375).

- Add `"prudent_duckplyr_df"` class that stops automatic materialization and requires `collect()` (#381, #390).

### Translations

- Partial support for `across()` in `mutate()` and `summarise()` (#296, #306, #318, @lionel-, @DavisVaughan).

- Implement `na.rm` handling for `sum()`, `min()`, `max()`, `any()` and `all()`, with fallback for window functions (#205, #566).

- Add support for `sub()` and `gsub()` (@toppyy, #420).

- Handle `dplyr::desc()` (#550).

- Avoid forwarding `is.na()` to `is.nan()` to support non-numeric data, avoid checking roundtrip for timestamp data (#482).

- Correctly handle missing values in `if_else()`.

- Limit number of items that can be handled with `%in%` (#319).

- `duckdb_tibble()` checks if columns can be represented in DuckDB (#537).

- Fall back to dplyr when passing `multiple` with joins (#323).

### Error messages

- Improve fallback error message by explicitly materializing (#432, #456).

- Point to the native CSV reader if encountering data frames read with readr (#127, #469).

- Improve `as_duckdb_tibble()` error message for invalid `x` (@maelle, #339).

### Behavior

- Depend on dplyr instead of reexporting all generics (#405). Nothing changes for users in scripts. When using duckplyr in a package, you now also need to import dplyr.

- Fallback logging is now on by default, can be disabled with configuration (#422).

- The default DuckDB connection is now based on a file, the location defaults to a subdirectory of `tempdir()` and can be controlled with the `DUCKPLYR_TEMP_DIR` environment variable (#439, #448, #561).

- `collect()` returns a tibble (#438, #447).

- `explain()` returns the input, invisibly (#331).

## Bug fixes

- Compute ptype only for join columns in a safe way without materialization, not for the entire data frame (#289).

- Internal `expr_scrub()` (used for telemetry) can handle function-definitions (@toppyy, #268, #271).

- Harden telemetry code against invalid arguments (#321).

## Documentation

- New articles: `vignette("large")`, `vignette("prudence")`, `vignette("fallback")`, `vignette("limits")`, `vignette("developers")`, `vignette("telemetry")` (#207, #504).

- New `flights_df()` used instead of `palmerpenguins::penguins` (#408).

- Move to the tidyverse GitHub organization, new repository URL <https://github.com/tidyverse/duckplyr/> (#225).

- Avoid base pipe in examples for compatibility with R 4.0.0 (#463, #466).

## Performance

- Comparison expressions are translated in a way that allows them to be pushed down to Parquet (@toppyy, #270).

- Printing a duckplyr frame no longer materializes (#255, #378).

- Prefer `vctrs::new_data_frame()` over `tibble()` (#500).


# duckplyr 0.4.1 (2024-07-11)

## Features

- `df_from_file()` and related functions support multiple files (#194, #195), show a clear error message for non-string `path` arguments (#182), and create a tibble by default (#177).
- New `as_duckplyr_tibble()` to convert a data frame to a duckplyr tibble (#177).
- Support descending sort for character and other non-numeric data (@toppyy, #92, #175).
- Avoid setting memory limit (#193).
- Check compatibility of join columns (#168, #185).
- Explicitly list supported functions, add contributing guide, add analysis scripts for GitHub activity data (#179).

## Documentation

- Add contributing guide (#179).
- Show a startup message at package load if telemetry is not configured (#188, #198).
- `?df_from_file` shows how to read multiple files (#181, #186) and how to specify CSV column types (#140, #189), and is shown correctly in reference index (#173, #190).
- Discuss dbplyr in README (#145, #191).
- Add analysis scripts for GitHub activity data (#179).


# duckplyr 0.4.0 (2024-05-21)

## Features

- Use built-in rfuns extension to implement equality and inequality operators, improve translation for `as.integer()`, `NA` and `%in%` (#83, #154, #148, #155, #159, #160).
- Reexport non-deprecated dplyr functions (#144, #163).
- `library(duckplyr)` calls `methods_overwrite()` (#164).
- Only allow constant patterns in `grepl()`.
- Explicitly reject calls with named arguments for now.
- Reduce default memory limit to 1 GB.

## Bug fixes

- Stricter type checks in the set operations `intersect()`, `setdiff()`, `symdiff()`, `union()`, and `union_all()` (#169).
- Distinguish between constant `NA` and those used in an expression (#157).
- `head(-1)` forwards to the default implementation (#131, #156).
- Fix cli syntax for internal error message (#151).
- More careful detection of row names in data frame.
- Always check roundtrip for timestamp columns.
- `left_join()` and other join functions call `auto_copy()`.
- Only reset expression depth if it has been set before.
- Require fallback if the result contains duplicate column names when ignoring case.
- `row_number()` returns integer.
- `is.na(NaN)` is `TRUE`.
- `summarise(count = n(), count = n())` creates only one column named `count`.
- Correct wording in instructions for enabling fallback logging (@TimTaylor, #141).

## Chore

- Remove styler dependency (#137, #138).
- Avoid error from stats collection.

## Documentation

- Mention wildcards to read multiple files in `?df_from_file` (@andreranza, #133, #134).

## Testing

- Reenable tests that now run successfully (#166).
- Synchronize tests (#153).
- Test that `vec_ptype()` does not materialize (#149).
- Improve telemetry tests.
- Promote equality checks to `expect_identical()` to capture differences between doubles and integers.


# duckplyr 0.3.2 (2024-03-17)

## Bug fixes

- Run autoupload in function so that it will be checked by static analysis (#122).

## Features

- New `df_to_parquet()` to write to Parquet, new convenience functions `df_from_csv()`, `duckdb_df_from_csv()`, `df_from_parquet()` and `duckdb_df_from_parquet()` (#87, #89, #96, #128).


# duckplyr 0.3.1 (2024-03-08)

## Bug fixes

- Forbid reuse of new columns created in `summarise()` (#72, #106).
- `summarise()` no longer restores subclass.
- Disambiguate computation of `log10()` and `log()`.
- Fix division by zero for positive and negative numbers.

## Features

- New `fallback_sitrep()` and related functionality for collecting telemetry data (#102, #107, #110, #111, #115). No data is collected by default, only a message is displayed once per session and then every eight hours. Opt in or opt out by setting environment variables.
- Implement `group_by()` and other methods to collect fallback information (#94, #104, #105).
- Set memory limit and temporary directory for duckdb.
- Implement `suppressWarnings()` as the identity function.
- Prefer `cli::cli_abort()` over `stop()` or `rlang::abort()` (#114).
- Translate `.data$a` and `.env$a`.
- Strict checks for column class, only supporting `integer`, `numeric`, `logical`, `Date`, `POSIXct`, and `difftime` for now.
- If the environment variable `DUCKPLYR_METHODS_OVERWRITE` is set to `TRUE`, loading duckplyr automatically calls `methods_overwrite()`.

## Internal

- Better duckdb tests.
- Use standalone purrr for dplyr compatibility.

## Testing

- Add tests for correct base of `log()` and `log10()`.

## Documentation

- `methods_overwrite()` and `methods_restore()` show a message.


# duckplyr 0.3.0 (2023-12-10)

## Bug fixes

- `grepl(x = NA)` gives correct results.
- Fix `auto_copy()` for non-data-frame input.
- Add output order preservation for filters.
- `distinct()` now preserves order in corner cases (#77, #78).
- Consistent computation of `log(0)` and `log(-1)` (#75, #76).

## Features

- Only allow constants in `mutate()` that are actually representable in duckdb (#73).
- Avoid translating `ifelse()`, support `if_else()` (#79).

## Documentation

- Separate and explain the new relational examples (@wibeasley, #84).

## Testing

- Add test that TPC-H queries can be processed.

## Chore

- Sync with dplyr 1.1.4 (#82).
- Remove `dplyr_reconstruct()` method (#48).
- Render README.
- Fix code generated by `meta_replay()`.
- Bump constructive dependency.
- Fix output order for `arrange()` in case of ties.
- Update duckdb tests.
- Only implement newer `slice_sample()`, not `sample_n()` or `sample_frac()` (#74).
- Sync generated files (#71).


# duckplyr 0.2.3 (2023-11-08)

## Performance

- Join using `IS NOT DISTINCT FROM` for faster execution (duckdb/duckdb-r#41, #68).

## Documentation

- Add stability to README output (@maelle, #62, #65).


# duckplyr 0.2.2 (2023-10-16)

## Bug fixes

- `summarise()` keeps `"duckplyr_df"` class (#63, #64).

- Fix compatibility with duckdb \>= 0.9.1.

## Chore

- Skip tests that give different output on dev tidyselect.

- Import `utils::globalVariables()`.

## Documentation

- Small README improvements (@maelle, #34, #57).

- Fix 301 in README.


# duckplyr 0.2.1 (2023-09-16)

- Improve documentation.

- Work around problem with `dplyr_reconstruct()` in R 4.3.

- Rename `duckdb_from_file()` to `df_from_file()`.

- Unexport private `duckdb_rel_from_df()`, `rel_from_df()`, `wrap_df()` and `wrap_integer()`.

- Reexport `%>%` and `tibble()`.


# duckplyr 0.2.0 (2023-09-10)

- Implement relational API for DuckDB.


# duckplyr 0.1.0 (2023-07-03)

## Bug fixes

- Fix examples.

## Chore

- Add CRAN install instructions.
- Satisfy `R CMD check`.
- Document argument.
- Error on NOTE.
- Remove `relexpr_window()` for now.

## Documentation

- Clean up reference.

## Uncategorized

Initial version, exporting:
- `new_relational()` to construct objects of class `"relational"`
- Generics `rel_aggregate()`, `rel_distinct()`, `rel_filter()`, `rel_join()`, `rel_limit()`, `rel_names()`, `rel_order()`, `rel_project()`, `rel_set_diff()`, `rel_set_intersect()`, `rel_set_symdiff()`, `rel_to_df()`, `rel_union_all()`
- `new_relexpr()` to construct objects of class `"relational_relexpr"`
- Expression builders `relexpr_constant()`, `relexpr_function()`, `relexpr_reference()`, `relexpr_set_alias()`, `relexpr_window()`
