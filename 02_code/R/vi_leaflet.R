library(leaflet)
library(htmlwidgets)
library(viridisLite)

# -------------------------------
# Daten einlesen
# -------------------------------
data <- read.csv("01_data/ais_dynamic_cleaned.csv")

# -------------------------------
# Farbpalette für Geschwindigkeit
# -------------------------------
pal <- colorNumeric(palette = "viridis", domain = data$speed)

# -------------------------------
# Leaflet-Karte für alle Punkte
# -------------------------------
map_all <- leaflet(data) %>%
  addTiles() %>%
  addCircles(
    lng = ~longitude,
    lat = ~latitude,
    color = ~pal(speed),
    radius = 500,
    stroke = FALSE,
    fillOpacity = 0.7
  ) %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = ~speed,
    title = "Speed (knots)",
    opacity = 1
  )

map_all
# -------------------------------
# Karte speichern
# -------------------------------


saveWidget(map_all, "03_report/graphs/ais_map_all.html", selfcontained = TRUE)