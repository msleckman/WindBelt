
#### WINDBELT ####

library(sf)
library(tidyverse)
library(sp)
install.packages("gstat","maps")
library(gstat)
library(maps)
library(leaflet)
library(dplyr)


Windbelt_Df <- read_csv("Windbelt Project Database.csv", header =T)

Windbelt_df_3years <- Windbelt_Df %>% 
  filter()
  
pal <- colorFactor(palette = unique(as.character(Windbelt_Df$`Owner Type`)))

factpal <- colorFactor(pal, Windbelt_Df$`Owner Type`)
qpal <- colorQuantile("Blues", Windbelt_Df$`Owner Type`, n = 7)

m <- leaflet(Windbelt_Df) %>% 
  addTiles() %>% 
  addCircles(lat = Windbelt_Df$Latitude,
             lng = Windbelt_Df$Longitude, 
             popup = as.character(Windbelt_Df$`Master Project Name`),
             weight = 3, radius = 30, 
             color = ~pal(`Owner Type`)) %>% 
addLegend("bottomright", colors =  pal, values = ~`Owner Type`)
            # labels="wind power projects",
            # title="Wind Projects in the Wind Belt")
  m
  
  
unique(Windbelt_Df$`Owner Type`)

ggplot(Windbelt_Df) + 
  geom_sf()