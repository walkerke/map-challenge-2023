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

black_counties <- counties(cb = TRUE, resolution = "20m") %>%
  filter(str_detect(NAME, "Black|Noir|Negro|Negra")) %>%
  shift_geometry()

black_places <- places(cb = TRUE) %>%
  filter(str_detect(NAME, "Black|Noir|Negro|Negra"),
         !STATEFP %in% c("66", "69")) %>%
  st_centroid() %>%
  shift_geometry()

ggplot() +
  with_shadow(
    geom_sf(data = state_borders, fill = "white", color = "grey20"),
    colour = "black", x_offset = -3, y_offset = 3
  ) +
  with_shadow(
    geom_sf(data = black_counties, fill = "black", color = "white"),
    colour = "white", x_offset = -1, y_offset = 1
  ) +
  geom_sf(data = black_places, color = "white",
          fill = "black", shape = 21) +
  theme_void(base_size = 16, base_family = "Roboto") +
  labs(title = "Day 24: Black",
       subtitle = "U.S. counties & cities with 'Black' in their names",
       caption = "@kyle_e_walker | tigris R package") +
  theme(plot.margin = margin(0, 0.1, 0, 0, "cm"))


white_counties <- counties(cb = TRUE, resolution = "20m") %>%
  filter(str_detect(NAME, "White|Blanc")) %>%
  shift_geometry()

white_places <- places(cb = TRUE) %>%
  filter(str_detect(NAME, "White|Blanc"),
         !STATEFP %in% c("66", "69")) %>%
  st_centroid() %>%
  shift_geometry()

ggplot() +
  with_shadow(
    geom_sf(data = state_borders, fill = "black", color = "white"),
    colour = "white", x_offset = -3, y_offset = 3
  ) +
  with_shadow(
    geom_sf(data = white_counties, fill = "white", color = "black"),
    colour = "black", x_offset = -1, y_offset = 1
  ) +
  geom_sf(data = white_places, color = "black",
          fill = "white", shape = 21) +
  theme_void(base_size = 16, base_family = "Roboto") +
  labs(title = "Day 24: White",
       subtitle = "U.S. counties & cities with 'White' in their names",
       caption = "@kyle_e_walker | tigris R package") +
  theme(plot.margin = margin(0, 0.1, 0, 0, "cm"),
        plot.background = element_rect(fill = "black", color = NA),
        panel.background = element_rect(fill = "black", color = NA),
        plot.title = element_text(color = "white"),
        plot.subtitle = element_text(color = "white"),
        plot.caption = element_text(color = "white"))
