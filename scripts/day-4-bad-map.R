library(tidycensus)
library(tidyverse)
library(RColorBrewer)
options(tigris_use_cache = TRUE)

mi_income <- get_acs(
  geography = "county",
  variables = "B19013_001",
  state = "MI",
  geometry = TRUE
) %>%
  mutate(estimate = as.character(estimate))

mycolors = colorRampPalette(brewer.pal(9, "Set1"))(nrow(mi_income))

ggplot(mi_income, aes(fill = estimate)) +
  geom_sf() +
  theme_void(base_size = 18) +
  scale_fill_manual(values = mycolors) +
  labs(title = " Median household income, 2017-2021 ACS",
       fill = "ACS estimate",
       caption = "@kyle_e_walker | #30DayMapChallenge Day 4: A bad map")


