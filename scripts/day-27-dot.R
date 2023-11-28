library(tidycensus)
library(tidyverse)
library(mapboxapi)
library(sf)
sf_use_s2(FALSE)
options(tigris_use_cache = TRUE)

racevars <- c(White = "P2_005N",
              Black = "P2_006N",
              Asian = "P2_008N",
              Hispanic = "P2_002N")

seattle_race <- get_decennial(
  geography = "tract",
  variables = racevars,
  state = "WA",
  county = c("King", "Pierce",
             "Snohomish", "Kitsap"),
  geometry = TRUE,
  year = 2020,
  sumfile = "pl"
) %>%
  st_transform(6596)

seattle_race_dots <- as_dot_density(
  seattle_race,
  value = "value",
  values_per_dot = 500,
  group = "variable",
  erase_water = TRUE,
  area_threshold = 0.9
)

basemap <- layer_static_mapbox(
  location = seattle_race,
  style_id = "light-v9",
  username = "mapbox"
)

ggplot() +
  basemap +
  geom_sf(
    mapping = aes(color = variable),
    data = seattle_race_dots,
    size = 0.01) +
  theme_void() +
  scale_color_brewer(palette = "Set1") +
  theme(legend.position = "bottom") +
  labs(color = "Race / ethnicity",
       caption = "1 dot = 500 residents | tidycensus R package") +
  guides(color = guide_legend(override.aes = list(size = 3)))


