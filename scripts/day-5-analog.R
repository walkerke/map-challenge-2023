library(tigris)
library(tidyverse)
library(sf)

texas <- states(cb = TRUE, resolution = "20m") %>%
  filter(NAME == "Texas") %>%
  st_cast("POLYGON") %>%
  st_cast("LINESTRING") %>%
  select(NAME)

st_write(texas, "data/texas.geojson", delete_dsn = TRUE)
