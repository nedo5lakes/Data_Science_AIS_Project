
library(httr)
library(jsonlite)
library(dplyr)
install.packages("geosphere")
library(geosphere)

if(!is.null(dev.list())) dev.off()
rm(list = ls())

url <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_dynamic?select=*&mmsi=eq.412420898&limit=100"
response <- GET(url)
df <- fromJSON(content(response, as = "text"))
print(df)


# -------------------------
# 2. Prediction Models
# -------------------------
# Physically-based prediction model
predict_physical <- function(df, delta_t = 1) {
  n <- nrow(df)
  df_pred <- df[1:(n - 1), ]
  
  theta_rad <- df_pred$course * pi / 180
  dx <- df_pred$speed * delta_t * sin(theta_rad)
  dy <- df_pred$speed * delta_t * cos(theta_rad)
  
  lat_pred <- df_pred$lat + dy / 60
  lon_pred <- df_pred$lon + dx / (60 * cos(df_pred$lat * pi / 180))
  
  data.frame(
    timestamp = df$msg_timestamp[2:n],
    lat_true = df$lat[2:n],
    lon_true = df$lon[2:n],
    lat_pred = lat_pred,
    lon_pred = lon_pred
  )
}

# Naive model (assumes last known position)
predict_naive <- function(df) {
  n <- nrow(df)
  data.frame(
    timestamp = df$msg_timestamp[2:n],
    lat_true = df$lat[2:n],
    lon_true = df$lon[2:n],
    lat_pred = df$lat[1:(n - 1)],
    lon_pred = df$lon[1:(n - 1)]
  )
}

# -------------------------
# 3. MSPE Calculation
# -------------------------
calc_mspe <- function(lat_pred, lon_pred, lat_true, lon_true) {
  dists <- distHaversine(cbind(lon_pred, lat_pred), cbind(lon_true, lat_true)) / 1852
  mean(dists^2)
}

# =====================================================
# TASK 4 – delta_t = 1 Minute
# =====================================================
cat("========== TASK 4: delta_t = 1 Minute ==========\n")

preds_physical_1 <- predict_physical(df, delta_t = 1)
preds_naive_1 <- predict_naive(df)

mspe_physical_1 <- calc_mspe(preds_physical_1$lat_pred, preds_physical_1$lon_pred,
                             preds_physical_1$lat_true, preds_physical_1$lon_true)

mspe_naive_1 <- calc_mspe(preds_naive_1$lat_pred, preds_naive_1$lon_pred,
                          preds_naive_1$lat_true, preds_naive_1$lon_true)

cat("\nPhysical model predictions (delta_t = 1 min):\n")
print(head(preds_physical_1, 10))

cat("\nNaive model predictions (delta_t = 1 min):\n")
print(head(preds_naive_1, 10))

cat(sprintf("\nMSPE (Physical, delta_t = 1): %.4f NM^2\n", mspe_physical_1))
cat(sprintf("MSPE (Naive,   delta_t = 1): %.4f NM^2\n", mspe_naive_1))

# =====================================================
# TASK 5 – delta_t = 10 Minutes
# =====================================================
cat("\n========== TASK 5: delta_t = 10 Minutes ==========\n")

preds_physical_10 <- predict_physical(df, delta_t = 10)
preds_naive_10 <- predict_naive(df)

mspe_physical_10 <- calc_mspe(preds_physical_10$lat_pred, preds_physical_10$lon_pred,
                              preds_physical_10$lat_true, preds_physical_10$lon_true)

mspe_naive_10 <- calc_mspe(preds_naive_10$lat_pred, preds_naive_10$lon_pred,
                           preds_naive_10$lat_true, preds_naive_10$lon_true)

cat("\nPhysical model predictions (delta_t = 10 min):\n")
print(head(preds_physical_10, 10))

cat("\nNaive model predictions (delta_t = 10 min):\n")
print(head(preds_naive_10, 10))

cat(sprintf("\nMSPE (Physical, delta_t = 10): %.4f NM^2\n", mspe_physical_10))
cat(sprintf("MSPE (Naive,   delta_t = 10): %.4f NM^2\n", mspe_naive_10))