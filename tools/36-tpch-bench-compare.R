library(tidyverse)
library(paletteer)
paletteer_d("Polychrome::green_armytage")

duckplyr <- read_csv("res-duckplyr.csv")
relational <- read_csv("res-duckplyr-raw.csv")
dplyr <- read_csv("res-dplyr.csv")

# FIXME: Where does res-relational-duckdb.csv come from?

all <-
  bind_rows(dplyr, duckplyr, relational) |>
  mutate(query = gsub("tpch_", "q", ...1), .keep = "unused") |>
  mutate(speedup = time[[1]] / time, .by = query)

graph <- all |>
  ggplot(aes(x = query, y = time * 1000, fill = pkg)) +
  geom_col(position = "dodge") +
  ggtitle("Tpch duckplyr vs dplyr (sf=1), log scale") +
  theme(plot.title = element_text(hjust = 0.5)) +
  # scale_y_continuous(breaks = round(seq(min(all$time), max(all$time), by = 0.5),1)) +
  labs(x = "query") +
  labs(y = "time (milliseconds)") +
  scale_y_log10()

graph

ggsave('tpch-results.pdf', plot = last_plot(), scale = 1, width = 15, height = 5, dpi=300)

graph <- all |>
  ggplot(aes(x = query, y = speedup, fill = pkg)) +
  geom_col(position = "dodge") +
  ggtitle("Tpch duckplyr vs dplyr (sf=1), speedup, log scale") +
  theme(plot.title = element_text(hjust = 0.5)) +
  # scale_y_continuous(breaks = round(seq(min(all$time), max(all$time), by = 0.5),1)) +
  labs(x = "query") +
  labs(y = "speedup") +
  scale_y_log10()

graph

ggsave('tpch-speedup.pdf', plot = last_plot(), scale = 1, width = 15, height = 5, dpi=300)

graph <- all |>
  filter(query != "q21") |>
  ggplot(aes(x = pkg, y = time, fill = query)) +
  scale_fill_paletteer_d("Polychrome::green_armytage", direction = 1, dynamic = FALSE) +
  geom_col(position = "stack") +
  ggtitle("Tpch duckplyr vs dplyr (sf=1) Aggregate, without query 21") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = "pkg") +
  labs(y = "time (seconds)")

graph

ggsave('tpch-stacked-results.pdf', plot = last_plot(), scale = 1, width = 5, height = 6, dpi=300)

graph <- all |>
  summarise(total_time=sum(time), .by=pkg) |>
  ggplot(aes(x = pkg, y = total_time, fill = pkg)) +
  geom_col(position = "dodge") +
  ggtitle("Tpch duckplyr vs dplyr (sf=1) Aggregate") +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(x = "pkg") +
  labs(y = "time (seconds)")

graph

ggsave('tpch-aggregate-results.pdf', plot = last_plot(), scale = 1, width = 5, height = 6, dpi=300)
