
#### WINDBELT-mapping low impact sites####

library(sf)
library(tidyverse)
library(sp)
#install.packages("gstat","maps")
library(gstat)
library(maps)
library(leaflet)
library(dplyr)


Windbelt_Df <- read_csv("G:/Data/wind project dataset/ventyx_withLR.csv")

Windbelt_Df$lowimpact <- Windbelt_Df$lr_tif_1

Windbelt_Df <- Windbelt_Df %>% 
  select(-lr_tif) %>% 
  mutate(lowimpact = recode(lowimpact, "0" = 'highimpactarea',
                            '1' = 'lowimpactarea',
                            '2' = "lowimpactarea-developed",
                            'NA' = 'NA'))


unique(Windbelt_Df$lowimpact)
Windbelt_df_3years <- Windbelt_Df %>% 
  filter()

pal <- colorNumeric(c("red", "green", "blue"), 1:10)
pal

pal <- colorFactor(palette = )
pal <- colorFactor(c("red", "green", "blue"), 1:10)
pal

Windbelt_Df$lowimpact <- as.factor(Windbelt_Df$lowimpact)
levels(Windbelt_Df$lowimpact)

factpal <- colorFactor(topo.colors(3), Windbelt_Df$lowimpact)

m <- leaflet(Windbelt_Df) %>% 
  addTiles() %>% 
  addCircles(lat =~Latitude,
             lng = ~Longitude, 
             color = ~factpal(lowimpact),
             popup = ~ProjectNam, weight = 3, radius = 30) %>% 
  addLegend("bottomright", pal=factpal, values = ~lowimpact, 
            title = "windfarms in low vs. high impact areas")

addLegend("bottomright", pal = pal, values = ~gdp_md_est,
          title = "Est. GDP (2010)",
          labFormat = labelFormat(prefix = "$"),
          opacity = 1)
