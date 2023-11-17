from pygris.data import get_lodes
import pydeck
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors

or_od = get_lodes(
  state = "OR", 
  year = 2021, 
  lodes_type="od",
  agg_level = "tract",
  cache = True, 
  return_lonlat = True
)

top_commutes = or_od.query('w_geocode == "41067031402" & S000 >= 100')

import pydeck

GREEN_RGB = [0, 255, 0, 200]
RED_RGB = [240, 100, 0, 200]

arc_layer = pydeck.Layer(
  "ArcLayer",
  data=top_commutes,
  get_width="S000 / 10",
  get_source_position=["h_lon", "h_lat"],
  get_target_position=["w_lon", "w_lat"],
  get_tilt=15,
  get_source_color=RED_RGB,
  get_target_color=GREEN_RGB,
  pickable=True,
  auto_highlight=True
)

view_state = pydeck.ViewState(
  latitude=45.51, 
  longitude=-122.86, 
  bearing=45, 
  pitch=50, 
  zoom=8
)

tooltip = {"html": "{S000} jobs <br /> Home of commuter in red; work location in green"}
r = pydeck.Deck(
  arc_layer, 
  initial_view_state=view_state, 
  tooltip=tooltip, 
  map_style = "road"
)

r.to_html("../maps/day-17-flows.html")

