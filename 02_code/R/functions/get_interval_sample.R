library(httr)
library(jsonlite)


#Function that makes 100 observations in 5 min interval

get_interval_sample <- function(start_time_iso) {
  end_time_iso <- format(as.POSIXct(start_time_iso, tz = "UTC") + 300, "%Y-%m-%dT%H:%M:%SZ")
  
  url <- paste0(
    "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_dynamic?select=*",
    "&msg_timestamp=gte.", start_time_iso,
    "&msg_timestamp=lt.", end_time_iso,
    "&limit=100"
  )
  
  response <- GET(url)
  if (response$status_code != 200) {
    warning(paste("Fehler beim Abruf für", start_time_iso, ":", response$status_code))
    return(NULL)
  }
  
  df <- fromJSON(content(response, as = "text", encoding = "UTF-8"))
  return(df)
}