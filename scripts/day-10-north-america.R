library(tidycensus)
library(tigris)
library(tidyverse)
library(showtext)
options(tigris_use_cache = TRUE)

font_add_google("Raleway")
showtext_auto()

us_canadians <- get_acs(
  geography = "county",
  variables = "B05006_167",
  summary_var = "B01003_001",
  geometry = TRUE,
  year = 2021
) %>%
  filter(str_sub(GEOID, 1, 2) != "72") %>%
  mutate(pct_canadian = 100 * (estimate / summary_est)) %>%
  shift_geometry(position = "outside")

ggplot(us_canadians, aes(fill = pct_canadian)) +
  geom_sf(color = NA) +
  theme_void(base_size = 16, base_family = "Raleway") +
  scale_fill_distiller(palette = "Reds", direction = 1,
                       labels = scales::label_percent(scale = 1)) +
  labs(title = "Percent of county population born in Canada",
       subtitle = "2017-2021 5-year American Community Survey",
       caption = "@kyle_e_walker | tidycensus R package",
       fill = "ACS estimate")


