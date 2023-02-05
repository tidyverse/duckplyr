library(tidyverse)

options(duckdb.materialize_message = TRUE)

df <- palmerpenguins::penguins

# No materialization should happen here!
out <-
  df %>%
  slice_head(n = 10)

# Materializing should happen only here!
out
