# duckplyr_expand_across() successful

    Code
      test_duckplyr_expand_across(c("x", "y"), across(x:y, mean))
    Output
      tibble(x = base::mean(x), y = base::mean(y))

---

    Code
      test_duckplyr_expand_across(c("x", "y"), across(x:y, function(x) mean(x)))
    Output
      NULL

---

    Code
      test_duckplyr_expand_across(c("x", "y"), across(c(x_mean = x, y_mean = y), mean))
    Output
      tibble(x_mean = base::mean(x), y_mean = base::mean(y))

---

    Code
      test_duckplyr_expand_across(c("x", "y"), across(c(x_mean = x, y_mean = y), mean,
      .names = "{.col}_{.fn}"))
    Output
      tibble(x_mean_1 = base::mean(x), y_mean_1 = base::mean(y))

---

    Code
      test_duckplyr_expand_across(c("x", "y"), across(x:y, function(x) mean(x, na.rm = TRUE)))
    Output
      NULL

---

    Code
      test_duckplyr_expand_across(c("x", "y", "a"), across(c(a, x), function(x) x + 1))
    Output
      NULL

---

    Code
      test_duckplyr_expand_across(c("x", "y", "a"), across(c(a, x), function(x) x *
      2 + 1))
    Output
      NULL

---

    Code
      test_duckplyr_expand_across(c("x", "y", "a"), across(-a, function(x) x * x))
    Output
      NULL

---

    Code
      test_duckplyr_expand_across(c("x", "y"), across(x:y, base::mean))
    Output
      tibble(x = base::mean(x), y = base::mean(y))

---

    Code
      test_duckplyr_expand_across(c("x", "y"), across(x:y, list(mean)))
    Output
      tibble(x_1 = base::mean(x), y_1 = base::mean(y))

---

    Code
      test_duckplyr_expand_across(c("x", "y"), across(x:y, list(mean = mean)))
    Output
      tibble(x_mean = base::mean(x), y_mean = base::mean(y))

---

    Code
      test_duckplyr_expand_across(c("x", "y"), across(x:y, list(mean = mean, median = median)))
    Output
      tibble(x_mean = base::mean(x), x_median = stats::median(x), y_mean = base::mean(y), 
          y_median = stats::median(y))

