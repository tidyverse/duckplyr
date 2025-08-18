# fallback_sitrep() default

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, data will be collected but no data will be uploaded.
      x Fallback printing is disabled.
      x Fallback logging is disabled.
      i Automatic fallback uploading is not controlled and therefore disabled, see `?duckplyr::fallback()`.
      i See `?duckplyr::fallback_config()` for details.

# fallback_sitrep() enabled

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, data will be collected but no data will be uploaded.
      x Fallback printing is disabled.
      x Fallback logging is disabled.
      v Automatic fallback uploading is enabled.
      i See `?duckplyr::fallback_config()` for details.

# fallback_sitrep() enabled silent

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, data will be collected but no data will be uploaded.
      v Fallback printing is enabled.
      x Fallback logging is disabled.
      v Automatic fallback uploading is enabled.
      i See `?duckplyr::fallback_config()` for details.

# fallback_sitrep() disabled

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, data will be collected but no data will be uploaded.
      x Fallback printing is disabled.
      x Fallback logging is disabled.
      x Automatic fallback uploading is disabled.
      i See `?duckplyr::fallback_config()` for details.

# summarize()

    Code
      duckdb_tibble(a = 1, b = 2, c = 3) %>% summarize(.by = a, e = sum(b), f = sum(e))
    Output
      # A duckplyr data frame: 3 variables
            a     e     f
        <dbl> <dbl> <dbl>
      1     1     2     2

# wday()

    Code
      duckdb_tibble(a = as.Date("2024-03-08")) %>% mutate(b = lubridate::wday(a,
        label = TRUE))
    Output
      # A duckplyr data frame: 2 variables
        a          b    
        <date>     <ord>
      1 2024-03-08 Fri  

---

    Code
      duckdb_tibble(a = as.Date("2024-03-08")) %>% mutate(b = lubridate::wday(a))
    Output
      # A duckplyr data frame: 2 variables
        a              b
        <date>     <dbl>
      1 2024-03-08     5

# strftime()

    Code
      duckdb_tibble(a = as.Date("2024-03-08")) %>% mutate(b = strftime(a, format = "%Y-%m-%d",
        tz = "CET"))
    Output
      # A duckplyr data frame: 2 variables
        a          b         
        <date>     <chr>     
      1 2024-03-08 2024-03-08

# $

    Code
      duckdb_tibble(a = 1, b = 2) %>% mutate(c = .env$x)
    Condition
      Error in `mutate()`:
      i In argument: `c = .env$x`.
      Caused by error:
      ! object 'x' not found

# unknown function

    Code
      duckdb_tibble(a = 1, b = 2) %>% mutate(c = foo(a, b))
    Output
      # A duckplyr data frame: 3 variables
            a     b     c
        <dbl> <dbl> <dbl>
      1     1     2     3

# row names

    Code
      mtcars[1:2, ] %>% as_duckdb_tibble() %>% select(mpg, cyl)
    Output
      # A duckplyr data frame: 2 variables
          mpg   cyl
        <dbl> <dbl>
      1    21     6
      2    21     6

# named column

    Code
      duckdb_tibble(a = c(x = 1))
    Condition
      Error in `duckdb_tibble()`:
      ! Can't convert named vectors to relational. Affected column: `a`.

---

    Code
      duckdb_tibble(a = matrix(1:4, ncol = 2))
    Condition
      Error in `duckdb_tibble()`:
      ! Can't convert arrays or matrices to relational. Affected column: `a`.

# list column

    Code
      duckdb_tibble(a = 1, b = 2, c = list(3))
    Condition
      Error in `duckdb_tibble()`:
      ! Can't convert columns of class <list> to relational. Affected column: `c`.

# __row_number

    Code
      duckdb_tibble(`___row_number` = 1, b = 2:3) %>% arrange(b)
    Output
      # A duckplyr data frame: 2 variables
        `___row_number`     b
                  <dbl> <int>
      1               1     2
      2               1     3

# rel_try()

    Code
      duckdb_tibble(a = 1) %>% count(a, .drop = FALSE, name = "n")
    Output
      # A duckplyr data frame: 2 variables
            a     n
        <dbl> <int>
      1     1     1

# fallback_config()

    Code
      # No conflicts
      fallback_config_load()

---

    Code
      # Reset and set config
      fallback_config(reset_all = TRUE, logging = FALSE)
    Message
      i Restart the R session to reset all values to their defaults.

---

    Code
      # Conflicts with environment variable and setting
      fallback_config_load()
    Message
      Some configuration values are set as environment variables and in the configuration file 'fallback.dcf':
      * `logging`
      i Use `duckplyr::fallback_config(reset_all = TRUE)` to reset the configuration.
      i Use `usethis::edit_r_environ()` to edit '~/.Renviron'.

---

    Code
      # Reset config
      fallback_config(reset_all = TRUE)
    Message
      i Restart the R session to reset all values to their defaults.

---

    Code
      fallback_config(boo = FALSE)
    Condition
      Error in `fallback_config()`:
      ! `...` must be empty.
      x Problematic argument:
      * boo = FALSE

# fallback_config() failure

    Code
      fallback_config_load()
    Message
      Error reading duckplyr, fallback configuration, deleting file.
      Caused by error in `read.dcf()`:
      ! Invalid DCF format.
      Regular lines must have a tag.
      Offending lines start with:
        boo

---

    Code
      fallback_config_load()

