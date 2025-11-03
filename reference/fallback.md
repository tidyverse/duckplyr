# Fallback to dplyr

The duckplyr package aims at providing a fully compatible drop-in
replacement for dplyr. To achieve this, only a carefully selected subset
of dplyr's operations, R functions, and R data types are implemented.
Whenever a request cannot be handled by DuckDB, duckplyr falls back to
dplyr. See `vignette("fallback"`)\` for details.

To assist future development, the fallback situations can be logged to
the console or to a local file and uploaded for analysis. By default,
duckplyr will not log or upload anything. The functions and environment
variables on this page control the process.

`fallback_sitrep()` prints the current settings for fallback printing,
logging, and uploading, the number of reports ready for upload, and the
location of the logs.

`fallback_config()` configures the current settings for fallback
printing, logging, and uploading. Only settings that do not affect
computation results can be configured, this is by design. The
configuration is stored in a file under
`tools::R_user_dir("duckplyr", "config")` . When the duckplyr package is
loaded, the configuration is read from this file, and the corresponding
environment variables are set.

`fallback_review()` prints the available reports for review to the
console.

`fallback_upload()` uploads the available reports to a central server
for analysis. The server is hosted on AWS and the reports are stored in
a private S3 bucket. Only authorized personnel have access to the
reports.

`fallback_purge()` deletes some or all available reports.

## Usage

``` r
fallback_sitrep()

fallback_config(
  ...,
  reset_all = FALSE,
  info = NULL,
  logging = NULL,
  autoupload = NULL,
  log_dir = NULL,
  verbose = NULL
)

fallback_review(oldest = NULL, newest = NULL, detail = TRUE)

fallback_upload(oldest = NULL, newest = NULL, strict = TRUE)

fallback_purge(oldest = NULL, newest = NULL)
```

## Arguments

- ...:

  These dots are for future extensions and must be empty.

- reset_all:

  Set to `TRUE` to reset all settings to their defaults. The R session
  must be restarted for the changes to take effect.

- info:

  Set to `TRUE` to enable fallback printing.

- logging:

  Set to `FALSE` to disable fallback logging, set to `TRUE` to
  explicitly enable it.

- autoupload:

  Set to `TRUE` to enable automatic fallback uploading, set to `FALSE`
  to disable it.

- log_dir:

  Set the location of the logs in the file system. The directory will be
  created if it does not exist.

- verbose:

  Set to `TRUE` to enable verbose logging.

- oldest, newest:

  The number of oldest or newest reports to review. If not specified,
  all reports are dispayed.

- detail:

  Print the full content of the reports. Set to `FALSE` to only print
  the file names.

- strict:

  If `TRUE`, the function aborts if any of the reports fail to upload.
  With `FALSE`, only a message is printed.

## Details

Logging is on by default, but can be turned off. Uploading is opt-in.

The following environment variables control the logging and uploading:

- `DUCKPLYR_FALLBACK_INFO` controls human-friendly alerts for fallback
  events. If `TRUE`, a message is printed when a fallback to dplyr
  occurs because DuckDB cannot handle a request. These messages are
  never logged.

- `DUCKPLYR_FALLBACK_COLLECT` controls logging, set it to 1 or greater
  to enable logging. If the value is 0, logging is disabled. Future
  versions of duckplyr may start logging additional data and thus
  require a higher value to enable logging. Set to 99 to enable logging
  for all future versions. Use
  [`usethis::edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)
  to edit the environment file.

- `DUCKPLYR_FALLBACK_AUTOUPLOAD` controls uploading, set it to 1 or
  greater to enable uploading. If the value is 0, uploading is disabled.
  Currently, uploading is active if the value is 1 or greater. Future
  versions of duckplyr may start logging additional data and thus
  require a higher value to enable uploading. Set to 99 to enable
  uploading for all future versions. Use
  [`usethis::edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)
  to edit the environment file.

- `DUCKPLYR_FALLBACK_LOG_DIR` controls the location of the logs. It must
  point to a directory (existing or not) where the logs will be written.
  By default, logs are written to a directory in the user's cache
  directory as returned by `tools::R_user_dir("duckplyr", "cache")`.

- `DUCKPLYR_FALLBACK_VERBOSE` controls printing of log data, set it to
  `TRUE` or `FALSE` to enable or disable printing. If the value is
  `TRUE`, a message is printed to the console for each fallback
  situation. This setting is only relevant if logging is enabled, and
  mostly useful for duckplyr's internal tests.

All code related to fallback logging and uploading is in the
[`fallback.R`](https://github.com/tidyverse/duckplyr/blob/main/R/fallback.R)
and
[`telemetry.R`](https://github.com/tidyverse/duckplyr/blob/main/R/telemetry.R)
files.

## Examples

``` r
fallback_sitrep()
#> The duckplyr package is configured to fall back to dplyr when it
#> encounters an incompatibility. Fallback events can be collected and
#> uploaded for analysis to guide future development. By default, data
#> will be collected but no data will be uploaded.
#> ✖ Fallback printing is disabled.
#> ✖ Fallback logging is disabled.
#> ✖ Automatic fallback uploading is disabled.
#> ℹ See `?duckplyr::fallback_config()` for details.
```
