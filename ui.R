

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("test"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput("shp_file", "Choose CSV File",
                accept=c(".shp",".dbf",
                         ".sbn",".sbx",
                         ".shx",".prj"),
                multiple=TRUE
    )),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("Map"),
      uiOutput("test")
    )
  )
))
