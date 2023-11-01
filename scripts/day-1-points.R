# "Firefly" map of US trauma hospitals using R
library(tigris)
library(sf)
library(tidyverse)
library(ggshadow)
library(showtext)
options(tigris_use_cache = TRUE)

font_add_google("Montserrat")
showtext_auto()

# CRS: NAD83 / Iowa North
us_states <- states(cb = TRUE, resolution = "20m") %>%
  shift_geometry()

hospital_url <- "https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/Hospital/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"

trauma <- st_read(hospital_url) %>%
  filter(str_detect(TRAUMA, "LEVEL I\\b|LEVEL II\\b|RTH|RTC")) %>%
  shift_geometry() %>%
  distinct(ID, .keep_all = TRUE)

# Build the "firefly" map;
# see https://dominicroye.github.io/en/2021/firefly-cartography/ for a
# full tutorial
ggplot() +
  geom_sf(data = us_states, fill = NA, color = "white") +
  geom_glowpoint(data = trauma,
                 aes(geometry = geometry),
                 alpha = .7,
                 size = 0.2,
                 color = "#6bb857",
                 shadowcolour = "#6bb857",
                 shadowalpha = .1,
                 stat = "sf_coordinates") +
  geom_glowpoint(data = trauma,
                 aes(geometry = geometry),
                 alpha = .6,
                 size = 0.05,
                 shadowalpha = .05,
                 color = "#ffffff",
                 stat = "sf_coordinates") +
  labs(title = "LEVEL I OR II TRAUMA CENTERS IN THE UNITED STATES",
       caption = "Data: HIFLD/US DHS | @kyle_e_walker") +
  theme_void() +
  theme(panel.background = element_rect(fill = "black"),
        plot.background = element_rect(fill = "black"),
        plot.title = element_text(color = "white", family = "Montserrat"),
        plot.caption = element_text(color = "white", family = "Montserrat"),
        plot.margin = margin(l = 0.1, r = 0.1, unit = "cm"))

