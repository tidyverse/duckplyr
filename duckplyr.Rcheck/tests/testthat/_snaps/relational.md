# rel_try() with reason

    Code
      rel_try(NULL, `Not affected: {.code FALSE}` = FALSE, `Affected: {.code TRUE}` = TRUE,
        { })
    Message
      Cannot process duckplyr query with DuckDB, falling back to dplyr.
      i Affected: `TRUE`
    Output
      [1] "Affected: {.code TRUE}"

