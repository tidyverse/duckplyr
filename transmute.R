# pkgload::load_all()
# pkgload::load_all("../relational")
# pkgload::load_all("../duckdb/tools/rpkg")
library(tidyverse)

df <- palmerpenguins::penguins

# No materialization should happen here!
out <-
  df %>%
  transmute(bill_area = bill_length_mm * bill_depth_mm, bill_length_mm, species, sex) %>%
  filter(bill_length_mm < 40) %>%
  select(-bill_length_mm) %>%
  slice_head(n = 5)

out %>%
  explain()

# Materializing should happen only here!
out
