library(tidycensus)
library(tidyverse)
library(ggiraph)
library(scales)
library(patchwork)
library(tigris)

us_wfh <- get_acs(
  geography = "state",
  variables = "DP03_0024P",
  year = 2022,
  survey = "acs1",
  geometry = TRUE
) %>%
  filter(GEOID != "11") %>%
  shift_geometry(position = "outside") %>%
  mutate(tooltip = paste(NAME, estimate, sep = ": "))

gg <- ggplot(us_wfh, aes(fill = estimate)) +
  geom_sf_interactive(aes(tooltip = tooltip, data_id = GEOID),
                      size = 0.1) +
  scale_fill_viridis_c(option = "rocket", direction = -1,
                       labels = label_percent(scale = 1)) +
  labs(title = "Percent of workers who work at home",
       caption = "Data source: 2022 1-year ACS, US Census Bureau",
       fill = "ACS estimate") +
  theme_void()

gg_bar <- ggplot(us_wfh, aes(y = estimate, x = reorder(NAME, -estimate),
                             fill = estimate)) +
  geom_col_interactive(aes(data_id = GEOID)) +
  scale_fill_viridis_c(guide = "none", option = "rocket", direction = -1) +
  scale_y_continuous(labels = scales::label_percent(scale = 1)) +
  theme_minimal(base_size = 8) +
  labs(x = "",
       y = "") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1,
                                   hjust = 1),
        legend.position = "bottom",
        legend.direction = "horizontal")

girafe(ggobj = wrap_plots(gg, gg_bar, widths = c(8, 8), heights = c(6, 2),
                          ncol = 1),
       options = list(
         opts_hover(css = ""),
         opts_hover_inv(css = "opacity:0.25;")
       ))
