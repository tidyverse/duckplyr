# telemetry and anti_join()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% anti_join(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% anti_join(tibble(a = 1:3, b = 4:
        6), by = "a", copy = FALSE, na_matches = "na")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% anti_join(tibble(a = 1:3, b = 4:
        6), by = c(a = "b"), copy = FALSE, na_matches = "na")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% anti_join(tibble(a = 1:3, b = 4:
        6), by = join_by(a == b), copy = FALSE, na_matches = "never")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and arrange()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% arrange(a)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% arrange(a, .by_group = TRUE)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and count()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% count(a)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% count(a, wt = b, sort = TRUE,
        name = "nn", .drop = FALSE)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and distinct()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% distinct(a)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% distinct(a, b, .keep_all = TRUE)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and filter()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% filter(a > 1)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% filter(a > 1, .by = b)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% filter(a > 1, .preserve = TRUE)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and full_join()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% full_join(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% full_join(tibble(a = 1:3, b = 4:
        6), by = "a", copy = TRUE, suffix = c("x", "y"), keep = TRUE, na_matches = "na",
      multiple = "all", relationship = "one-to-one")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and inner_join()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% inner_join(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% inner_join(tibble(a = 1:3, b = 4:
        6), by = "a", copy = TRUE, suffix = c("x", "y"), keep = TRUE, na_matches = "na",
      multiple = "all", unmatched = "error", relationship = "one-to-one")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and intersect()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% intersect(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `rel_try()`:
      ! intersect: {"version":"0.3.1","message":"Error in intersect","name":"intersect","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"}}

# telemetry and left_join()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% left_join(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% left_join(tibble(a = 1:3, b = 4:
        6), by = "a", copy = TRUE, suffix = c("x", "y"), keep = TRUE, na_matches = "na",
      multiple = "all", unmatched = "error", relationship = "one-to-one")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and mutate()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% mutate(c = a + b)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% mutate(c = a + b, .by = a,
      .keep = "unused", )
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and relocate()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% relocate(b)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% relocate(b, .before = a)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% relocate(a, .after = b)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and rename()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% rename(c = a)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and right_join()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% right_join(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% right_join(tibble(a = 1:3, b = 4:
        6), by = "a", copy = TRUE, suffix = c("x", "y"), keep = TRUE, na_matches = "na",
      multiple = "all", unmatched = "error", relationship = "one-to-one")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and select()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% select(c = b)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and semi_join()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% semi_join(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% semi_join(tibble(a = 1:3, b = 4:
        6), by = "a", copy = TRUE, na_matches = "na")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and setdiff()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% setdiff(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `rel_try()`:
      ! setdiff: {"version":"0.3.1","message":"Error in setdiff","name":"setdiff","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"}}

# telemetry and summarise()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% summarise(c = sum(b))
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% summarise(c = sum(b), .by = a)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

---

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% summarise(c = sum(b),
      .groups = "rowwise")
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and symdiff()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% symdiff(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `rel_try()`:
      ! symdiff: {"version":"0.3.1","message":"Error in symdiff","name":"symdiff","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"}}

# telemetry and transmute()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% transmute(c = a + b)
    Condition
      Error in `...names()`:
      ! could not find function "...names"

# telemetry and union_all()

    Code
      tibble(a = 1:3, b = 4:6) %>% as_duckplyr_df() %>% union_all(tibble(a = 1:3, b = 4:
        6))
    Condition
      Error in `rel_try()`:
      ! union_all: {"version":"0.3.1","message":"Error in union_all","name":"union_all","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"}}

# scrubbing function declarations

    Code
      expr <- expr(across(x:y, function(arg) mean(arg, na.rm = TRUE)))
      expr_scrub(expr)
    Output
      across(...1:...2, function(arg) mean(...3, na.rm = TRUE))

