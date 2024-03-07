# telemetry and arrange()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% arrange(a, .by_group = TRUE)
    Condition
      Error in `rel_try()`:
      ! arrange: {"name":"arrange","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list",".by_group":true}}

# telemetry and count()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% count(a, wt = b, sort = TRUE,
        name = "nn", .drop = FALSE)
    Condition
      Error in `rel_try()`:
      ! count: {"name":"count","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list","wt":"Can't translate object of class quosure/formula","sort":true,"name":"nn",".drop":false}}

# telemetry and distinct()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% distinct(a, b, .keep_all = TRUE)
    Condition
      Error in `rel_try()`:
      ! distinct: {"name":"distinct","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list",".keep_all":true}}

# telemetry and filter()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% filter(a > 1, .by = b)
    Condition
      Error in `rel_try()`:
      ! filter: {"name":"filter","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list","by":"Can't translate object of class quosure/formula","preserve":false}}

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% filter(a > 1, .preserve = TRUE)
    Condition
      Error in `rel_try()`:
      ! filter: {"name":"filter","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list","by":"Can't translate object of class quosure/formula","preserve":true}}

# telemetry and intersect()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% intersect(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `rel_try()`:
      ! intersect: {"name":"intersect","x":{"...1":"integer","...2":"integer"},"y":{"a":"integer","b":"integer"}}

# telemetry and mutate()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% mutate(c = a + b, .by = a,
      .keep = "unused", )
    Condition
      Error in `rel_try()`:
      ! mutate: {"name":"mutate","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list",".by":"Can't translate object of class quosure/formula",".keep":"unused"}}

# telemetry and relocate()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% relocate(b)
    Condition
      Error in `rel_try()`:
      ! relocate: {"name":"relocate","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list"}}

# telemetry and rename()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% rename(c = a)
    Condition
      Error in `rel_try()`:
      ! rename: {"name":"rename","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list"}}

# telemetry and select()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% select(c = b)
    Condition
      Error in `rel_try()`:
      ! select: {"name":"select","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list"}}

# telemetry and setdiff()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% setdiff(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `rel_try()`:
      ! setdiff: {"name":"setdiff","x":{"...1":"integer","...2":"integer"},"y":{"a":"integer","b":"integer"}}

# telemetry and summarise()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% summarise(c = sum(b), .by = a)
    Condition
      Error in `rel_try()`:
      ! summarise: {"name":"summarise","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list","by":"a"}}

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% summarise(c = sum(b),
      .groups = "rowwise")
    Condition
      Error in `rel_try()`:
      ! summarise: {"name":"summarise","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list",".groups":"rowwise"}}

# telemetry and symdiff()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% symdiff(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `rel_try()`:
      ! symdiff: {"name":"symdiff","x":{"...1":"integer","...2":"integer"},"y":{"a":"integer","b":"integer"}}

# telemetry and transmute()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% transmute(c = a + b)
    Condition
      Error in `rel_try()`:
      ! transmute: {"name":"transmute","x":{"...1":"integer","...2":"integer"},"args":{"dots":"Can't translate object of class quosures/list"}}

# telemetry and union_all()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% union_all(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `rel_try()`:
      ! union_all: {"name":"union_all","x":{"...1":"integer","...2":"integer"},"y":{"a":"integer","b":"integer"}}

