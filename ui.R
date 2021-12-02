library(shiny)
library(tidyverse)
library(lubridate)
library(shiny)
library(leaflet)

fillPage(
  
  titlePanel("Subway Ridership Overtime"),
  
  sidebarPanel(
    
    sliderInput("date", 
                label = h3("Date Range"), 
                min = as.Date("2019-01-06","%Y-%m-%d"),
                max = as.Date("2020-12-20","%Y-%m-%d"),
                value  = as.Date("2019-03-03","%Y-%m-%d"),
                timeFormat = "%d %b %y",
                step = 1,
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
