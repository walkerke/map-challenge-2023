library(rayshader)
library(tigris)
library(elevatr)
library(tidyverse)
library(sf)
sf_use_s2(FALSE)
library(showtext)
font_add_google("Raleway")
showtext_auto()

maui <- counties(cb = TRUE, state = "HI") %>%
  filter(NAME == "Maui") %>%
  st_cast("POLYGON") %>%
  magrittr::extract(1,)

maui_elevation <- get_elev_raster(
  locations = maui,
  z = 11,
  clip = "locations"
)

maui_mat <- raster_to_matrix(maui_elevation)

maui_mat %>%
  sphere_shade(texture = "bw") %>%
  plot_map(title_text = "MAUI, HAWAII",
           title_position = "north",
           title_size = 150,
           title_font = "Georgia")


lahaina <- places(state = "HI") %>%
  filter(NAME == "Lahaina")

lahaina_roads <- roads(state = "HI", county = "Maui") %>%
  st_intersection(lahaina) %>%
  filter(!st_is(., "POINT")) %>%
  st_cast("MULTILINESTRING")

ggplot(lahaina_roads) +
  geom_sf() +
  theme_void(base_family = "Raleway", base_size = 18) +
  labs(caption = "Roads in Lahaina, Hawaii | tigris R package")


