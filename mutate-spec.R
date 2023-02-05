library(dplyr)
pkgload::load_all()

data <- tibble(a1 = 1, a2 = "a", b = TRUE)

data %>%
  mutate(b = 1)
data %>%
  mutate(across(starts_with("a"), as.character))
data %>%
  mutate(x = across(starts_with("a"), as.character))
data %>%
  mutate(tibble(x1 = a1, x2 = a2))

data %>%
  summarize(
    across(c(a1, b), sum, .names = "{.col}_summary"),
    across(ends_with("_summary"), mean, .names = "{.col}_summary")
  )

data %>%
  build_mutate_spec(b = 1)
data %>%
  build_mutate_spec(across(starts_with("a"), as.character))
