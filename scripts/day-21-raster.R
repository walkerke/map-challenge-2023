library(mapboxapi)
library(sf)
library(fasterize)
library(leaflet)

isos <- mb_isochrone(
  location = "One Bowerman Dr, Beaverton, OR 97005",
  profile = "driving",
  time = 1:45
)

pal <- colorNumeric("plasma", isos$time, na.color = "transparent")

isos_proj <- st_transform(isos, 32618)

template <- raster(isos_proj, resolution = 100)

iso_surface <- fasterize(isos_proj, template, field = "time", fun = "min")

leaflet() %>%
  addMapboxTiles(style_id = "light-v9",
                 username = "mapbox",
                 scaling_factor = "0.5x") %>%
  addRasterImage(iso_surface, colors = pal, opacity = 0.5) %>%
  addLegend(values = isos$time, pal = pal,
            title = "Drive-time to<br>Nike HQ")

