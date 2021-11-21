P8105 Final Project: Citi Bikes
================

``` r
file_names <- list.files(path = "./data")
manhattan_stations <- read_csv("manhattan_stations.csv")

find_manhattan_rides <- function(data_name) {
  
  set.seed(8105)
  
  bike_rides_df <-
    read_csv(str_c("./data/", data_name)) %>% 
    janitor::clean_names() %>% 
    mutate(
      start_station_id = as.numeric(start_station_id), 
      end_station_id = as.numeric(end_station_id)
    ) %>% 
    filter(
      start_station_id %in% pull(manhattan_stations, id), 
      end_station_id %in% pull(manhattan_stations, id)
    ) %>% 
    sample_n(., 10000)
  
  return(bike_rides_df)
    
}
```
