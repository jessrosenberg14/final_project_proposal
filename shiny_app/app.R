#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(lubridate)
library(shiny)
library(leaflet)
library(sf)
library(rgdal)

# Data Import
turnstiles_data = read_csv("./data/shiny_data.csv") %>% 
    drop_na()

labs = lapply(seq(nrow(turnstiles_data)), function(i) {
    paste0( '<p> Station Name: ', turnstiles_data[i, "stop_name"], '<p></p> Subway Lines: ', turnstiles_data[i, "daytime_routes"])
})

pal = colorNumeric(palette = "turbo", domain = turnstiles_data$turnstile_count) 

subway_lines = st_read(
    "./data/subway_lines_data/geo_export_cef610e7-3c97-412c-ac0a-44a37bcf4f9b.shp")

subway_lines = st_transform(subway_lines, CRS("+proj=longlat +ellps=GRS80 +datum=WGS84")) 



# Define UI for application 
ui <- fillPage(
    
    titlePanel("Subway Ridership Overtime"),
    
    sidebarPanel(
        
        sliderInput("date", 
                    label = h3("Date Range"), 
                    min = as.Date("2019-01-01","%Y-%m-%d"),
                    max = as.Date("2019-07-01","%Y-%m-%d"),
                    value  = as.Date("2019-03-03","%Y-%m-%d"),
                    timeFormat = "%d %b %y",
                    step = 7,
                    animate = animationOptions(interval = 500, loop = FALSE),
                    ticks = F),
        
        checkboxGroupInput("borough_choice", label = h3("NYC Borough"), 
                           choices = c("Queens", "Brooklyn", "Bronx", "Manhattan", "Staten Island"),
                           selected = "Manhattan"),
        
        radioButtons("turnstile_type_choice", label = h3("Turnstile Data"),
                     choices = c("exits", "entries"), 
                     selected = "exits")
    ),
    
    mainPanel(
        leafletOutput("nyc_map")
    )
)


# Define server 
server = function(input, output, session) {
    
    selectedData = reactive({
        turnstiles_data %>% 
            filter(
                turnstile_type == input$turnstile_type_choice &
                borough %in% input$borough_choice &
                date >= as.Date(input$date, "%Y-%m-%d"))
    })
    
    output$nyc_map = renderLeaflet({
        nyc_map = leaflet(selectedData()) %>% 
            setView(-74.00, 40.78, zoom = 11) %>%
            addProviderTiles("CartoDB.Positron") %>% 
            addPolylines(data = subway_lines) %>%
            addCircleMarkers(
                data = selectedData(),
                lat = ~ gtfs_latitude, 
                lng = ~ gtfs_longitude, 
                radius = 3,
                color = ~ pal(turnstile_count),
                stroke = FALSE, 
                fillOpacity = 0.85,
                label = lapply(labs, htmltools::HTML)) %>% 
        addLegend("bottomright", pal = pal,
                  values = ~ turnstile_count,
                  title = "Ridership",
                  opacity = 1)
        
        nyc_map
    })
    
} 

# Run the application 
shinyApp(ui = ui, server = server) 

