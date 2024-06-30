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
      > Run `Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 1)` to enable fallback logging, and `Sys.setenv(DUCKPLYR_FALLBACK_VERBOSE = TRUE)` in addition to enable printing of fallback situations to the console.
      > Run `duckplyr::fallback_review()` to review the available reports, and `duckplyr::fallback_upload()` to upload them.
      i See `?duckplyr::fallback()` for details.
      i This message will be displayed once every eight hours.

# summarize()

    Code
      tibble(a = 1, b = 2, c = 3) %>% as_duckplyr_df() %>% summarize(.by = a, e = sum(
        b), f = sum(e))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Can't reuse summary variable `...4`.","name":"summarise","x":{"...1":"numeric","...2":"numeric","...3":"numeric"},"args":{"dots":{"...4":"sum(...2)","...5":"sum(...4)"},"by":["...1"]}}
    Output
      # A tibble: 1 x 3
            a     e     f
        <dbl> <dbl> <dbl>
      1     1     2     2

# wday()

    Code
      tibble(a = as.Date("2024-03-08")) %>% as_duckplyr_df() %>% mutate(b = lubridate::wday(
        a, label = TRUE))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"wday(label = ) not supported","name":"mutate","x":{"...1":"Date"},"args":{"dots":{"...2":"...3::...4(...1, label = TRUE)"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Output
      # A tibble: 1 x 2
        a          b    
        <date>     <ord>
      1 2024-03-08 Fri  

---

    Code
      tibble(a = as.Date("2024-03-08")) %>% as_duckplyr_df() %>% mutate(b = lubridate::wday(
        a))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"`wday()` with `option(\"lubridate.week.start\")` not supported","name":"mutate","x":{"...1":"Date"},"args":{"dots":{"...2":"...3::...4(...1)"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Output
      # A tibble: 1 x 2
        a              b
        <date>     <dbl>
      1 2024-03-08     5

# strftime()

    Code
      tibble(a = as.Date("2024-03-08")) %>% as_duckplyr_df() %>% mutate(b = strftime(
        a, format = "%Y-%m-%d", tz = "CET"))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"strftime(tz = ) not supported","name":"mutate","x":{"...1":"Date"},"args":{"dots":{"...2":"strftime(...1, format = \"<character>\", tz = \"<character>\")"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Output
      # A tibble: 1 x 2
        a          b         
        <date>     <chr>     
      1 2024-03-08 2024-03-08

# $

    Code
      tibble(a = 1, b = 2) %>% as_duckplyr_df() %>% mutate(c = .env$x)
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"internal: object not found, should also be triggered by the dplyr fallback","name":"mutate","x":{"...1":"numeric","...2":"numeric"},"args":{"dots":{"...3":"...4$...5"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Condition
      Error in `mutate()`:
      i In argument: `c = .env$x`.
      Caused by error:
      ! object 'x' not found

# unknown function

    Code
      tibble(a = 1, b = 2) %>% as_duckplyr_df() %>% mutate(c = foo(a, b))
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"No translation for function `foo`.","name":"mutate","x":{"...1":"numeric","...2":"numeric"},"args":{"dots":{"...3":"foo(...1, ...2)"},".by":"NULL",".keep":["all","used","unused","none"]}}
    Output
      # A tibble: 1 x 3
            a     b     c
        <dbl> <dbl> <dbl>
      1     1     2     3

# row names

    Code
      mtcars[1:2, ] %>% as_duckplyr_df() %>% select(mpg, cyl)
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Need data frame without row names to convert to relational, got character row names.","name":"select","x":{"...1":"numeric","...2":"numeric","...3":"numeric","...4":"numeric","...5":"numeric","...6":"numeric","...7":"numeric","...8":"numeric","...9":"numeric","...10":"numeric","...11":"numeric"},"args":{"dots":{"1":"...1","2":"...2"}}}
    Output
                    mpg cyl
      Mazda RX4      21   6
      Mazda RX4 Wag  21   6

# named column

    Code
      tibble(a = c(x = 1)) %>% as_duckplyr_df() %>% select(a)
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Can't convert named vectors to relational. Affected column: `...1`.","name":"select","x":{"...1":"numeric"},"args":{"dots":{"1":"...1"}}}
    Output
      # A tibble: 1 x 1
            a
        <dbl>
      1     1

---

    Code
      tibble(a = matrix(1:4, ncol = 2)) %>% as_duckplyr_df() %>% select(a)
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Can't convert arrays or matrices to relational. Affected column: `...1`.","name":"select","x":{"...1":"matrix/array"},"args":{"dots":{"1":"...1"}}}
    Output
      # A tibble: 2 x 1
        a[,1]  [,2]
        <int> <int>
      1     1     3
      2     2     4

# list column

    Code
      tibble(a = 1, b = 2, c = list(3)) %>% as_duckplyr_df() %>% select(a, b)
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Can't convert columns of class <list> to relational. Affected column: `...3`.","name":"select","x":{"...1":"numeric","...2":"numeric","...3":"list"},"args":{"dots":{"1":"...1","2":"...2"}}}
    Output
      # A tibble: 1 x 2
            a     b
        <dbl> <dbl>
      1     1     2

# __row_number

    Code
      tibble(`___row_number` = 1, b = 2:3) %>% as_duckplyr_df() %>% arrange(b)
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"Can't use column `...1` already present in rel for order preservation","name":"arrange","x":{"...1":"numeric","...2":"integer"},"args":{"dots":["...2"],".by_group":false}}
    Output
      # A tibble: 2 x 2
        `___row_number`     b
                  <dbl> <int>
      1               1     2
      2               1     3

# rel_try()

    Code
      tibble(a = 1) %>% as_duckplyr_df() %>% count(a, .drop = FALSE, name = "n")
    Message
      i dplyr fallback recorded
        {"version":"0.3.1","message":"count() only implemented for .drop = TRUE","name":"count","x":{"...1":"numeric"},"args":{"dots":{"1":"...1"},"wt":"NULL","sort":false,"name":"...3",".drop":false}}
      i dplyr fallback recorded
        {"version":"0.3.1","message":"No relational implementation for group_by()"}
    Output
      # A tibble: 1 x 2
            a     n
        <dbl> <int>
      1     1     1

