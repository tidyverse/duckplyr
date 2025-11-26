# Changelog

## duckplyr 1.1.3.9004 (2025-11-17)

### Continuous integration

- Install binaries from r-universe for dev workflow
  ([\#813](https://github.com/tidyverse/duckplyr/issues/813)).

## duckplyr 1.1.3.9003 (2025-11-12)

### Continuous integration

- Fix reviewdog and add commenting workflow
  ([\#810](https://github.com/tidyverse/duckplyr/issues/810)).

## duckplyr 1.1.3.9002 (2025-11-11)

### Continuous integration

- Use workflows for fledge
  ([\#807](https://github.com/tidyverse/duckplyr/issues/807)).

## duckplyr 1.1.3.9001 (2025-11-08)

### Continuous integration

- Sync ([\#805](https://github.com/tidyverse/duckplyr/issues/805)).

## duckplyr 1.1.3.9000 (2025-11-04)

### fledge

- CRAN release v1.1.3
  ([\#803](https://github.com/tidyverse/duckplyr/issues/803)).

## duckplyr 1.1.3 (2025-11-04)

CRAN release: 2025-11-04

### Features

- [`read_file_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_file_duckdb.md)
  only wraps `path` into a list if the length is not equal to one, to
  support `read_stat()`.

### Continuous integration

- Avoid example failing in R 4.2 and older.

### Documentation

- Add “Supported by Posit” badge.

## duckplyr 1.1.2 (2025-09-17)

CRAN release: 2025-09-18

### Features

- Fully support `dd::...()` syntax
  ([\#795](https://github.com/tidyverse/duckplyr/issues/795)).

- Threshold for `prudence = "thrifty"` is reduced to 1000 cells when the
  data comes from a remote data source.

- Support named arguments for `dd::...()` functions.

### Performance

- Generate a more balanced expresion when translating `%in%` to avoid
  performance problems in duckdb v1.4.0.

## duckplyr 1.1.1 (2025-07-29)

CRAN release: 2025-07-30

### Chore

- Fix CRAN failure with `_R_CHECK_THINGS_IN_OTHER_DIRS_=true`.

## duckplyr 1.1.0 (2025-05-08)

CRAN release: 2025-05-08

This release improves compatibility with dbplyr and DuckDB. See
[`vignette("duckdb")`](https://duckplyr.tidyverse.org/dev/articles/duckdb.md)
for details.

### Features

- Pass functions prefixed with `dd$` directly to DuckDB, e.g.,
  `dd$ROW()` will be translated as DuckDB’s `ROW()` function
  ([\#658](https://github.com/tidyverse/duckplyr/issues/658)).

- New
  [`as_tbl()`](https://duckplyr.tidyverse.org/dev/reference/as_tbl.md)
  to convert to a dbplyr tbl object
  ([\#634](https://github.com/tidyverse/duckplyr/issues/634),
  [\#685](https://github.com/tidyverse/duckplyr/issues/685)).

- Register Ark methods for Positron’s “Variables” pane
  ([@DavisVaughan](https://github.com/DavisVaughan),
  [\#661](https://github.com/tidyverse/duckplyr/issues/661),
  [\#678](https://github.com/tidyverse/duckplyr/issues/678)). DuckDB
  tibbles are no longer displayed as data frames in the “Variables” pane
  due to a limitation in Positron. Use
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html) to
  convert them to data frames if you rely on the viewer functionality.

- Translate
  [`n_distinct()`](https://dplyr.tidyverse.org/reference/n_distinct.html)
  as macro with support for `na.rm = TRUE`
  ([@joakimlinde](https://github.com/joakimlinde),
  [\#572](https://github.com/tidyverse/duckplyr/issues/572),
  [\#655](https://github.com/tidyverse/duckplyr/issues/655)).

- Translate
  [`coalesce()`](https://dplyr.tidyverse.org/reference/coalesce.html).

- [`compute()`](https://dplyr.tidyverse.org/reference/compute.html) does
  not have a fallback, failures are reported to the client
  ([\#637](https://github.com/tidyverse/duckplyr/issues/637)).

- Implement
  [`slice_head()`](https://dplyr.tidyverse.org/reference/slice.html)
  ([\#640](https://github.com/tidyverse/duckplyr/issues/640)).

### Bug fixes

- Set functions like
  [`union()`](https://generics.r-lib.org/reference/setops.html) no
  longer trigger materialization
  ([\#654](https://github.com/tidyverse/duckplyr/issues/654),
  [\#692](https://github.com/tidyverse/duckplyr/issues/692)).

- Joins no longer materialize the input data when the package is used
  with
  [`methods_overwrite()`](https://duckplyr.tidyverse.org/dev/reference/methods_overwrite.md)
  or [`library(duckplyr)`](https://duckplyr.tidyverse.org)
  ([\#641](https://github.com/tidyverse/duckplyr/issues/641)).

- Correct formatting for controlled fallbacks with
  `Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)`.

### Chore

- Bump duckdb and pillar dependencies.

- Use roxyglobals from CRAN rather than GitHub
  ([@andreranza](https://github.com/andreranza),
  [\#659](https://github.com/tidyverse/duckplyr/issues/659)).

- Bring tools and patch up to date
  ([@joakimlinde](https://github.com/joakimlinde),
  [\#647](https://github.com/tidyverse/duckplyr/issues/647)).

- Internal
  [`rel_to_df()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md)
  needs `prudence` argument
  ([\#644](https://github.com/tidyverse/duckplyr/issues/644)).

- Fix sync scripts and add reproducible code
  ([\#639](https://github.com/tidyverse/duckplyr/issues/639)).

- Check loadability of extensions in test
  ([\#636](https://github.com/tidyverse/duckplyr/issues/636)).

### Documentation

- Document
  [`slice_head()`](https://dplyr.tidyverse.org/reference/slice.html) as
  supported.

- Add Posit’s ROR ID
  ([\#592](https://github.com/tidyverse/duckplyr/issues/592)).

- Add
  [`vignette("duckdb")`](https://duckplyr.tidyverse.org/dev/articles/duckdb.md)
  ([\#690](https://github.com/tidyverse/duckplyr/issues/690)).

- Add experimental badge.

- Verbose
  [`conflict_prefer()`](https://conflicted.r-lib.org/reference/conflict_prefer.html)
  ([\#667](https://github.com/tidyverse/duckplyr/issues/667),
  [\#684](https://github.com/tidyverse/duckplyr/issues/684)).

- Typos + clarification edits to “large” vignette
  ([@mine-cetinkaya-rundel](https://github.com/mine-cetinkaya-rundel),
  [\#665](https://github.com/tidyverse/duckplyr/issues/665)).

### Testing

- Skip tests using [`grep()`](https://rdrr.io/r/base/grep.html) or
  [`sub()`](https://rdrr.io/r/base/grep.html) on CRAN.

## duckplyr 1.0.1 (2025-02-21)

CRAN release: 2025-02-27

### Bug fixes

- Check if extensions can be loaded before running examples and
  vignettes ([\#620](https://github.com/tidyverse/duckplyr/issues/620)).

- Show source of error if data frame cannot be converted to duck frame
  ([\#614](https://github.com/tidyverse/duckplyr/issues/614)).

- Correct formatting for controlled fallbacks with
  `Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)`

### Chore

- Require duckdb \>= 1.2.0
  ([\#619](https://github.com/tidyverse/duckplyr/issues/619)).

- Break this version with duckdb 2.0.0
  ([\#623](https://github.com/tidyverse/duckplyr/issues/623)).

### Documentation

- Separate
  [`?compute_parquet`](https://duckplyr.tidyverse.org/dev/reference/compute_parquet.md)
  and
  [`?compute_csv`](https://duckplyr.tidyverse.org/dev/reference/compute_csv.md)
  ([\#610](https://github.com/tidyverse/duckplyr/issues/610),
  [\#622](https://github.com/tidyverse/duckplyr/issues/622)).

- Italicize book title in README
  ([@wibeasley](https://github.com/wibeasley),
  [\#607](https://github.com/tidyverse/duckplyr/issues/607)).

- Fix typo in `filter(.by = ...)` error message
  ([@maelle](https://github.com/maelle),
  [\#611](https://github.com/tidyverse/duckplyr/issues/611)).

- Fix link in documentation
  ([\#600](https://github.com/tidyverse/duckplyr/issues/600),
  [\#601](https://github.com/tidyverse/duckplyr/issues/601)).

## duckplyr 1.0.0 (2025-02-02)

CRAN release: 2025-02-07

### Features

#### Large data

- Improved support for handling large data from files and S3: ingestion
  with
  [`read_parquet_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_parquet_duckdb.md)
  and others, and materialization with
  [`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md),
  [`compute.duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/compute.duckplyr_df.md)
  and `compute_file()`. See
  [`vignette("large")`](https://duckplyr.tidyverse.org/dev/articles/large.md)
  for details.

- Control automatic materialization of duckplyr frames with the new
  `prudence` argument to
  [`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md),
  [`duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md),
  [`compute.duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/compute.duckplyr_df.md)
  and `compute_file()`. See
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
  for details.

#### New functions

- [`read_csv_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_csv_duckdb.md)
  and others, deprecating
  [`duckplyr_df_from_csv()`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md)
  and
  [`df_from_csv()`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md)
  ([\#210](https://github.com/tidyverse/duckplyr/issues/210),
  [\#396](https://github.com/tidyverse/duckplyr/issues/396),
  [\#459](https://github.com/tidyverse/duckplyr/issues/459)).

- [`read_sql_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_sql_duckdb.md)
  (experimental) to run SQL queries against the default DuckDB
  connection and return the result as a duckplyr frame
  (duckdb/duckdb-r#32,
  [\#397](https://github.com/tidyverse/duckplyr/issues/397)).

- [`db_exec()`](https://duckplyr.tidyverse.org/dev/reference/db_exec.md)
  to execute configuration queries against the default duckdb connection
  ([\#39](https://github.com/tidyverse/duckplyr/issues/39),
  [\#165](https://github.com/tidyverse/duckplyr/issues/165),
  [\#227](https://github.com/tidyverse/duckplyr/issues/227),
  [\#404](https://github.com/tidyverse/duckplyr/issues/404),
  [\#459](https://github.com/tidyverse/duckplyr/issues/459)).

- [`duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
  ([\#382](https://github.com/tidyverse/duckplyr/issues/382),
  [\#457](https://github.com/tidyverse/duckplyr/issues/457)).

- [`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md),
  replaces
  [`as_duckplyr_tibble()`](https://duckplyr.tidyverse.org/dev/reference/as_duckplyr_df.md)
  and
  [`as_duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/as_duckplyr_df.md)
  ([\#383](https://github.com/tidyverse/duckplyr/issues/383),
  [\#457](https://github.com/tidyverse/duckplyr/issues/457)) and
  supports dbplyr connections to a duckdb database
  ([\#86](https://github.com/tidyverse/duckplyr/issues/86),
  [\#211](https://github.com/tidyverse/duckplyr/issues/211),
  [\#226](https://github.com/tidyverse/duckplyr/issues/226)).

- [`compute_parquet()`](https://duckplyr.tidyverse.org/dev/reference/compute_parquet.md)
  and
  [`compute_csv()`](https://duckplyr.tidyverse.org/dev/reference/compute_csv.md),
  implement
  [`compute.duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/compute.duckplyr_df.md)
  ([\#409](https://github.com/tidyverse/duckplyr/issues/409),
  [\#430](https://github.com/tidyverse/duckplyr/issues/430)).

- [`fallback_config()`](https://duckplyr.tidyverse.org/dev/reference/fallback.md)
  to create a configuration file for the settings that do not affect
  behavior ([\#216](https://github.com/tidyverse/duckplyr/issues/216),
  [\#426](https://github.com/tidyverse/duckplyr/issues/426)).

- [`is_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md),
  deprecates
  [`is_duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/is_duckplyr_df.md)
  ([\#391](https://github.com/tidyverse/duckplyr/issues/391),
  [\#392](https://github.com/tidyverse/duckplyr/issues/392)).

- [`last_rel()`](https://duckplyr.tidyverse.org/dev/reference/last_rel.md)
  to retrieve the last relation object used in materialization
  ([\#209](https://github.com/tidyverse/duckplyr/issues/209),
  [\#375](https://github.com/tidyverse/duckplyr/issues/375)).

- Add `"prudent_duckplyr_df"` class that stops automatic materialization
  and requires
  [`collect()`](https://dplyr.tidyverse.org/reference/compute.html)
  ([\#381](https://github.com/tidyverse/duckplyr/issues/381),
  [\#390](https://github.com/tidyverse/duckplyr/issues/390)).

#### Translations

- Partial support for
  [`across()`](https://dplyr.tidyverse.org/reference/across.html) in
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) and
  [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
  ([\#296](https://github.com/tidyverse/duckplyr/issues/296),
  [\#306](https://github.com/tidyverse/duckplyr/issues/306),
  [\#318](https://github.com/tidyverse/duckplyr/issues/318),
  [@lionel-](https://github.com/lionel-),
  [@DavisVaughan](https://github.com/DavisVaughan)).

- Implement `na.rm` handling for
  [`sum()`](https://rdrr.io/r/base/sum.html),
  [`min()`](https://rdrr.io/r/base/Extremes.html),
  [`max()`](https://rdrr.io/r/base/Extremes.html),
  [`any()`](https://rdrr.io/r/base/any.html) and
  [`all()`](https://rdrr.io/r/base/all.html), with fallback for window
  functions ([\#205](https://github.com/tidyverse/duckplyr/issues/205),
  [\#566](https://github.com/tidyverse/duckplyr/issues/566)).

- Add support for [`sub()`](https://rdrr.io/r/base/grep.html) and
  [`gsub()`](https://rdrr.io/r/base/grep.html)
  ([@toppyy](https://github.com/toppyy),
  [\#420](https://github.com/tidyverse/duckplyr/issues/420)).

- Handle
  [`dplyr::desc()`](https://dplyr.tidyverse.org/reference/desc.html)
  ([\#550](https://github.com/tidyverse/duckplyr/issues/550)).

- Avoid forwarding [`is.na()`](https://rdrr.io/r/base/NA.html) to
  [`is.nan()`](https://rdrr.io/r/base/is.finite.html) to support
  non-numeric data, avoid checking roundtrip for timestamp data
  ([\#482](https://github.com/tidyverse/duckplyr/issues/482)).

- Correctly handle missing values in
  [`if_else()`](https://dplyr.tidyverse.org/reference/if_else.html).

- Limit number of items that can be handled with `%in%`
  ([\#319](https://github.com/tidyverse/duckplyr/issues/319)).

- [`duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
  checks if columns can be represented in DuckDB
  ([\#537](https://github.com/tidyverse/duckplyr/issues/537)).

- Fall back to dplyr when passing `multiple` with joins
  ([\#323](https://github.com/tidyverse/duckplyr/issues/323)).

#### Error messages

- Improve fallback error message by explicitly materializing
  ([\#432](https://github.com/tidyverse/duckplyr/issues/432),
  [\#456](https://github.com/tidyverse/duckplyr/issues/456)).

- Point to the native CSV reader if encountering data frames read with
  readr ([\#127](https://github.com/tidyverse/duckplyr/issues/127),
  [\#469](https://github.com/tidyverse/duckplyr/issues/469)).

- Improve
  [`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
  error message for invalid `x` ([@maelle](https://github.com/maelle),
  [\#339](https://github.com/tidyverse/duckplyr/issues/339)).

#### Behavior

- Depend on dplyr instead of reexporting all generics
  ([\#405](https://github.com/tidyverse/duckplyr/issues/405)). Nothing
  changes for users in scripts. When using duckplyr in a package, you
  now also need to import dplyr.

- Fallback logging is now on by default, can be disabled with
  configuration
  ([\#422](https://github.com/tidyverse/duckplyr/issues/422)).

- The default DuckDB connection is now based on a file, the location
  defaults to a subdirectory of
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) and can be
  controlled with the `DUCKPLYR_TEMP_DIR` environment variable
  ([\#439](https://github.com/tidyverse/duckplyr/issues/439),
  [\#448](https://github.com/tidyverse/duckplyr/issues/448),
  [\#561](https://github.com/tidyverse/duckplyr/issues/561)).

- [`collect()`](https://dplyr.tidyverse.org/reference/compute.html)
  returns a tibble
  ([\#438](https://github.com/tidyverse/duckplyr/issues/438),
  [\#447](https://github.com/tidyverse/duckplyr/issues/447)).

- [`explain()`](https://dplyr.tidyverse.org/reference/explain.html)
  returns the input, invisibly
  ([\#331](https://github.com/tidyverse/duckplyr/issues/331)).

### Bug fixes

- Compute ptype only for join columns in a safe way without
  materialization, not for the entire data frame
  ([\#289](https://github.com/tidyverse/duckplyr/issues/289)).

- Internal `expr_scrub()` (used for telemetry) can handle
  function-definitions ([@toppyy](https://github.com/toppyy),
  [\#268](https://github.com/tidyverse/duckplyr/issues/268),
  [\#271](https://github.com/tidyverse/duckplyr/issues/271)).

- Harden telemetry code against invalid arguments
  ([\#321](https://github.com/tidyverse/duckplyr/issues/321)).

### Documentation

- New articles:
  [`vignette("large")`](https://duckplyr.tidyverse.org/dev/articles/large.md),
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md),
  [`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md),
  [`vignette("limits")`](https://duckplyr.tidyverse.org/dev/articles/limits.md),
  [`vignette("developers")`](https://duckplyr.tidyverse.org/dev/articles/developers.md),
  [`vignette("telemetry")`](https://duckplyr.tidyverse.org/dev/articles/telemetry.md)
  ([\#207](https://github.com/tidyverse/duckplyr/issues/207),
  [\#504](https://github.com/tidyverse/duckplyr/issues/504)).

- New
  [`flights_df()`](https://duckplyr.tidyverse.org/dev/reference/flights_df.md)
  used instead of
  [`palmerpenguins::penguins`](https://allisonhorst.github.io/palmerpenguins/reference/penguins.html)
  ([\#408](https://github.com/tidyverse/duckplyr/issues/408)).

- Move to the tidyverse GitHub organization, new repository URL
  <https://github.com/tidyverse/duckplyr/>
  ([\#225](https://github.com/tidyverse/duckplyr/issues/225)).

- Avoid base pipe in examples for compatibility with R 4.0.0
  ([\#463](https://github.com/tidyverse/duckplyr/issues/463),
  [\#466](https://github.com/tidyverse/duckplyr/issues/466)).

### Performance

- Comparison expressions are translated in a way that allows them to be
  pushed down to Parquet ([@toppyy](https://github.com/toppyy),
  [\#270](https://github.com/tidyverse/duckplyr/issues/270)).

- Printing a duckplyr frame no longer materializes
  ([\#255](https://github.com/tidyverse/duckplyr/issues/255),
  [\#378](https://github.com/tidyverse/duckplyr/issues/378)).

- Prefer
  [`vctrs::new_data_frame()`](https://vctrs.r-lib.org/reference/new_data_frame.html)
  over [`tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
  ([\#500](https://github.com/tidyverse/duckplyr/issues/500)).

## duckplyr 0.4.1 (2024-07-11)

CRAN release: 2024-07-12

### Features

- [`df_from_file()`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md)
  and related functions support multiple files
  ([\#194](https://github.com/tidyverse/duckplyr/issues/194),
  [\#195](https://github.com/tidyverse/duckplyr/issues/195)), show a
  clear error message for non-string `path` arguments
  ([\#182](https://github.com/tidyverse/duckplyr/issues/182)), and
  create a tibble by default
  ([\#177](https://github.com/tidyverse/duckplyr/issues/177)).
- New
  [`as_duckplyr_tibble()`](https://duckplyr.tidyverse.org/dev/reference/as_duckplyr_df.md)
  to convert a data frame to a duckplyr tibble
  ([\#177](https://github.com/tidyverse/duckplyr/issues/177)).
- Support descending sort for character and other non-numeric data
  ([@toppyy](https://github.com/toppyy),
  [\#92](https://github.com/tidyverse/duckplyr/issues/92),
  [\#175](https://github.com/tidyverse/duckplyr/issues/175)).
- Avoid setting memory limit
  ([\#193](https://github.com/tidyverse/duckplyr/issues/193)).
- Check compatibility of join columns
  ([\#168](https://github.com/tidyverse/duckplyr/issues/168),
  [\#185](https://github.com/tidyverse/duckplyr/issues/185)).
- Explicitly list supported functions, add contributing guide, add
  analysis scripts for GitHub activity data
  ([\#179](https://github.com/tidyverse/duckplyr/issues/179)).

### Documentation

- Add contributing guide
  ([\#179](https://github.com/tidyverse/duckplyr/issues/179)).
- Show a startup message at package load if telemetry is not configured
  ([\#188](https://github.com/tidyverse/duckplyr/issues/188),
  [\#198](https://github.com/tidyverse/duckplyr/issues/198)).
- [`?df_from_file`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md)
  shows how to read multiple files
  ([\#181](https://github.com/tidyverse/duckplyr/issues/181),
  [\#186](https://github.com/tidyverse/duckplyr/issues/186)) and how to
  specify CSV column types
  ([\#140](https://github.com/tidyverse/duckplyr/issues/140),
  [\#189](https://github.com/tidyverse/duckplyr/issues/189)), and is
  shown correctly in reference index
  ([\#173](https://github.com/tidyverse/duckplyr/issues/173),
  [\#190](https://github.com/tidyverse/duckplyr/issues/190)).
- Discuss dbplyr in README
  ([\#145](https://github.com/tidyverse/duckplyr/issues/145),
  [\#191](https://github.com/tidyverse/duckplyr/issues/191)).
- Add analysis scripts for GitHub activity data
  ([\#179](https://github.com/tidyverse/duckplyr/issues/179)).

## duckplyr 0.4.0 (2024-05-21)

CRAN release: 2024-05-21

### Features

- Use built-in rfuns extension to implement equality and inequality
  operators, improve translation for
  [`as.integer()`](https://rdrr.io/r/base/integer.html), `NA` and `%in%`
  ([\#83](https://github.com/tidyverse/duckplyr/issues/83),
  [\#154](https://github.com/tidyverse/duckplyr/issues/154),
  [\#148](https://github.com/tidyverse/duckplyr/issues/148),
  [\#155](https://github.com/tidyverse/duckplyr/issues/155),
  [\#159](https://github.com/tidyverse/duckplyr/issues/159),
  [\#160](https://github.com/tidyverse/duckplyr/issues/160)).
- Reexport non-deprecated dplyr functions
  ([\#144](https://github.com/tidyverse/duckplyr/issues/144),
  [\#163](https://github.com/tidyverse/duckplyr/issues/163)).
- [`library(duckplyr)`](https://duckplyr.tidyverse.org) calls
  [`methods_overwrite()`](https://duckplyr.tidyverse.org/dev/reference/methods_overwrite.md)
  ([\#164](https://github.com/tidyverse/duckplyr/issues/164)).
- Only allow constant patterns in
  [`grepl()`](https://rdrr.io/r/base/grep.html).
- Explicitly reject calls with named arguments for now.
- Reduce default memory limit to 1 GB.

### Bug fixes

- Stricter type checks in the set operations
  [`intersect()`](https://generics.r-lib.org/reference/setops.html),
  [`setdiff()`](https://generics.r-lib.org/reference/setops.html),
  [`symdiff()`](https://dplyr.tidyverse.org/reference/setops.html),
  [`union()`](https://generics.r-lib.org/reference/setops.html), and
  [`union_all()`](https://dplyr.tidyverse.org/reference/setops.html)
  ([\#169](https://github.com/tidyverse/duckplyr/issues/169)).
- Distinguish between constant `NA` and those used in an expression
  ([\#157](https://github.com/tidyverse/duckplyr/issues/157)).
- `head(-1)` forwards to the default implementation
  ([\#131](https://github.com/tidyverse/duckplyr/issues/131),
  [\#156](https://github.com/tidyverse/duckplyr/issues/156)).
- Fix cli syntax for internal error message
  ([\#151](https://github.com/tidyverse/duckplyr/issues/151)).
- More careful detection of row names in data frame.
- Always check roundtrip for timestamp columns.
- [`left_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
  and other join functions call
  [`auto_copy()`](https://dplyr.tidyverse.org/reference/auto_copy.html).
- Only reset expression depth if it has been set before.
- Require fallback if the result contains duplicate column names when
  ignoring case.
- [`row_number()`](https://dplyr.tidyverse.org/reference/row_number.html)
  returns integer.
- `is.na(NaN)` is `TRUE`.
- `summarise(count = n(), count = n())` creates only one column named
  `count`.
- Correct wording in instructions for enabling fallback logging
  ([@TimTaylor](https://github.com/TimTaylor),
  [\#141](https://github.com/tidyverse/duckplyr/issues/141)).

### Chore

- Remove styler dependency
  ([\#137](https://github.com/tidyverse/duckplyr/issues/137),
  [\#138](https://github.com/tidyverse/duckplyr/issues/138)).
- Avoid error from stats collection.

### Documentation

- Mention wildcards to read multiple files in
  [`?df_from_file`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md)
  ([@andreranza](https://github.com/andreranza),
  [\#133](https://github.com/tidyverse/duckplyr/issues/133),
  [\#134](https://github.com/tidyverse/duckplyr/issues/134)).

### Testing

- Reenable tests that now run successfully
  ([\#166](https://github.com/tidyverse/duckplyr/issues/166)).
- Synchronize tests
  ([\#153](https://github.com/tidyverse/duckplyr/issues/153)).
- Test that `vec_ptype()` does not materialize
  ([\#149](https://github.com/tidyverse/duckplyr/issues/149)).
- Improve telemetry tests.
- Promote equality checks to `expect_identical()` to capture differences
  between doubles and integers.

## duckplyr 0.3.2 (2024-03-17)

CRAN release: 2024-03-17

### Bug fixes

- Run autoupload in function so that it will be checked by static
  analysis ([\#122](https://github.com/tidyverse/duckplyr/issues/122)).

### Features

- New
  [`df_to_parquet()`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md)
  to write to Parquet, new convenience functions
  [`df_from_csv()`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md),
  `duckdb_df_from_csv()`,
  [`df_from_parquet()`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md)
  and `duckdb_df_from_parquet()`
  ([\#87](https://github.com/tidyverse/duckplyr/issues/87),
  [\#89](https://github.com/tidyverse/duckplyr/issues/89),
  [\#96](https://github.com/tidyverse/duckplyr/issues/96),
  [\#128](https://github.com/tidyverse/duckplyr/issues/128)).

## duckplyr 0.3.1 (2024-03-08)

CRAN release: 2024-03-10

### Bug fixes

- Forbid reuse of new columns created in
  [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
  ([\#72](https://github.com/tidyverse/duckplyr/issues/72),
  [\#106](https://github.com/tidyverse/duckplyr/issues/106)).
- [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
  no longer restores subclass.
- Disambiguate computation of
  [`log10()`](https://rdrr.io/r/base/Log.html) and
  [`log()`](https://rdrr.io/r/base/Log.html).
- Fix division by zero for positive and negative numbers.

### Features

- New
  [`fallback_sitrep()`](https://duckplyr.tidyverse.org/dev/reference/fallback.md)
  and related functionality for collecting telemetry data
  ([\#102](https://github.com/tidyverse/duckplyr/issues/102),
  [\#107](https://github.com/tidyverse/duckplyr/issues/107),
  [\#110](https://github.com/tidyverse/duckplyr/issues/110),
  [\#111](https://github.com/tidyverse/duckplyr/issues/111),
  [\#115](https://github.com/tidyverse/duckplyr/issues/115)). No data is
  collected by default, only a message is displayed once per session and
  then every eight hours. Opt in or opt out by setting environment
  variables.
- Implement
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
  and other methods to collect fallback information
  ([\#94](https://github.com/tidyverse/duckplyr/issues/94),
  [\#104](https://github.com/tidyverse/duckplyr/issues/104),
  [\#105](https://github.com/tidyverse/duckplyr/issues/105)).
- Set memory limit and temporary directory for duckdb.
- Implement [`suppressWarnings()`](https://rdrr.io/r/base/warning.html)
  as the identity function.
- Prefer
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  over [`stop()`](https://rdrr.io/r/base/stop.html) or
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html)
  ([\#114](https://github.com/tidyverse/duckplyr/issues/114)).
- Translate `.data$a` and `.env$a`.
- Strict checks for column class, only supporting `integer`, `numeric`,
  `logical`, `Date`, `POSIXct`, and `difftime` for now.
- If the environment variable `DUCKPLYR_METHODS_OVERWRITE` is set to
  `TRUE`, loading duckplyr automatically calls
  [`methods_overwrite()`](https://duckplyr.tidyverse.org/dev/reference/methods_overwrite.md).

### Internal

- Better duckdb tests.
- Use standalone purrr for dplyr compatibility.

### Testing

- Add tests for correct base of
  [`log()`](https://rdrr.io/r/base/Log.html) and
  [`log10()`](https://rdrr.io/r/base/Log.html).

### Documentation

- [`methods_overwrite()`](https://duckplyr.tidyverse.org/dev/reference/methods_overwrite.md)
  and
  [`methods_restore()`](https://duckplyr.tidyverse.org/dev/reference/methods_overwrite.md)
  show a message.

## duckplyr 0.3.0 (2023-12-10)

CRAN release: 2023-12-11

### Bug fixes

- `grepl(x = NA)` gives correct results.
- Fix
  [`auto_copy()`](https://dplyr.tidyverse.org/reference/auto_copy.html)
  for non-data-frame input.
- Add output order preservation for filters.
- [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)
  now preserves order in corner cases
  ([\#77](https://github.com/tidyverse/duckplyr/issues/77),
  [\#78](https://github.com/tidyverse/duckplyr/issues/78)).
- Consistent computation of `log(0)` and `log(-1)`
  ([\#75](https://github.com/tidyverse/duckplyr/issues/75),
  [\#76](https://github.com/tidyverse/duckplyr/issues/76)).

### Features

- Only allow constants in
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) that
  are actually representable in duckdb
  ([\#73](https://github.com/tidyverse/duckplyr/issues/73)).
- Avoid translating [`ifelse()`](https://rdrr.io/r/base/ifelse.html),
  support
  [`if_else()`](https://dplyr.tidyverse.org/reference/if_else.html)
  ([\#79](https://github.com/tidyverse/duckplyr/issues/79)).

### Documentation

- Separate and explain the new relational examples
  ([@wibeasley](https://github.com/wibeasley),
  [\#84](https://github.com/tidyverse/duckplyr/issues/84)).

### Testing

- Add test that TPC-H queries can be processed.

### Chore

- Sync with dplyr 1.1.4
  ([\#82](https://github.com/tidyverse/duckplyr/issues/82)).
- Remove
  [`dplyr_reconstruct()`](https://dplyr.tidyverse.org/reference/dplyr_extending.html)
  method ([\#48](https://github.com/tidyverse/duckplyr/issues/48)).
- Render README.
- Fix code generated by `meta_replay()`.
- Bump constructive dependency.
- Fix output order for
  [`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) in
  case of ties.
- Update duckdb tests.
- Only implement newer
  [`slice_sample()`](https://dplyr.tidyverse.org/reference/slice.html),
  not
  [`sample_n()`](https://dplyr.tidyverse.org/reference/sample_n.html) or
  [`sample_frac()`](https://dplyr.tidyverse.org/reference/sample_n.html)
  ([\#74](https://github.com/tidyverse/duckplyr/issues/74)).
- Sync generated files
  ([\#71](https://github.com/tidyverse/duckplyr/issues/71)).

## duckplyr 0.2.3 (2023-11-08)

CRAN release: 2023-11-08

### Performance

- Join using `IS NOT DISTINCT FROM` for faster execution
  (duckdb/duckdb-r#41,
  [\#68](https://github.com/tidyverse/duckplyr/issues/68)).

### Documentation

- Add stability to README output ([@maelle](https://github.com/maelle),
  [\#62](https://github.com/tidyverse/duckplyr/issues/62),
  [\#65](https://github.com/tidyverse/duckplyr/issues/65)).

## duckplyr 0.2.2 (2023-10-16)

CRAN release: 2023-10-16

### Bug fixes

- [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
  keeps `"duckplyr_df"` class
  ([\#63](https://github.com/tidyverse/duckplyr/issues/63),
  [\#64](https://github.com/tidyverse/duckplyr/issues/64)).

- Fix compatibility with duckdb \>= 0.9.1.

### Chore

- Skip tests that give different output on dev tidyselect.

- Import
  [`utils::globalVariables()`](https://rdrr.io/r/utils/globalVariables.html).

### Documentation

- Small README improvements ([@maelle](https://github.com/maelle),
  [\#34](https://github.com/tidyverse/duckplyr/issues/34),
  [\#57](https://github.com/tidyverse/duckplyr/issues/57)).

- Fix 301 in README.

## duckplyr 0.2.1 (2023-09-16)

CRAN release: 2023-09-17

- Improve documentation.

- Work around problem with
  [`dplyr_reconstruct()`](https://dplyr.tidyverse.org/reference/dplyr_extending.html)
  in R 4.3.

- Rename `duckdb_from_file()` to
  [`df_from_file()`](https://duckplyr.tidyverse.org/dev/reference/df_from_file.md).

- Unexport private `duckdb_rel_from_df()`, `rel_from_df()`, `wrap_df()`
  and `wrap_integer()`.

- Reexport `%>%` and
  [`tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## duckplyr 0.2.0 (2023-09-10)

CRAN release: 2023-09-10

- Implement relational API for DuckDB.

## duckplyr 0.1.0 (2023-07-03)

CRAN release: 2023-07-07

### Bug fixes

- Fix examples.

### Chore

- Add CRAN install instructions.
- Satisfy `R CMD check`.
- Document argument.
- Error on NOTE.
- Remove
  [`relexpr_window()`](https://duckplyr.tidyverse.org/dev/reference/new_relexpr.md)
  for now.

### Documentation

- Clean up reference.

### Uncategorized

Initial version, exporting: -
[`new_relational()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md)
to construct objects of class `"relational"` - Generics
[`rel_aggregate()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_distinct()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_filter()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_join()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_limit()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_names()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_order()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_project()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_set_diff()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_set_intersect()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_set_symdiff()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_to_df()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md),
[`rel_union_all()`](https://duckplyr.tidyverse.org/dev/reference/new_relational.md) -
[`new_relexpr()`](https://duckplyr.tidyverse.org/dev/reference/new_relexpr.md)
to construct objects of class `"relational_relexpr"` - Expression
builders
[`relexpr_constant()`](https://duckplyr.tidyverse.org/dev/reference/new_relexpr.md),
[`relexpr_function()`](https://duckplyr.tidyverse.org/dev/reference/new_relexpr.md),
[`relexpr_reference()`](https://duckplyr.tidyverse.org/dev/reference/new_relexpr.md),
[`relexpr_set_alias()`](https://duckplyr.tidyverse.org/dev/reference/new_relexpr.md),
[`relexpr_window()`](https://duckplyr.tidyverse.org/dev/reference/new_relexpr.md)
