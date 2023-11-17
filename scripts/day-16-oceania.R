library(tidycensus)
library(tigris)
library(tidyverse)
library(showtext)
options(tigris_use_cache = TRUE)

font_add_google("Raleway")
showtext_auto()

us_oceania <- get_acs(
  geography = "puma",
  variables = "DP02_0109P",
  geometry = TRUE,
  year = 2021
) %>%
  filter(str_sub(GEOID, 1, 2) != "72") %>%
  shift_geometry(position = "outside")

ggplot(us_oceania, aes(fill = estimate)) +
  geom_sf(color = NA) +
  theme_void(base_size = 16, base_family = "Raleway") +
  scale_fill_distiller(palette = "YlGnBu", direction = 1,
                       labels = scales::label_percent(scale = 1)) +
  labs(title = "Percent of PUMA population born in Oceania",
       subtitle = "2017-2021 5-year American Community Survey",
       caption = "@kyle_e_walker | tidycensus R package",
       fill = "ACS estimate")


