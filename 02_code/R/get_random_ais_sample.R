

library(httr)
library(jsonlite)
library(dplyr)

get_random_ais_sample <- function(date = "2024-01-24", max_rows = 1000) {
  start_times <- seq(
    from = as.POSIXct(paste0(date, " 00:00:00"), tz = "UTC"),
    to = as.POSIXct(paste0(date, " 23:55:00"), tz = "UTC"),
    by = "5 min"
  )
  
  start_times_iso <- format(sample(start_times), "%Y-%m-%dT%H:%M:%SZ")
  all_samples <- data.frame()
  
  for (start in start_times_iso) {
    end <- format(as.POSIXct(start, tz = "UTC") + 300, "%Y-%m-%dT%H:%M:%SZ")
    
    url <- paste0(
      "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_dynamic?select=*",
      "&msg_timestamp=gte.", start,
      "&msg_timestamp=lt.", end,
      "&limit=100"
    )
    
    response <- GET(url)
    if (response$status_code != 200) next
    
    df <- tryCatch({
      fromJSON(content(response, as = "text", encoding = "UTF-8"))
    }, error = function(e) data.frame())
    
    if (is.data.frame(df) && nrow(df) > 0) {
      all_samples <- bind_rows(all_samples, df)
    }
    
    if (nrow(all_samples) >= max_rows) {
      all_samples <- head(all_samples, max_rows)
      break
    }
  }
  
  return(all_samples)
}