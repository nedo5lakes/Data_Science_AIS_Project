# Helper to fetch AIS data for a given MMSI from PostgREST
get_ais_by_mmsi <- function(mmsi, base_url = "" # Insert your URL here
                            ) {
  url <- sprintf(#Here goes your select statement for the PostgREST API as a string,
                 base_url, mmsi)
  res <- GET(url)
  data <- fromJSON(content(res, "text"), flatten = TRUE)
  data$msg_timestamp <- as.POSIXct(data$msg_timestamp, tz = "UTC")
  return(data)
}