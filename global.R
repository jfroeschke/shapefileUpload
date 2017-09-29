## global.R

suppressMessages({
  library(shiny)
  library(shinyBS)
  library(shinyjs)
  library(leaflet)
  library(DT)
  library(rgdal)
  library(raster)
  library(data.table)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  library(sf)
  library(mapview)
})

######### Create an sp object descrbing extent

coords <- matrix(c(-99, 32,
                   -99, 23,
                   -80, 23,
                   -80, 32,
                   -99, 32), 
                 ncol = 2, byrow = TRUE)
P1 <- Polygon(coords)
Ps1 <- SpatialPolygons(list(Polygons(list(P1), ID = "a")),
                       proj4string=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
Ps2SF <- st_as_sfc(Ps1)
