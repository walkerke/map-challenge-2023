library(tigris)
library(sf)
library(tidyverse)
library(showtext)
library(ggtext)
options(tigris_use_cache = TRUE)
sf_use_s2(FALSE)

font_add_google("Raleway")
showtext_auto()

zips <- zctas(cb = TRUE, year = 2020) %>%
  select(zip = GEOID20)

state <- states(cb = TRUE, year = 2020) %>%
  filter(GEOID < "57") %>%
  select(state = NAME)

zip_state <- st_intersection(zips, state)

zip_polys <- zip_state %>%
  filter(as.numeric(st_area(.)) > 10000000) # At least 1 square km of overlap, avoiding misalignment / sliver issues

multi_zips <- zip_polys %>%
  group_by(zip) %>%
  filter(n() > 2) %>%
  summarize() %>%
  shift_geometry()

zip_shift <- zips %>%
  st_filter(state) %>%
  shift_geometry()

state_shift <- shift_geometry(state)

ggplot() +
  # geom_sf(data = zip_shift, fill = "white", color = "grey") +
  geom_sf(data = state_shift, fill = NA, color = "black", size = 0.1) +
  geom_sf(data = multi_zips, fill = "#31a354", color = "#006d2c") +
  theme_void(base_size = 18, base_family = "Raleway") +
  labs(title = "2020 ZCTAs that cross state boundaries",
       caption = "@kyle_e_walker | tigris R package") +
  theme(plot.title = element_text(hjust = 0.5))




