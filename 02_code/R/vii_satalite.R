
library(leaflet)
library(htmlwidgets)
library(viridisLite)

# reading the data frame
data <- read.csv("01_data/ais_dynamic_cleaned.csv")
colnames(data)

# only satelite points
data_sat <- subset(data, collection_type == "satellite")

#setting colors and target column
pal_sat <- colorNumeric(palette = "viridis", domain = data_sat$speed)

# creating the map
map_satellite <- leaflet(data_sat) %>%
  addTiles() %>%
  addCircles(
    lng = ~longitude,
    lat = ~latitude,
    color = ~pal_sat(speed),
    radius = 1000,
    stroke = FALSE,
    fillOpacity = 0.7
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal_sat,
    values = ~speed,
    title = "Speed (knots)",
    opacity = 1
  )

map_satellite

#saving 
saveWidget(map_satellite, "03_report/graphs/ais_map_satellite.html", selfcontained = TRUE)