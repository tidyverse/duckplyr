library(tidyverse)

duckdb <- read_csv("res-duckplyr.csv")
dplyr <- read_csv("res-dplyr.csv")
relational <- read_csv("res-relational-duckdb.csv")

all <- bind_rows(dplyr, duckdb, relational)

graph <- all |> filter(...1 != "q21") |>
  ggplot(aes(x = ...1, y = time, fill = pkg)) +
  geom_col(position = "dodge") + ggtitle("Tpch Duckplyr vs Dplyr (sf=1)") + theme(plot.title = element_text(hjust = 0.5)) + 
  scale_y_continuous(breaks = round(seq(min(all$time), max(all$time), by = 0.5),1)) + 
  labs(x = "query") +
  labs(y = "time (seconds)")

ggsave('tpch-results.pdf', plot = last_plot(), scale = 1, width = 15, height = 5, dpi=300)
