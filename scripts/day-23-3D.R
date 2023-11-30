library(rdeck)
library(tidycensus)
library(sf)
options(tigris_use_cache = TRUE)

us_tract_income <- get_acs(
  geography = "tract",
  variables = "B19013_001",
  state = c(state.abb, "DC"),
  geometry = TRUE
)

Sys.setenv("MAPBOX_ACCESS_TOKEN" = "YOUR TOKEN HERE")

us_tract_income$height <- ifelse(is.na(us_tract_income$estimate), 0, us_tract_income$estimate)

us_tract_income <- st_transform(us_tract_income, 4326)

rdeck(map_style = mapbox_light(), initial_bounds = us_tract_income) %>%
  add_polygon_layer(data = us_tract_income, get_polygon = geometry,
                    get_fill_color = scale_color_linear(estimate),
                    pickable = TRUE, auto_highlight = TRUE,
                    get_elevation = height, extruded = TRUE,
                    opacity = 0.6, name = "Median household income", tooltip = estimate)
