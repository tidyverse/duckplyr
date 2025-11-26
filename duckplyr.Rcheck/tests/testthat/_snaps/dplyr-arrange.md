# duckplyr_arrange() gives meaningful errors

    Code
      (expect_error(tibble(x = 1, x = 1, .name_repair = "minimal") %>%
        duckplyr_arrange(x)))
    Output
      <error/rlang_error>
      Error in `arrange()`:
      ! Can't transform a data frame with duplicate names.
    Code
      (expect_error(tibble(x = 1) %>% duckplyr_arrange(y)))
    Output
      <error/dplyr:::mutate_error>
      Error in `arrange()`:
      i In argument: `..1 = y`.
      Caused by error:
      ! object 'y' not found
    Code
      (expect_error(tibble(x = 1) %>% duckplyr_arrange(rep(x, 2))))
    Output
      <error/dplyr:::mutate_error>
      Error in `arrange()`:
      i In argument: `..1 = rep(x, 2)`.
      Caused by error:
      ! `..1` must be size 1, not 2.

# arrange errors if stringi is not installed and a locale identifier is used

    Code
      locale_to_chr_proxy_collate("fr", has_stringi = FALSE)
    Condition
      Error in `locale_to_chr_proxy_collate()`:
      ! could not find function "locale_to_chr_proxy_collate"

# arrange validates `.locale`

    Code
      duckplyr_arrange(df, .locale = 1)
    Condition
      Error in `arrange()`:
      ! `.locale` must be a string or `NULL`.

---

    Code
      duckplyr_arrange(df, .locale = c("en_US", "fr_BF"))
    Condition
      Error in `arrange()`:
      ! If `.locale` is a character vector, it must be a single string.

# arrange validates that `.locale` must be one from stringi

    Code
      duckplyr_arrange(df, .locale = "x")
    Condition
      Error in `arrange()`:
      ! `.locale` must be one of the locales within `stringi::stri_locale_list()`.

# desc() inside duckplyr_arrange() checks the number of arguments (#5921)

    Code
      df <- data.frame(x = 1, y = 2)
      (expect_error(duckplyr_arrange(df, desc(x, y))))
    Output
      <error/rlang_error>
      Error in `arrange()`:
      ! `desc()` must be called with exactly one argument.

