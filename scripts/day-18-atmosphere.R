library(tigris)
library(sf)
# Get shapefile from UNL Drought Monitor
# https://droughtmonitor.unl.edu/data/shapefiles_m/USDM_20210427_M.zip

# Explode the shapes then shift geometry
drought <- st_read("USDM_20210427.shp") %>%
  st_cast("POLYGON") %>%
  shift_geometry()

# Get a basemap layer and shift geometry
us_base <- states(cb = TRUE, resolution = "20m") %>%
  shift_geometry()

# Plot with shifted geometries
ggplot() +
  geom_sf(data = drought, aes(fill = as.factor(DM)), color = NA) +
  geom_sf(data = us_base, fill = NA, color = "black") +
  scale_fill_brewer(palette = "YlOrRd", labels = function(x) paste0("D", x)) +
  theme_void() +
  labs(fill = "Drought intensity  ",
       caption = "Data source: University of Nebraska Drought Monitor",
       title = " Drought conditions, 27 April 2021")
