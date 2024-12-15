# telemetry and anti_join()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% anti_join(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! anti_join: {"version":"0.3.1","message":"Error in anti_join","name":"anti_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"copy":false,"na_matches":"na"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% anti_join(tibble(a = 1:3, b = 4:6), by = "a",
      copy = FALSE, na_matches = "na")
    Condition
      Error in `rel_try()`:
      ! anti_join: {"version":"0.3.1","message":"Error in anti_join","name":"anti_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"by":{"condition":"==","filter":"none","x":["...1"],"y":["...1"]},"copy":false,"na_matches":"na"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% anti_join(tibble(a = 1:3, b = 4:6), by = c(a = "b"),
      copy = FALSE, na_matches = "na")
    Condition
      Error in `rel_try()`:
      ! anti_join: {"version":"0.3.1","message":"Error in anti_join","name":"anti_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"by":{"condition":"==","filter":"none","x":["...1"],"y":["...2"]},"copy":false,"na_matches":"na"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% anti_join(tibble(a = 1:3, b = 4:6), by = join_by(
        a == b), copy = FALSE, na_matches = "never")
    Condition
      Error in `rel_try()`:
      ! anti_join: {"version":"0.3.1","message":"Error in anti_join","name":"anti_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"by":{"condition":"==","filter":"none","x":["...1"],"y":["...2"]},"copy":false,"na_matches":"never"}}

# telemetry and arrange()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% arrange(a)
    Condition
      Error in `rel_try()`:
      ! arrange: {"version":"0.3.1","message":"Error in arrange","name":"arrange","x":{"...1":"integer","...2":"integer"},"args":{"dots":["...1"],".by_group":false}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% arrange(a, .by_group = TRUE)
    Condition
      Error in `rel_try()`:
      ! arrange: {"version":"0.3.1","message":"Error in arrange","name":"arrange","x":{"...1":"integer","...2":"integer"},"args":{"dots":["...1"],".by_group":true}}

# telemetry and count()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% count(a)
    Condition
      Error in `rel_try()`:
      ! count: {"version":"0.3.1","message":"Error in count","name":"count","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"1":"...1"},"wt":"NULL","sort":false,".drop":true}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% count(a, wt = b, sort = TRUE, name = "nn", .drop = FALSE)
    Condition
      Error in `rel_try()`:
      ! count: {"version":"0.3.1","message":"Error in count","name":"count","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"1":"...1"},"wt":"...2","sort":true,".drop":false}}

# telemetry and distinct()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% distinct(a)
    Condition
      Error in `rel_try()`:
      ! distinct: {"version":"0.3.1","message":"Error in distinct","name":"distinct","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...1":"...1"},".keep_all":false}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% distinct(a, b, .keep_all = TRUE)
    Condition
      Error in `rel_try()`:
      ! distinct: {"version":"0.3.1","message":"Error in distinct","name":"distinct","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...1":"...1","...2":"...2"},".keep_all":true}}

# telemetry and filter()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% filter(a > 1)
    Condition
      Error in `rel_try()`:
      ! filter: {"version":"0.3.1","message":"Error in filter","name":"filter","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"1":"...1 > 1"},"by":"NULL","preserve":false}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% filter(a > 1, .by = b)
    Condition
      Error in `rel_try()`:
      ! filter: {"version":"0.3.1","message":"Error in filter","name":"filter","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"1":"...1 > 1"},"by":"...2","preserve":false}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% filter(a > 1, .preserve = TRUE)
    Condition
      Error in `rel_try()`:
      ! filter: {"version":"0.3.1","message":"Error in filter","name":"filter","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"1":"...1 > 1"},"by":"NULL","preserve":true}}

# telemetry and full_join()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% full_join(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! full_join: {"version":"0.3.1","message":"Error in full_join","name":"full_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"copy":false,"na_matches":["na","never"],"multiple":"all"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% full_join(tibble(a = 1:3, b = 4:6), by = "a",
      copy = TRUE, suffix = c("x", "y"), keep = TRUE, na_matches = "na", multiple = "all",
      relationship = "one-to-one")
    Condition
      Error in `rel_try()`:
      ! full_join: {"version":"0.3.1","message":"Error in full_join","name":"full_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"by":{"condition":"==","filter":"none","x":["...1"],"y":["...1"]},"copy":true,"keep":true,"na_matches":"na","multiple":"all","relationship":"one-to-one"}}

# telemetry and inner_join()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% inner_join(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! inner_join: {"version":"0.3.1","message":"Error in inner_join","name":"inner_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"copy":false,"na_matches":["na","never"],"multiple":"all","unmatched":"drop"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% inner_join(tibble(a = 1:3, b = 4:6), by = "a",
      copy = TRUE, suffix = c("x", "y"), keep = TRUE, na_matches = "na", multiple = "all",
      unmatched = "error", relationship = "one-to-one")
    Condition
      Error in `rel_try()`:
      ! inner_join: {"version":"0.3.1","message":"Error in inner_join","name":"inner_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"by":{"condition":"==","filter":"none","x":["...1"],"y":["...1"]},"copy":true,"keep":true,"na_matches":"na","multiple":"all","unmatched":"error","relationship":"one-to-one"}}

# telemetry and intersect()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% intersect(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! intersect: {"version":"0.3.1","message":"Error in intersect","name":"intersect","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"}}

# telemetry and left_join()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% left_join(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! left_join: {"version":"0.3.1","message":"Error in left_join","name":"left_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"copy":false,"na_matches":["na","never"],"multiple":"all","unmatched":"drop"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% left_join(tibble(a = 1:3, b = 4:6), by = "a",
      copy = TRUE, suffix = c("x", "y"), keep = TRUE, na_matches = "na", multiple = "all",
      unmatched = "error", relationship = "one-to-one")
    Condition
      Error in `rel_try()`:
      ! left_join: {"version":"0.3.1","message":"Error in left_join","name":"left_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"by":{"condition":"==","filter":"none","x":["...1"],"y":["...1"]},"copy":true,"keep":true,"na_matches":"na","multiple":"all","unmatched":"error","relationship":"one-to-one"}}

# telemetry and mutate()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% mutate(c = a + b)
    Condition
      Error in `rel_try()`:
      ! mutate: {"version":"0.3.1","message":"Error in mutate","name":"mutate","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...3":"...1 + ...2"},".by":"NULL",".keep":["all","used","unused","none"]}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% mutate(c = a + b, .by = a, .keep = "unused", )
    Condition
      Error in `rel_try()`:
      ! mutate: {"version":"0.3.1","message":"Error in mutate","name":"mutate","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...3":"...1 + ...2"},".by":"...1",".keep":"unused"}}

# telemetry and relocate()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% relocate(b)
    Condition
      Error in `rel_try()`:
      ! relocate: {"version":"0.3.1","message":"Error in relocate","name":"relocate","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"1":"...2"},".before":"NULL",".after":"NULL"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% relocate(b, .before = a)
    Condition
      Error in `rel_try()`:
      ! relocate: {"version":"0.3.1","message":"Error in relocate","name":"relocate","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"1":"...2"},".before":"...1",".after":"NULL"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% relocate(a, .after = b)
    Condition
      Error in `rel_try()`:
      ! relocate: {"version":"0.3.1","message":"Error in relocate","name":"relocate","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"1":"...1"},".before":"NULL",".after":"...2"}}

# telemetry and rename()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% rename(c = a)
    Condition
      Error in `rel_try()`:
      ! rename: {"version":"0.3.1","message":"Error in rename","name":"rename","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...3":"...1"}}}

# telemetry and right_join()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% right_join(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! right_join: {"version":"0.3.1","message":"Error in right_join","name":"right_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"copy":false,"na_matches":["na","never"],"multiple":"all","unmatched":"drop"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% right_join(tibble(a = 1:3, b = 4:6), by = "a",
      copy = TRUE, suffix = c("x", "y"), keep = TRUE, na_matches = "na", multiple = "all",
      unmatched = "error", relationship = "one-to-one")
    Condition
      Error in `rel_try()`:
      ! right_join: {"version":"0.3.1","message":"Error in right_join","name":"right_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"by":{"condition":"==","filter":"none","x":["...1"],"y":["...1"]},"copy":true,"keep":true,"na_matches":"na","multiple":"all","unmatched":"error","relationship":"one-to-one"}}

# telemetry and select()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% select(c = b)
    Condition
      Error in `rel_try()`:
      ! select: {"version":"0.3.1","message":"Error in select","name":"select","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...3":"...2"}}}

