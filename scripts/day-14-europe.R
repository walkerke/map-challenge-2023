library(giscoR)
library(eurostat)

# Get shapes
nuts3 <- gisco_get_nuts(
  year = "2016",
  epsg = "3035",
  resolution = "3",
  nuts_level = "3"
)

