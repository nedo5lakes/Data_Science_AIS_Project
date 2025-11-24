if(!is.null(dev.list())) dev.off()
rm(list = ls())

#Import Librarys
library(httr)
library(jsonlite)
library(httr2)
library(jsonlite)

library(ggplot2)
library(grid)
library(gridExtra)
!install.packages("gridExtra")




"""a) Briefly describe the AIS data. What information do the respective fields 
in the table contain?"""


#static
url_static <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static"
response_static <- GET(url_static)
text_data_static <- content(response_static, as = "text")
df_static<- fromJSON(text_data_static)
print(df_static)
pdf("03_report/tables/ais_static_preview.pdf",width = 20, height =15)
grid.table(df)
dev.off()


#dynamic 
url_dyn <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_dynamic?select=*&msg_timestamp=gte.2024-01-24T00:00:00Z&limit=100"
response_dyn <- GET(url_dyn)
df_dyn <- fromJSON(content(response_dyn, as = "text"))
print(df_dyn)
pdf("03_report/ais_dynaic_preview.pdf",width = 20, height =15)
grid.table(df_dyn)
dev.off()




" b)How many rows does each table have? How many vessels are recorded?"
# Counting static vessels
url_static_count <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=count()"
df_static_count <- fromJSON(content(GET(url_static_count), as = "text"))
print(df_static_count)
# Output : 220685

# Counting vessels
url_stat_vessel <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=mmsi.count()"
df_stat_vessel <- fromJSON(content(GET(url_stat_vessel), as = "text"))
print(df_stat_vessel)
# same output , which means each row represents one vessel

# c) how many distinct flags 
url_flag_stat <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=mmsi,flag"
response_flag_stat <- GET(url_flag_stat)
df_flag_stat <-fromJSON(content(response_flag_stat, as = "text"))
unique(df_flag_stat$flag)

stat_flag <- unique(df_flag_stat$flag) 
print(stat_flag)


# Whic one occures most often 
library(dplyr)
flag_summary <- df_flag_stat %>%
  group_by(flag) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
print(paste("Most frequent flag:", flag_summary$flag[1]))
print(flag_summary[1, ])

# 1 CN  13489  



#d)  Overview of ais_static

#mmsi 
url_mmsi <-"https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=mmsi.count(),mmsi.max(),mmsi.min()"
response_mmsi<- GET(url_mmsi)
df_mmsi <-fromJSON(content(response_mmsi, as = "text"))
print(df_mmsi)
# Count 220685 , max: 775999039 , min 2010002

#imo 
url_imo <-"https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=imo.count(),imo.max(),imo.min(),imo,imo.avg()"
response_imo<- GET(url_imo)
df_imo <-fromJSON(content(response_imo, as = "text"))
print(df_imo)
# count 112961 max 9999999 min 0 



url_length <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=length.count(),length.sum(),length.max(),length.min(),length.avg()"
response_length <- GET(url_length)
df_length <-fromJSON(content(response_length, as = "text"))
print(df_length)
# count: 2078932 , sum:12867786 , max 1022 min 0 avg 61.89649



url_width <-"https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=width.count(),width.sum(),width.max(),width.min(),width.avg()"
response_width <-GET(url_width)
df_width <-fromJSON(content(response_width, as = "text"))
print(df_width)

#count: 207892 sum: 2371019 max: 126  MIN: 0  AVG:11.40505



destination <- "https://aidaho-edu.uni-hohenheim.de/aisdb/ais_static?select=destination.count()"
response_dest <-GET(destination)
df_dest<-fromJSON(content(response_dest, as = "text"))
print(df_dest)
# count:  111718

# unique names
unique(df_static$name)

# Some unique names: "ZHOU GANG TUO 11@@@@" "PHOENIX VANTAGE"      "YI DE HUI HUANG"     

# unique ship_types 
unique(df_static$ship_type)

# Tug , Tanker , Cargo , Other ,Fishing Vessel , Pleasure Craft , Special Craft , High Speed Craft , Reserved , Sailing Vessel , Passenger Ship

unique(df_static$call_sign)

#following pattern : BRDC@@@" "9V8372"  "0000000" "A6E2358" "T8A4265" "021727@" "@@@@@@@" "975660@" "V7BN9"










