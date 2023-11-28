library(tigris)
library(tidycensus)
library(tidyverse)
library(sf)
library(showtext)
options(tigris_use_cache = TRUE)

font_add_google("Montserrat")
showtext_auto()

tx_blocks <- get_decennial(
  geography = "block",
  variables = "H1_001N",
  state = "TX",
  geometry = TRUE,
  year = 2020,
  sumfile = "dhc"
)

blocks_1_hh <- tx_blocks %>%
  filter(value == 1) %>%
  st_transform(6580)

tx_outline <- states(cb = TRUE, resolution = "5m") %>%
  filter(NAME == "Texas") %>%
  st_transform(6580)

ggplot() +
  geom_sf(data = tx_outline, fill = "white", color = "grey") +
  geom_sf(data = blocks_1_hh, fill = "darkgrey", color = NA) +
  theme_void(base_family = "Montserrat") +
  labs(caption = "All the Census blocks in Texas with only one household | 2020 US Census | @kyle_e_walker | #30DayMapChallenge")
