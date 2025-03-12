# fallback_sitrep() default

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, data will be collected but no data will be uploaded.
      x Fallback printing is disabled.
      v Fallback logging is enabled.
      i Fallback logging is not controlled, see `?duckplyr::fallback()`.
      i Logs are written to 'fallback/log/dir'.
      i Automatic fallback uploading is not controlled and therefore disabled, see `?duckplyr::fallback()`.
      i No reports ready for upload.
      i See `?duckplyr::fallback_config()` for details.

# fallback_sitrep() enabled

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, data will be collected but no data will be uploaded.
      x Fallback printing is disabled.
      v Fallback logging is enabled.
      i Logs are written to 'fallback/log/dir'.
      v Automatic fallback uploading is enabled.
      v Number of reports ready for upload: 3.
      > Review with `duckplyr::fallback_review()`, upload with `duckplyr::fallback_upload()`.
      i See `?duckplyr::fallback_config()` for details.

# fallback_sitrep() enabled silent

    Code
      fallback_sitrep()
    Message
      The duckplyr package is configured to fall back to dplyr when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, data will be collected but no data will be uploaded.
      v Fallback printing is enabled.
      v Fallback logging is enabled.
      i Logs are written to 'fallback/log/dir'.
      v Automatic fallback uploading is enabled.
      v Number of reports ready for upload: 3.
      > Review with `duckplyr::fallback_review()`, upload with `duckplyr::fallback_upload()`.
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
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Can't reuse summary variable `...4`.","name":"summarise","x":{"...1":"numeric","...2":"numeric","...3":"numeric"},"args":{"dots":{"...4":"sum(...2)","...5":"sum(...4)"},"by":["...1"]}}
    Output
      # A duckplyr data frame: 3 variables
            a     e     f
        <dbl> <dbl> <dbl>
      1     1     2     2

# wday()

    Code
      duckdb_tibble(a = as.Date("2024-03-08")) %>% mutate(b = lubridate::wday(a,
        label = TRUE))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"wday(label = ) not supported","name":"mutate","x":{"...1":"Date"},"args":{"dots":{"...2":"...3::...4(...1, label = TRUE)"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Output
      # A duckplyr data frame: 2 variables
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Can't convert columns of class <ordered/factor> to relational. Affected column: `...2`.","name":"head","x":{"...1":"Date","...2":"ordered/factor"},"args":{"n":21}}
    Output
        a          b    
        <date>     <ord>
      1 2024-03-08 Fri  

---

    Code
      duckdb_tibble(a = as.Date("2024-03-08")) %>% mutate(b = lubridate::wday(a))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"`wday()` with `option(\"lubridate.week.start\")` not supported","name":"mutate","x":{"...1":"Date"},"args":{"dots":{"...2":"...3::...4(...1)"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Output
      # A duckplyr data frame: 2 variables
        a              b
        <date>     <dbl>
      1 2024-03-08     5

# strftime()

    Code
      duckdb_tibble(a = as.Date("2024-03-08")) %>% mutate(b = strftime(a, format = "%Y-%m-%d",
        tz = "CET"))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"strftime(tz = ) not supported","name":"mutate","x":{"...1":"Date"},"args":{"dots":{"...2":"strftime(...1, format = \"<character>\", tz = \"<character>\")"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Output
      # A duckplyr data frame: 2 variables
        a          b         
        <date>     <chr>     
      1 2024-03-08 2024-03-08

# $

    Code
      duckdb_tibble(a = 1, b = 2) %>% mutate(c = .env$x)
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"object not found, should also be triggered by the dplyr fallback","name":"mutate","x":{"...1":"numeric","...2":"numeric"},"args":{"dots":{"...3":"...4$...5"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Condition
      Error in `mutate()`:
      i In argument: `c = .env$x`.
      Caused by error:
      ! object 'x' not found

# unknown function

    Code
      duckdb_tibble(a = 1, b = 2) %>% mutate(c = foo(a, b))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"No translation for function `foo()`.","name":"mutate","x":{"...1":"numeric","...2":"numeric"},"args":{"dots":{"...3":"foo(...1, ...2)"},".by":"NULL",".keep":["all","used","unused","none"]}}
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
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Can't use column `...1` already present in rel for order preservation","name":"arrange","x":{"...1":"numeric","...2":"integer"},"args":{"dots":["...2"],".by_group":false}}
    Output
      # A duckplyr data frame: 2 variables
        `___row_number`     b
                  <dbl> <int>
      1               1     2
      2               1     3

# rel_try()

    Code
      duckdb_tibble(a = 1) %>% count(a, .drop = FALSE, name = "n")
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"{.code count()} only implemented for {.arg .drop} = {.value TRUE}","name":"count","x":{"...1":"numeric"},"args":{"dots":{"1":"...1"},"wt":"NULL","sort":false,".drop":false}}
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Try {.code summarise(.by = ...)} or {.code mutate(.by = ...)} instead of {.code group_by()} and {.code ungroup()}."}
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