# telemetry and semi_join()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% semi_join(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! semi_join: {"version":"0.3.1","message":"Error in semi_join","name":"semi_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"copy":false,"na_matches":"na"}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% semi_join(tibble(a = 1:3, b = 4:6), by = "a",
      copy = TRUE, na_matches = "na")
    Condition
      Error in `rel_try()`:
      ! semi_join: {"version":"0.3.1","message":"Error in semi_join","name":"semi_join","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"},"args":{"by":{"condition":"==","filter":"none","x":["...1"],"y":["...1"]},"copy":true,"na_matches":"na"}}

# telemetry and setdiff()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% setdiff(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! setdiff: {"version":"0.3.1","message":"Error in setdiff","name":"setdiff","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"}}

# telemetry and summarise()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% summarise(c = sum(b))
    Condition
      Error in `rel_try()`:
      ! summarise: {"version":"0.3.1","message":"Error in summarise","name":"summarise","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...3":"sum(...2)"}}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% summarise(c = sum(b), .by = a)
    Condition
      Error in `rel_try()`:
      ! summarise: {"version":"0.3.1","message":"Error in summarise","name":"summarise","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...3":"sum(...2)"},"by":["...1"]}}

---

    Code
      ducktbl(a = 1:3, b = 4:6) %>% summarise(c = sum(b), .groups = "rowwise")
    Condition
      Error in `rel_try()`:
      ! summarise: {"version":"0.3.1","message":"Error in summarise","name":"summarise","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...3":"sum(...2)"},".groups":"rowwise"}}

# telemetry and symdiff()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% symdiff(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! symdiff: {"version":"0.3.1","message":"Error in symdiff","name":"symdiff","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"}}

# telemetry and transmute()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% transmute(c = a + b)
    Condition
      Error in `rel_try()`:
      ! transmute: {"version":"0.3.1","message":"Error in transmute","name":"transmute","x":{"...1":"integer","...2":"integer"},"args":{"dots":{"...3":"...1 + ...2"}}}

# telemetry and union_all()

    Code
      ducktbl(a = 1:3, b = 4:6) %>% union_all(tibble(a = 1:3, b = 4:6))
    Condition
      Error in `rel_try()`:
      ! union_all: {"version":"0.3.1","message":"Error in union_all","name":"union_all","x":{"...1":"integer","...2":"integer"},"y":{"...1":"integer","...2":"integer"}}

# scrubbing function declarations

    Code
      expr <- expr(across(x:y, function(arg) mean(arg, na.rm = TRUE)))
      expr_scrub(expr)
    Output
      across(...1:...2, function(arg) mean(...3, na.rm = TRUE))

