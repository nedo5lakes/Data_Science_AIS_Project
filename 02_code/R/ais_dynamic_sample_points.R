if(!is.null(dev.list())) dev.off()
rm(list = ls())

#i 

#loading the library
library(dplyr)


#loeading the functions
source("02_code/R/functions/get_random_ais_sample.R")
source("02_code/R/functions/impute_zero_with_mean.R")
source("02_code/R/functions/impute_na_with_mean.R")



#applying the function 
ais_sample <- get_random_ais_sample(date = "2024-01-24", max_rows = 1000)
# Saving the sample
write.csv(ais_sample, file = "01_data/ais_dynamic_sample.csv", row.names = FALSE)

summary(ais_sample)
# a lot of NAs and inpossible 0 values



# v Summary of statistics
df_samples <- read.csv("01_data/ais_dynamic_sample.csv")



# Dealing with missing values 
library(data.table)
library("VIM")

df_copy <- copy(df_samples)
print(df_copy)

test <- na.omit(df_copy)

summary(aggr(test,plot=FALSE))

# with na.omit To many values were deleted only 69 left insted of 100 

summary(aggr(df_copy,plot=FALSE))

sample_dt <- setDT(df_copy)


# NaN values exchangig with mean of other non NaN values  value 
sample_dt[, speed := ifelse(
  is.na(speed), 
  round(mean(speed, na.rm = TRUE)), 
  speed
)]

# Summary of missing values before imputation
summary(aggr(sample_dt,plot=FALSE))

#  Function to impute NA values with the mean of each numeric column appied here 

# Applying the function to copy of dataframe to not damage the real dataframe 
sample_dt <- setDT(df_copy)
sample_dt_imputed <- impute_na_with_mean(sample_dt)


summary(aggr(sample_dt_imputed,plot=FALSE))

View(sample_dt_imputed)
# Speed needs to get cleaned as well , making seperate function for future use 


#  Function to replace 0 values in numeric columns with the mean of values > 0

# applying into copy 

sample_dt_speed0 <- impute_zero_with_mean(sample_dt)
View(sample_dt_speed0)

# everything works well now changing the original dataframe 

# firstly Missing-Value-Imputation
sample_dt_imputed <- impute_na_with_mean(setDT(copy(df_samples)))

# secondly 0-value-Imputation 
df_samples_cleaned <- impute_zero_with_mean(sample_dt_imputed)

# calling the function 
df_samples <- df_samples_cleaned


summary(aggr(df_samples,plot=FALSE))
summary(df_samples)
View(df_samples)

# saving the cleaned data frame
write.csv(df_samples, "01_data/ais_dynamic_cleaned.csv", row.names = FALSE)

# check if everything was saved the right way
b <-read.csv("01_data/ais_dynamic_cleaned.csv")







