# fallback_sitrep() default

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, no data will be collected or uploaded.
      i Fallback logging is not controlled and therefore disabled. Enable it with `Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 1)`, disable it with `Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 0)`.
      i Fallback uploading is not controlled and therefore disabled. Enable it with `Sys.setenv(DUCKPLYR_FALLBACK_AUTOUPLOAD = 1)`, disable it with `Sys.setenv(DUCKPLYR_FALLBACK_AUTOUPLOAD = 0)`.
      i See `?duckplyr::fallback()` for details.

# fallback_sitrep() enabled

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, no data will be collected or uploaded.
      v Fallback logging is enabled.
      i Logs are written to 'fallback/log/dir'.
      x Fallback printing is disabled.
      v Fallback uploading is enabled.
      v Number of reports ready for upload: 3.
      > Review with `duckplyr::fallback_review()`, upload with `duckplyr::fallback_upload()`.
      i See `?duckplyr::fallback()` for details.

# fallback_sitrep() enabled silent

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, no data will be collected or uploaded.
      v Fallback logging is enabled.
      i Logs are written to 'fallback/log/dir'.
      x Fallback printing is disabled.
      v Fallback uploading is enabled.
      v Number of reports ready for upload: 3.
      > Review with `duckplyr::fallback_review()`, upload with `duckplyr::fallback_upload()`.
      i See `?duckplyr::fallback()` for details.

# fallback_sitrep() disabled

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, no data will be collected or uploaded.
      x Fallback logging is disabled.
      x Fallback uploading is disabled.
      i See `?duckplyr::fallback()` for details.

# fallback_nudge()

    Code
      fallback_nudge("{foo:1, bar:2}")
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, no data will be collected or uploaded.
      i A fallback situation just occurred. The following information would have been recorded:
        {foo:1, bar:2}
      > Run `duckplyr::fallback_sitrep()` to review the current settings.
      > Run `Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 1)` to enable fallback logging, and `Sys.setenv(DUCKPLYR_FALLBACK_VERBOSE = 1)` in addition to enable printing of fallback situations to the console.
      > Run `duckplyr::fallback_review()` to review the available reports, and `duckplyr::fallback_upload()` to upload them.
      i See `?duckplyr::fallback()` for details.
      i This message will be displayed once every eight hours.

