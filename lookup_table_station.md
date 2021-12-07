lookup_table_stations
================

``` r
file_names <- list.files(path = "./data")

find_unique_stations <- function(data_name){
  
  start_stations <-
    read_csv(str_c("./data/", data_name)) %>% 
    janitor::clean_names() %>% 
    select(c("start_station_id", "start_station_name", "start_station_latitude", "start_station_longitude")) %>%
    distinct() %>% 
    rename_all(~str_replace(.,"^start_station_","")) %>% 
    filter(id != "NULL") %>% 
    mutate(
      id = as.numeric(id)
    )
  
  end_stations <-
    read_csv(str_c("./data/", data_name)) %>% 
    janitor::clean_names() %>% 
    select(c("end_station_id", "end_station_name", "end_station_latitude", "end_station_longitude")) %>%
    distinct() %>% 
    rename_all(~str_replace(.,"^end_station_","")) %>% 
    filter(id != "NULL") %>% 
    mutate(
      id = as.numeric(id)
    )
  
  stations <- 
    bind_rows(start_stations, end_stations) %>% 
    distinct() %>% 
    arrange(id)
  
  return(stations)

}
```

``` r
nyc_stations <-
  map_df(file_names, find_unique_stations) %>% 
  distinct() %>% 
  arrange(id) %>% 
  mutate(
    location = reverse_geo(lat = latitude, long = longitude, method = 'osm')
  ) %>% 
  unnest(location) %>% 
  select(!(c(lat, long)))
```

``` r
write_csv(nyc_stations, "nyc_stations.csv")
```

``` r
manhattan_stations <-
  nyc_stations %>%
  filter(str_detect(address, "(?<=Manhattan, )New York(?= County)") == T)

write_csv(manhattan_stations, "manhattan_stations.csv")
```
