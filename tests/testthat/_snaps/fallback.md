# fallback_sitrep() default

    Code
      fallback_sitrep()
    Message
      duckplyr falls back to dplyr when it encounters an incompatibility. We would like to find out about these events so we can make duckplyr better.
      v Fallback logging is on. Disable it with `duckplyr::fallback_logging_optout()`.
      i Logs are written to 'fallback/log/dir'. View them with `duckplyr::fallback_review()`.
      v Fallback messaging on screen is on. Disable it with `duckplyr::fallback_verbose_optout()`.
      x Fallback automatic uploading is off. Enable it with `duckplyr::fallback_reporting_optin()`.
      i No reports ready for upload.
      i See `?duckplyr::fallback()` for details.

# fallback_sitrep() enabled

    Code
      fallback_sitrep()
    Message
      duckplyr falls back to dplyr when it encounters an incompatibility. We would like to find out about these events so we can make duckplyr better.
      v Fallback logging is on. Disable it with `duckplyr::fallback_logging_optout()`.
      i Logs are written to 'fallback/log/dir'. View them with `duckplyr::fallback_review()`.
      v Fallback messaging on screen is on. Disable it with `duckplyr::fallback_verbose_optout()`.
      v Fallback automatic uploading is on. Disable it with `duckplyr::fallback_reporting_optout()`.
      v Number of reports ready for upload: 3.
      > Review with `duckplyr::fallback_review()`, upload with `duckplyr::fallback_upload()`.
      i See `?duckplyr::fallback()` for details.

# fallback_sitrep() enabled silent

    Code
      fallback_sitrep()
    Message
      duckplyr falls back to dplyr when it encounters an incompatibility. We would like to find out about these events so we can make duckplyr better.
      v Fallback logging is on. Disable it with `duckplyr::fallback_logging_optout()`.
      i Logs are written to 'fallback/log/dir'. View them with `duckplyr::fallback_review()`.
      x Fallback messaging on screen is off. Enable it with `duckplyr::fallback_verbose_optin()`.
      v Fallback automatic uploading is on. Disable it with `duckplyr::fallback_reporting_optout()`.
      v Number of reports ready for upload: 3.
      > Review with `duckplyr::fallback_review()`, upload with `duckplyr::fallback_upload()`.
      i See `?duckplyr::fallback()` for details.

# fallback_sitrep() disabled

    Code
      fallback_sitrep()
    Message
      duckplyr falls back to dplyr when it encounters an incompatibility. We would like to find out about these events so we can make duckplyr better.
      x Fallback logging is off. Enable it with `duckplyr::fallback_logging_optin()`.
      x Fallback messaging on screen is off. Enable it with `duckplyr::fallback_verbose_optin()`.
      x Fallback automatic uploading is off. Enable it with `duckplyr::fallback_reporting_optin()`.
      i See `?duckplyr::fallback()` for details.

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
        {"version":"0.3.1","message":"count() only implemented for .drop = TRUE","name":"count","x":{"...1":"numeric"},"args":{"dots":{"1":"...1"},"wt":"NULL","sort":false,".drop":false}}
      i dplyr fallback recorded
        {"version":"0.3.1","message":"No relational implementation for group_by()"}
    Output
      # A tibble: 1 x 2
            a     n
        <dbl> <int>
      1     1     1

