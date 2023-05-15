library(tidyverse)

duckdb <- read_csv("res-duckplyr.csv")
dplyr <- read_csv("res-dplyr.csv")

all <- bind_rows(dplyr, duckdb)

graph <- all |>
  ggplot(aes(x = query, y = time, fill = pkg)) +
  geom_col(position = "dodge")

ggsave('tpch-results.pdf', plot = last_plot(), scale = 1, width = 15, height = 5, dpi=300)
