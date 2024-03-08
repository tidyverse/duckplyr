# fallback_sitrep() default

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. See `?duckplyr::fallback()` for details.
      i Fallback logging is not controlled. Enable or disable it by setting the `DUCKPLYR_FALLBACK_COLLECT` environment variable.
      i Fallback uploading is not controlled. Enable or disable it by setting the `DUCKPLYR_FALLBACK_AUTOUPLOAD` environment variable.
      i If enabled, logs are written to 'fallback/log/dir'.
      i No reports ready for upload.

# fallback_sitrep() enabled

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. See `?duckplyr::fallback()` for details.
      v Fallback logging is enabled.
      v Fallback uploading is enabled.
      i If enabled, logs are written to 'fallback/log/dir'.
      v Number of reports ready for upload: 3. Review with `duckplyr::fallback_review()`, upload with `duckplyr::fallback_upload()`}

# fallback_sitrep() disabled

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. See `?duckplyr::fallback()` for details.
      x Fallback logging is disabled.
      x Fallback uploading is disabled.
      i If enabled, logs are written to 'fallback/log/dir'.
      v Number of reports ready for upload: 3. Review with `duckplyr::fallback_review()`, upload with `duckplyr::fallback_upload()`}

# fallback_nudge()

    Code
      fallback_nudge("{foo:1, bar:2}")
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. See `?duckplyr::fallback()` for details.
      i A fallback situation just occurred. The following information would have been recorded:
        {foo:1, bar:2}
      i This message will be displayed once every eight hours.

