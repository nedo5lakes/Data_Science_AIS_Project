#  Function to impute NA values with the mean of each numeric column starts here 
impute_na_with_mean <- function(df) {
  dt <- as.data.table(df)
  
  for (col in names(dt)) {
    if (is.numeric(dt[[col]])) {
      # calcualating mean of each column ignoring NA values
      mean_val <- mean(dt[[col]], na.rm = TRUE)
      
      # rounding and transforming
      if (is.integer(dt[[col]])) {
        mean_val <- as.integer(round(mean_val))
      }
      
      # Replace NA values with the calculated  mean
      dt[is.na(get(col)), (col) := mean_val]
    }
  }
  
  return(dt)
}
