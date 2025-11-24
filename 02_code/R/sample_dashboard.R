library(leaflet)
library(htmlwidgets)




df <-read.csv("01_data/ais_dynamic_cleaned.csv")

#map
map <- leaflet(df) %>%
  addTiles() %>%
  addMarkers(~longitude, ~latitude, popup = ~paste("MMSI:", mmsi, "<br>Speed:", speed, "<br>Course:", course))

# Saving as Html 
saveWidget(map, "03_report/graphs/sample_points.html")

map



