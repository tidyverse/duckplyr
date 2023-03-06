library(tidyverse)

duckdb <- read_csv("res-duckdb.csv")
dplyr <- read_csv("res-dplyr.csv")

all <- bind_rows(dplyr, duckdb)

all |>
  filter(...1 != 21) |>
  ggplot(aes(x = ...1, y = time, fill = pkg)) +
  geom_col(position = "dodge")
