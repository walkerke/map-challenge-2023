library(tidycensus)
library(tidyverse)
library(tigris)
library(showtext)
options(tigris_use_cache = TRUE)

font_add_google("Raleway")

showtext_auto()

order = c("-3% and below", "-3% to -1.5%", "-1.5% to 0%", "0% to +1.5%", "+1.5% to +3%",
          "+3% and up")

popchg <- get_estimates(geography = "county",
                        variables = c("NPOPCHG", "POPESTIMATE"),
                        time_series = TRUE,
                        geometry = TRUE,
                        resolution = "20m",
                        output = "wide") %>%
  shift_geometry() %>%
  mutate(percent_change = 100 * (NPOPCHG2022 / POPESTIMATE2021),
         groups = case_when(
           percent_change > 3 ~ "+3% and up",
           percent_change > 1.5 ~ "+1.5% to +3%",
           percent_change > 0 ~ "0% to +1.5%",
           percent_change > -1.5 ~ "-1.5% to 0%",
           percent_change > -3 ~ "-3% to -1.5%",
           TRUE ~ "-3% and below"
         ),
         groups = factor(groups, levels = order)
         )

state_overlay <- states(
  cb = TRUE,
  resolution = "20m"
) %>%
  filter(GEOID != "72") %>%
  shift_geometry()

ggplot() +
  geom_sf(data = popchg, aes(fill = groups, color = groups), size = 0.3,
          alpha = 0.85) +
  geom_sf(data = state_overlay, fill = NA, color = "black", size = 0.1) +
  scale_fill_brewer(palette = "RdBu", direction = -1) +
  scale_color_brewer(palette = "RdBu", direction = -1, guide = "none") +
  theme_void(base_family = "Raleway", base_size = 12) +
  labs(title = "POPULATION CHANGE (%), 2021 to 2022",
       subtitle = "US Census Bureau Population Estimates",
       fill = "",
       caption = "Data acquired with the R tidycensus package | @kyle_e_walker") +
  theme(legend.position = "bottom")

