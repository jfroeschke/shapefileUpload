
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  userFile <- reactive({
    validate(need(input$shp_file, message=FALSE))
    input$shp_file
  })
  
  shp <- reactive({
    req(input$shp_file)
    if(!is.data.frame(userFile())) return()
    infiles <- userFile()$datapath
    dir <- unique(dirname(infiles))
    outfiles <- file.path(dir, userFile()$name)
    purrr::walk2(infiles, outfiles, ~file.rename(.x, .y))
    x <- try(readOGR(dir, strsplit(userFile()$name[1], "\\.")[[1]][1]), TRUE)
    if(class(x)=="try-error") NULL else x
  })
  
  valid_proj <- reactive({ req(shp()); if(is.na(proj4string(shp()))) FALSE else TRUE })
  
  shp_wgs84 <- reactive({
    req(shp(), valid_proj())
    if(valid_proj()) spTransform(shp(), CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")) else NULL
  })
   
  shp_SF <- reactive({
    Ps2SF <- st_as_sfc(shp_wgs84())
  })
  
  check_Bounds <-reactive({
    IntersectionOut <-  st_intersection(shp_SF(), Ps2SF)
    df <- as.data.frame(IntersectionOut)
    dfNROW <- nrow(df) ##if nrow > 0 then positive intersection
    dfNROW
  })
    
  
  output$Map <- renderLeaflet({ leaflet() %>% setView(0, 0, zoom=2) %>% 
      addTiles() %>% 
      addPolygons(data=shp_SF()) %>% 
      addPolygons(data=Ps2SF) %>% 
      addMouseCoordinates(style=("basic"))
  })
  
  
   output$test <- renderUI({
      if(!length(input$shp_file)) return(h4("No shapefile uploaded."))
  if(is.null(shp())) return(HTML(
    "<h4>Invalid file(s).</h4><h5>Upload any necessary shapefile components, e.g.:</h5>
    <p><em>.dbf, .prj, .sbn, .sbx, .shp</em> and <em>.shx</em></p>"))
  if(!valid_proj()) return(h4("Shapefile is missing projection."))
     if(check_Bounds()==0) return("Shapefile does not overlap map data.")
  #if(!valid_domain()) return(h4("Shapefile does not overlap map data."))
  #if(!is.null(input$mask_btn) && input$mask_btn==0) return(h4("Shapefile loaded. Click to apply mask."))
  #if(!is.null(out())) return(h4("Mask complete. You may close this window."))
  #if(!is.null(input$mask_btn) && input$mask_btn > 0)
     })
  
})
