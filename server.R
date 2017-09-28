

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  shp <- callModule(shpPoly, "user_shapefile", r=r)
  
  
})
