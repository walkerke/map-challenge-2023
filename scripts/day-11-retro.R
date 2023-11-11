library(tigris)
library(sf)
library(mapboxapi)
library(tidyverse)
library(showtext)
options(tigris_use_cache = TRUE)
sf_use_s2(FALSE)

font_add_google("Press Start 2P")

showtext_auto()

fw_buffer <- mb_geocode("Sundance Square, Fort Worth TX 76102",
                        output = "sf") %>%
  st_transform(26914) %>%
  st_buffer(dist = 1000) %>%
  st_transform(4326)

vector_extract <- get_vector_tiles(
  tileset_id = "mapbox.mapbox-streets-v8",
  location = fw_buffer,
  zoom = 17
)

buildings_1km <- st_intersection(vector_extract$building, fw_buffer) %>%
  group_by(id, type) %>%
  summarize()

# You'll need to adjust the export sizing to get this the way you want
ggplot() +
  geom_sf(data = buildings_1km, color = "#33ff33", fill = NA) +
  geom_sf(data = fw_buffer, fill = NA, color = "#33ff33", size = 1) +
  theme_void(base_family = "Press Start 2P") +
  labs(title = "Building footprints within\n1km of downtown Fort Worth",
       caption = "Data source: Mapbox / OpenStreetMap") +
  theme(plot.background = element_rect(fill = "black", color = NA),
        panel.background = element_rect(fill = "black", color = NA),
        plot.title = element_text(color = "#33ff33"),
        plot.caption = element_text(color = "#33ff33"),
        plot.margin = margin(1, 1, 1, 1, "cm"))
