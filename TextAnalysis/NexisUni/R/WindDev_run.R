
#### WINDBELT-mapping low impact sites####

library(sf)
library(tidyverse)
library(sp)
#install.packages("gstat","maps")
library(gstat)
library(maps)
library(leaflet)
library(dplyr)


Windbelt_Df <- read_csv("G:/Data/wind project dataset/LR_EndD.csv")
names(Windbelt_Df)
colnames(Windbelt_Df)[colnames(Windbelt_Df)=="lr_tif"] <- "low/high_impact"


Windbelt_Df <- Windbelt_Df %>% 
  mutate(`low/high_impact` = recode(`low/high_impact`, "0" = 'highimpactarea',
                            '1' = 'lowimpactarea',
                            '2' = "lowimpactarea-developed",
                            'NA' = 'NA'))


unique(Windbelt_Df$`low/high_impact`)

Windbelt_Df$`low/high_impact` <- as.factor(Windbelt_Df$`low/high_impact`)
levels(Windbelt_Df$`low/high_impact`)

factpal <- colorFactor(topo.colors(3), Windbelt_Df$`low/high_impact`)

m <- leaflet(Windbelt_Df) %>% 
  addTiles() %>% 
  addCircles(lat =~Latitude,
             lng = ~Longitude, 
             color = ~factpal(`low/high_impact`),
             popup = ~ProjectNam, weight = 3, radius = 30) %>% 
  addLegend("bottomright", pal=factpal, values = ~`low/high_impact`, 
            title = "Existing/proposed/cancelled windfarms in low vs. high impact areas")
m

