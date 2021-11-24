subway\_rides
================

``` r
turnstiles_2019_m = read_csv("2019-turnstile.csv") %>% 
  filter(borough == "M") %>% 
  
turnstiles_2020_m = read_csv("2019-turnstile.csv") %>% 
    filter(borough == "M")
```

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


ridership_covid_changes_2020 = ridership_covid_changes %>% 
  filter(date <= as.Date('2020-12-31'))
```
