# remotes::install_github("Shelmith-Kariuki/rKenyaCensus")
library(rKenyaCensus)
library(tidyverse)
library(sf)
library(showtext)

font_add_google("Montserrat")
showtext_auto()

internet <- V4_T2.33

kenya_counties_sf <- st_as_sf(KenyaCounties_SHP)

kenya_internet_map <- kenya_counties_sf %>%
  left_join(internet, by = "County")

ggplot(kenya_internet_map, aes(fill = UoI_Total_Perc)) +
  geom_sf() +
  scale_fill_viridis_c(option = "mako", labels = scales::label_percent(scale = 1),
                       direction = -1) +
  theme_void(base_family = "Montserrat", base_size = 16) +
  labs(fill = "Percentage",
       title = "Percent of Population Using the Internet by County in Kenya",
       subtitle = "2019 Kenyan Census",
       caption = "Data acquired with the rKenyaCensus R package")
