library(tigris)
library(lehdr)
library(sf)
library(tidyverse)
library(rdeck)
options(tigris_use_cache = TRUE)

tx_wac <- grab_lodes(
  state = "tx",
  year = 2020,
  lodes_type = "wac"
)

tx_blocks <- blocks("TX", year = 2020) %>%
  st_centroid()

tx_block_medical <- tx_blocks %>%
  select(w_geocode = GEOID20) %>%
  inner_join(
    select(
      tx_wac, w_geocode, healthcare = CNS16
    ),
    by = "w_geocode"
  ) %>%
  st_transform(4326)

rdeck(map_style = mapbox_light(), initial_bounds = tx_block_medical) %>%
  add_hexagon_layer(
    data = tx_block_medical,
    get_position = geometry,
    get_elevation_weight = healthcare,
    get_color_weight = healthcare,
    pickable = TRUE,
    auto_highlight = TRUE,
    extruded = TRUE,
    radius = 5000,
    color_range = viridisLite::plasma(7),
    color_scale_type = "quantize",
    elevation_scale = 50,
    opacity = 0.5
  )
