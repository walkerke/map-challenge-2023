library(censobr)
library(arrow)
library(tidyverse)
library(geobr)
library(rdeck)
library(sf)
library(tidycensus)

tracts_sf <- read_census_tract(code_tract = "RJ",
                               simplified = FALSE,
                               year = 2010,
                               showProgress = FALSE)

tracts_sf <- filter(tracts_sf, name_muni == "Rio De Janeiro")

# download data
tract_pessoa <- read_tracts(year = 2010,
                            dataset = "Pessoa",
                            showProgress = FALSE)

# Select general race columns
tract_race <- tract_pessoa |>
  select(code_tract, pessoa03_V002:pessoa03_V006) %>%
  collect()

# Get the data in long format for dot-density mapping
# Dropping Indigena due to too few values
rj_race <- tracts_sf %>%
  select(code_tract) %>%
  left_join(tract_race, by = "code_tract") %>%
  set_names(c("code_tract", "Branca", "Preta",
                     "Amarela", "Parda", "Indigena", "geom")) %>%
  pivot_longer(
    Branca:Parda,
    names_to = "race",
    values_to = "population"
  )

# What is the largest value for each group?
rj_race |>
  sf::st_drop_geometry() |>
  group_by(race) %>%
  summarize(max_pop = max(population, na.rm = TRUE))

rj_race_dots <- as_dot_density(
  rj_race,
  value = "population",
  values_per_dot = 100,
  group = "race"
)

rdeck(map_style = mapbox_light(), theme = "light",
      initial_bounds = tracts_sf) %>%
  add_scatterplot_layer(data = st_transform(rj_race_dots, 4326),
                        id = "Race", name = "1 dot = 100 people\n2010 Census",
                        get_fill_color = rdeck::scale_color_category(race,
                                                                     palette = RColorBrewer::brewer.pal(4, "Set1"), col_label = "Race"),
                        get_position = geometry, get_radius = 20)
