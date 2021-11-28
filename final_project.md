P8105 Final Project: Citi Bikes
================

``` r
manhattan_rides_df <- read_csv("manhattan_rides.csv")

manhattan_rides_df <-
  manhattan_rides_df %>% 
  mutate(
    day_of_week = factor(day_of_week, ordered = T, 
                         levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")), 
    year = factor(year), 
    age_group = factor(age_group, ordered = T,
                       levels = c("18-25","26-35", "36-45", "46-55", "56-65", "66-85"))
  )

manhattan_rides_df %>% 
  group_by(age_group) %>% 
  summarize(min = min(age), max = max(age), obs = n())
```

    ## # A tibble: 6 × 4
    ##   age_group   min   max    obs
    ##   <ord>     <dbl> <dbl>  <int>
    ## 1 18-25        18    25  35068
    ## 2 26-35        26    35 102948
    ## 3 36-45        36    45  56694
    ## 4 46-55        46    55  43430
    ## 5 56-65        56    65  26232
    ## 6 66-85        66    85   6734

## Exporatory Data Analysis

``` r
manhattan_rides_df %>% 
  group_by(day_of_week, year) %>% 
  summarize(obs = n()) %>% 
  ggplot(aes(x = day_of_week, y = obs, group = year, color = year)) +
  geom_point() + 
  geom_line()
```

![](final_project_files/figure-gfm/Rides%20by%20day%20of%20week-1.png)<!-- -->

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

![](final_project_files/figure-gfm/Rides%20per%20day%20summary-1.png)<!-- -->

Not that helpful, but not a meaningful difference in numbers of rides
between 2019 and 2020 except maybe March/ April where there appears to
be a slight dip
