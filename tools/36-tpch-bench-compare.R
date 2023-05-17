library(tidyverse)
library(paletteer) 
paletteer_d("Polychrome::green_armytage")

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


graph <- all |> filter(...1 != "q21") |>
  ggplot(aes(x = pkg, y = time, fill = q)) +
  scale_fill_paletteer_d("Polychrome::green_armytage", direction = 1, dynamic = FALSE) + 
  geom_col(position = "stack") + 
  ggtitle("Tpch Duckplyr vs Dplyr (sf=1) Aggregate") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  labs(x = "pkg") +
  labs(y = "time (seconds)")

ggsave('tpch-stacked-results.pdf', plot = last_plot(), scale = 1, width = 5, height = 6, dpi=300)



graph <- all |> filter(...1 != "q21") |>  summarise(total_time=sum(time), .by=pkg) |>
  ggplot(aes(x = pkg, y = total_time, fill = pkg)) +
  geom_col(position = "dodge") + 
  ggtitle("Tpch Duckplyr vs Dplyr (sf=1) Aggregate") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  labs(x = "pkg") +
  labs(y = "time (seconds)")

ggsave('tpch-aggregate-results.pdf', plot = last_plot(), scale = 1, width = 5, height = 6, dpi=300)






# for_stacked <- all |> filter(...1 != "q21")

# ggplot(for_stacked, aes(fill=pkg, y=time, x=...1)) + 
#     geom_bar(position="stack", stat="identity")

# ggsave('tpch-results-stacked.pdf', plot = last_plot(), scale = 1, width = 5, height = 6, dpi=300)