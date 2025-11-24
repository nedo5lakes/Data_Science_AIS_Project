
#Beginn


library(leaflet)
library(dplyr)
library(jsonlite)
library(httr)
library(htmlwidgets)



#  dynamic data

url <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_dynamic?select=*&mmsi=eq.2579999&msg_timestamp=gte.2024-01-24T00:00:00Z&msg_timestamp=lt.2024-01-24T00:05:00Z&limit=1000"
response <- GET(url)
df_dynamic <- fromJSON(content(response, as = "text"))
print(df_dynamic)


# b) Static AIS-Data 
url_static <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=*&mmsi=eq.2579999&limit=1000"
response_static <- GET(url_static)
df_static <- fromJSON(content(response_static, as = "text"))
print(df_static)

# joining the tabels
df_both <- merge(df_dynamic, df_static, by = "mmsi", all.x = TRUE)
print(df_both)

summary(df_both)
unique(df_both$speed)

#cleaning transforming
df_clone <- df_both
df_clone$speed[is.na(df_clone$speed)] <- mean(df_clone$speed, na.rm = TRUE)
print(df_both)
#only Na values available , cleaning not posssible 

write.csv(df_clone,"01_data/MMSI_257999.csv")



#  Visualization


leaflet(df_both) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(
    lat = ~latitude, 
    lng = ~longitude, 
    popup = ~paste(
      "MMSI:", mmsi, "<br>",
      "Timestamp:", msg_timestamp, "<br>",
      "Speed:", speed, "<br>",
      "Course:", course, "<br>",
      "Heading:", heading
    ), 
    color = ~ifelse(is.na(speed), "gray", ifelse(speed > 10, "red", "blue")), # color based on speed
    radius = 5, # Größe der Marker
    clusterOptions = markerClusterOptions() # activating the cluster option method
  )


sum(is.na(df_both$speed))
unique(df_both$course)
sum(is.na(df_both$course))
sum(is.na(df_both$heading))
    

# around singnapore south korea and australia there is probably signal problem with gps thats why the data is missing
# aroung europe there are many vessels thus why signal might be interrupted



#ii)

#  Dynamic Data for MMSI=412420898 

url_dynamic_4124 <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_dynamic?select=*&mmsi=eq.412420898&limit=100"
response_dynamic_4124 <- GET(url_dynamic_4124)
df_dynamic_4124 <- fromJSON(content(response_dynamic_4124, as = "text"))
print(df_dynamic_4124)

colnames(df_dynamic_4124)

#  Static AIS-Data for MMSI=412420898
url_static_4124 <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=*&mmsi=eq.412420898&limit=100"
response_static_4124 <- GET(url_static_4124)
df_static_4124 <- fromJSON(content(response_static_4124, as = "text"))
print(head(df_static_4124))

# Tabel join
df_both_4124 <- merge(df_dynamic_4124, df_static_4124, by = "mmsi", all.x = TRUE)
print(df_both_4124)

write.csv(df_both_4124,"01_data/MMSI_412420898.csv")

# summary and NaN values
summary(df_both_4124)
sum(is.na(df_both_4124$speed)) # Nan Values
sum(is.na(df_both_4124$course)) 
sum(is.na(df_both_4124$heading))

# -----------------------------------------------
# 2. Visualization 
# -----------------------------------------------

leaflet(df_both_4124) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(
    lat = ~latitude, 
    lng = ~longitude, 
    popup = ~paste(
      "MMSI:", mmsi, "<br>",
      "Timestamp:", msg_timestamp, "<br>",
      "Speed:", speed, "<br>",
      "Course:", course, "<br>",
      "Heading:", heading
    ), 
    color = ~ifelse(is.na(speed), "gray", ifelse(speed > 10, "red", "blue")), 
    radius = 5, # Größe der Marker
    clusterOptions = markerClusterOptions() 
  )