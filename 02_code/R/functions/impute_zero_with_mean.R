impute_zero_with_mean <- function(df) {
  dt <- as.data.table(df)
  
  for (col in names(dt)) {
    if (is.numeric(dt[[col]])) {
      # Calculate the mean only if value > 0 
      mean_val <- mean(dt[[col]][dt[[col]] > 0])
      
      # rounding the integer 
      if (is.integer(dt[[col]])) {
        mean_val <- as.integer(round(mean_val))
      }
      
      # substitute 0 with mean
      dt[get(col) == 0, (col) := mean_val]
    }
  }
  
  return(dt)
}