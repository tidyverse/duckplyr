<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# duckplyr 0.4.1.9003 (2024-08-20)

## Features

  - Detect functions from the duckplyr package (#246).

  - New `duckplyr_execute()` to execute configuration queries against the default duckdb connection (#39, #165, #227).

  - `as_duckplyr_tibble()` supports dbplyr connections to a duckdb database (#86, #211, #226).

## Continuous integration

  - Avoid failures if artifact is missing.

  - Store SHA as artifact.

  - Move towards external status updates.

  - Tweak status workflow.

  - Use token.

  - Add external workflow to update commit statuses.

  - Avoid manually installing package for pkgdown (#245).

  - Fix fledge (#243).

  - Use proper remote repo (#241).

  - Add permissions to fledge workflow (#238).

  - Fix tests without suggested packages (#236).

  - Add permissions to fledge workflow (#235).

  - Add permissions to fledge workflow (#234).

  - Add input to fledge workflow (#233).

  - Use proper token for fledge (#232).

  - Fix fledge workflow (#231).

  - Bump version via PR (#230).

  - Sync with duckdb.


# duckplyr 0.4.1.9002 (2024-08-16)

## Documentation

  - Move to tidyverse (#225).


# duckplyr 0.4.1.9001 (2024-07-13)

  - Merge branch 'cran-0.4.1'.


# duckplyr 0.4.1.9000 (2024-07-12)

  - Merge branch 'cran-0.4.1'.


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
