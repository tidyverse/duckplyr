pkgload::load_all()
pkgload::load_all("../relational")
library(tidyverse)

options(duckdb.materialize_message = TRUE)

df <- palmerpenguins::penguins

# No materialization should happen here!
out <-
  df %>%
  filter(bill_length_mm < 40)

# Materializing should happen only here!
out

asd

# No materialization should happen here!
out <-
  df %>%
  filter(bill_length_mm < 40) %>%
  select(-bill_length_mm) %>%
  slice_head(n = 5)

# Materializing should happen only here!
out
