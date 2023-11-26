library(tigris)
library(tidyverse)
library(showtext)
library(sf)
library(ggfx)

options(tigris_use_cache = TRUE)
font_add_google("Roboto", "Roboto")
showtext_auto()

state_borders <- states(cb = TRUE, resolution = "20m") %>%
  shift_geometry()

park_counties <- counties(cb = TRUE, resolution = "20m") %>%
  filter(str_detect(NAME, regex("Park|Parque|Parc", ignore.case = TRUE))) %>%
  shift_geometry()

park_places <- places(cb = TRUE) %>%
  filter(str_detect(NAME, regex("Park|Parque|Parc", ignore.case = TRUE)),
         !STATEFP %in% c("66", "69")) %>%
  st_centroid() %>%
  shift_geometry()

ggplot() +
  with_shadow(
    geom_sf(data = state_borders, fill = "grey80", color = "grey20"),
    colour = "darkgreen", x_offset = -3, y_offset = 3
  ) +
  with_shadow(
    geom_sf(data = park_counties, fill = "darkgreen", color = "white"),
    colour = "white", x_offset = -1, y_offset = 1
  ) +
  geom_sf(data = park_places, color = "white", alpha = 0.75,
          fill = "darkgreen", shape = 21) +
  theme_void(base_size = 16, base_family = "Roboto") +
  labs(title = "Day 20: Outdoors",
       subtitle = "U.S. counties & cities with 'Park' in their names",
       caption = "@kyle_e_walker | tigris R package") +
  theme(plot.margin = margin(0, 0.1, 0, 0, "cm"))
