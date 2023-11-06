library(tidycensus)
sf::sf_use_s2(FALSE)
options(tigris_use_cache = TRUE)

tc_hmong <- get_decennial(
  geography = "tract",
  variables = "T01001_001N",
  state = "MN",
  county = c("Hennepin", "Ramsey", "Anoka", "Scott",
             "Carver", "Dakota", "Washington"),
  year = 2020,
  sumfile = "ddhca",
  pop_group = "3823",
  pop_group_label = TRUE,
  geometry = TRUE
)

tc_hmong_dots <- as_dot_density(
  tc_hmong,
  value = "value",
  values_per_dot = 25,
  erase_water = TRUE
)

mapview::mapview(tc_hmong_dots, cex = 0.01, layer.name = "Hmong population<br>1 dot = 25 people",
                 col.regions = "navy", color = "navy")
