library(tidycensus)
library(tidyverse)
library(tigris)
library(cowplot)
library(showtext)
options(tigris_use_cache = TRUE)
font_add_google("Montserrat")
showtext_auto()


us_race_income <- get_acs(
  geography = "county",
  variables = c(
    medinc = "B19013_001",
    pctwhite = "DP05_0037P"
  ),
  year = 2021,
  output = "wide",
  geometry = TRUE
) %>%
  shift_geometry() %>%
  bi_class(x = pctwhiteE, y = medincE,
           style = "quantile", dim = 3)

# create map
map <- ggplot() +
  geom_sf(data = us_race_income, mapping = aes(fill = bi_class),
          color = NA, show.legend = FALSE) +
  bi_scale_fill(pal = "GrPink", dim = 3) +
  labs(
    title = "Bivariate Race & Income, US Counties",
    subtitle = "2017-2021 American Community Survey",
    caption = "@kyle_e_walker | tidycensus R package"
  ) +
  bi_theme(base_family = "Montserrat")

legend <- bi_legend(pal = "GrPink",
                    dim = 3,
                    xlab = "Higher % White ",
                    ylab = "Higher Income ",
                    size = 8)

# combine map with legend
final_plot <- ggdraw() +
  draw_plot(map, 0, 0, 1, 1) +
  draw_plot(legend, 0.75, 0.1, 0.2, 0.2)
