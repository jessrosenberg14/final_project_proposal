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
    drop_na() %>% 
    filter(gender != 0, birth_year <= 2003, birth_year>1937) %>% 
    distinct() %>% 
    sample_frac(.01)
  
  return(bike_rides_df)
    
}

manhattan_rides_df <- map_df(file_names, find_manhattan_rides)
```

Data cleaning steps pre-sampling: - Dropped missing values, including
where gender == 0 (and year of birth is 1969 - default) - Dropped riders
born after 2002 or before 1937 - Removed duplicates

``` r
write_csv(manhattan_rides_df, "manhattan_rides.csv")
```

``` r
manhattan_rides_df = 
  manhattan_rides_df %>% 
    mutate(
      trip_min = tripduration/60, 
      day_of_week = wday(starttime, label = TRUE), 
      start_date = format(starttime, format="%m-%d"), 
      end_date = format(stoptime, format="%m-%d"), 
      year = as.factor(year(starttime)), 
      age = as.numeric(2021-birth_year), 
      age_group = cut(age, breaks=c(-Inf, 25, 35, 45, 55, 65, 85), labels=c("18-25","26-35", "36-45", "46-55", "56-65", "66-85")))
  

manhattan_rides_df %>% 
  group_by(age_group) %>% 
  summarize(min = min(age), max = max(age), obs = n())
```

Data cleaning steps: - Converted trip duration to minutes from seconds -
Created day of the week variable - Created other date-related variables
- Created age variables and age groups

## Exporatory Data Analysis

``` r
manhattan_rides_df %>% 
  group_by(day_of_week, year) %>% 
  summarize(obs = n()) %>% 
  ggplot(aes(x = day_of_week, y = obs, group = year, color = year)) +
  geom_point() + 
  geom_line()
```

Fewer rides during the week in 2020 (presumably because of WFH), but
more rides on the weekends (presumably because people avoid subway/
ubers)

``` r
manhattan_rides_df %>% 
  group_by(start_date, year) %>% 
  summarize(obs = n()) %>% 
  ggplot(aes(x = start_date, y = obs, group = year, color = year)) +
  geom_line() + 
  geom_smooth(se = FALSE)
```

Not that helpful, but not a meaningful difference in numbers of rides
between 2019 and 2020 except maybe March/ April where there appears to
be a slight dip
