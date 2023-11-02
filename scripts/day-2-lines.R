library(mapboxapi)
library(rdeck)
library(tidyverse)

my_route <- mb_directions(
  origin = "700 Burnett St, Fort Worth TX 76102",
  destination = "734 Stadium Dr, Arlington, TX 76011") %>%
  mutate(seq_time = list(seq(0:24)))


rdeck(map_style = mapbox_light(), theme = "light",
      initial_bounds = my_route) %>%
  add_trips_layer(get_path = geometry, data = my_route, get_timestamps = seq_time,
                  get_width = 50,
                  animation_speed = 3)


