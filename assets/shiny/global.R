#++++++++++++++++++++++++++++++++++++++
#Load libraries
#++++++++++++++++++++++++++++++++++++++
library("shiny")
library("leaflet")
library("httr")
library("jsonlite")
# Further libraries would go here

#+++++++++++++++++++++++++++++++++++++++++++++++++++
# Read in all functions in the functions folder
#+++++++++++++++++++++++++++++++++++++++++++++++++++

list.files("functions") %>%
  purrr::map(~ source(paste0("functions/", .)))

#+++++++++++++++++++++++++++++++++++++++++++++++++++
# Read in all modules in the modules folder
#+++++++++++++++++++++++++++++++++++++++++++++++++++
list.files("modules") %>%
  purrr::map(~ source(paste0("modules/", .)))



