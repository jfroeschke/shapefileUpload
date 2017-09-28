#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("test"),
  tags$head(includeScript("ga-nwtapp.js"), includeScript("ga-allapps.js")),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
     
      shpPolyInput("user_shapefile", 
                   "Upload polygon shapefile", 
                   "btn_modal_shp")),
    mainPanel(
      actionButton("btn_modal_shp", "Upload shapefile", class="btn-block"),
      uiOutput("Shp_On")
    )
  )
))
