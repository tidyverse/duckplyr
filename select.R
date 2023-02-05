pkgload::load_all()
pkgload::load_all("../relational")
library(tidyverse)

options(duckdb.materialize_message = TRUE)

df <- palmerpenguins::penguins

# No materialization should happen here!
out <-
  df %>%
  select(-species)

# Materializing should happen only here!
out

out <-
  df %>%
  slice_head(n = 5)

# Materializing should happen only here!
out

out <-
  df %>%
  select(-species) %>%
  slice_head(n = 5)

# Materializing should happen only here!
out
