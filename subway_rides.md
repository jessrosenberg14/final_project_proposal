subway_rides
================

``` r
turnstiles_2019_m = read_csv("2019-turnstile.csv") %>% 
  filter(borough == "M") %>% 
  mutate(gtfs_latitude = as.numeric(gtfs_latitude),
         gtfs_longitude = as.numeric(gtfs_longitude))
```

    ## Rows: 159384 Columns: 12

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (9): stop_name, daytime_routes, division, line, borough, structure, gtf...
    ## dbl  (2): entries, exits
    ## date (1): date

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
turnstiles_2020_m = read_csv("2019-turnstile.csv") %>% 
    filter(borough == "M") %>% 
    mutate(gtfs_latitude = as.numeric(gtfs_latitude),
         gtfs_longitude = as.numeric(gtfs_longitude))
```

    ## Rows: 159384 Columns: 12

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (9): stop_name, daytime_routes, division, line, borough, structure, gtf...
    ## dbl  (2): entries, exits
    ## date (1): date

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

ter = total estimated ridership pc = percent change

``` r
ridership_covid_changes = read_csv("covid-ridership.csv") %>% 
  janitor::clean_names() %>% 
  mutate(date = as.Date(date, "%m/%d/%Y")) %>% 
  rename(buses_ter = buses_total_estimated_ridership) %>% 
  rename(lirr_ter = lirr_total_estimated_ridership) %>% 
  rename(metro_north_ter = metro_north_total_estimated_ridership) %>% 
  rename(subways_ter = subways_total_estimated_ridership) %>% 
  rename(subways_pc = subways_percent_change_from_pre_pandemic_equivalent_day) %>% 
  rename(metro_north_pc = metro_north_percent_change_from_2019_monthly_weekday_saturday_sunday_average) %>% 
  rename(lirr_pc = lirr_percent_change_from_2019_monthly_weekday_saturday_sunday_average) %>% 
  rename(buses_pc = buses_percent_change_from_pre_pandemic_equivalent_day) %>% 
  rename(bridges_and_tunnels_pc = bridges_and_tunnels_percent_change_from_pre_pandemic_equivalent_day) %>% 
  rename(access_a_ride_ter = access_a_ride_total_scheduled_trips) %>% 
  rename(access_a_ride_pc = access_a_ride_percent_change_from_pre_pandemic_equivalent_day)
```

    ## Rows: 628 Columns: 13

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (8): Date, Subways: % Change From Pre-Pandemic Equivalent Day, Buses: % ...
    ## dbl (5): Subways: Total Estimated Ridership, Buses: Total Estimated Ridershi...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
ridership_covid_changes_2020 = ridership_covid_changes %>% 
  filter(date <= as.Date('2020-12-31'))
```

<<<<<<< HEAD
``` r
library(leaflet)
library(leaflet.extras)
library(magrittr)

# define center of map 


viz_map_subway = 
  leaflet() %>%
  addTiles() %>% 
  setView(-74.00, 40.71, zoom = 12) %>% 
  addHeatmap(lng=~gtfs_longitude,lat=~gtfs_latitude,intensity=~exits,max=100,radius=20,blur=10)
```
=======
Practice Map

``` r
sample = turnstiles_2019_m %>% 
  filter(date == as.Date('2019-01-20'))

pal <- colorNumeric(palette = "Blues",
                    domain = sample$exits)

labs <- lapply(seq(nrow(sample)), function(i) {
  paste0( '<p> Station Name: ', sample[i, "stop_name"], '<p></p> Subway Lines: ', sample[i, "daytime_routes"])
})

my_leaf = leaflet(sample) %>%
  setView(-74.00, 40.78, zoom = 11) %>%
  addProviderTiles("CartoDB.Positron") %>% 
  addCircleMarkers(
    lat = ~ gtfs_latitude, 
    lng = ~ gtfs_longitude, 
    color = ~pal(exits),
    stroke = FALSE, 
    fillOpacity = 0.85,
    label = lapply(labs, htmltools::HTML)) %>% 
  addLegend("bottomright", pal = pal, values = ~exits,
    title = "2019 Ridership",
    opacity = 1)
```

Creating Map with Shiny Attempt Kinda Works

``` r
pal <- colorNumeric(palette = "Blues",
                    domain = turnstiles_2019_m$exits)
```

    ## Warning: One or more parsing issues, see `problems()` for details

``` r
dateRange = 
  turnstiles_2019_m %>% 
  summarise(min = min(date), max = max(date)) %>% 
  as_vector() %>% 
  as_date()

ui <- fluidPage(
    
  titlePanel("Manhattan Subway Ridership Overtime"),
    
  sliderInput(inputId = "date", 
                label = "Date:",
                min = as.Date("2019-01-01","%Y-%m-%d"),
                max = as.Date("2019-12-31","%Y-%m-%d"),
                value=as.Date("2019-01-01"),
                timeFormat="%Y-%m-%d"),
    leafletOutput("nyc_map")
)

server <- function(input, output){
    
    output$nyc_map <- renderLeaflet({

        leaflet(turnstiles_2019_m) %>%
        addProviderTiles("CartoDB.Positron") %>% 
        addCircleMarkers(
          lat = ~ gtfs_latitude, 
          lng = ~ gtfs_longitude, 
          color = ~pal(exits),
          stroke = FALSE, 
          fillOpacity = 0.85,
          label = lapply(labs, htmltools::HTML)) %>% 
        addLegend("bottomright", pal = pal, values = ~exits,
                  title = "2019 Ridership",
                 opacity = 1)
    })
}

shinyApp(ui, server)
```

<div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div>
>>>>>>> 69c1fd2c18313b8ffb791cb7212ae354b6940bfc
