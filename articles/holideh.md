# Introduction to holideh

This article contains some more in-depth examples on how the package can
be used.

## Packages

``` r
library(magrittr)
library(tibble)
library(dplyr)
library(lubridate)
library(purrr)
library(holideh)
```

## Get federal holidays

To get the federal holidays for the 2019 year, we can use:

``` r
holidays19 <- get_holidays(2019, federal = TRUE)

holidays19
```

``` fansi
#> # A tibble: 11 × 7
#>    date       observed_date name_en         name_fr federal holiday_id provinces
#>    <date>     <date>        <chr>           <chr>   <lgl>        <int> <list>   
#>  1 2019-01-01 2019-01-01    New Year's Day  Jour d… TRUE             1 <tibble> 
#>  2 2019-04-19 2019-04-19    Good Friday     Vendre… TRUE             8 <tibble> 
#>  3 2019-04-22 2019-04-22    Easter Monday   Lundi … TRUE             9 <tibble> 
#>  4 2019-05-20 2019-05-20    Victoria Day    Fête d… TRUE            12 <tibble> 
#>  5 2019-07-01 2019-07-01    Canada Day      Fête d… TRUE            16 <tibble> 
#>  6 2019-08-05 2019-08-05    Civic Holiday   Congé … TRUE            19 <tibble> 
#>  7 2019-09-02 2019-09-02    Labour Day      Fête d… TRUE            27 <tibble> 
#>  8 2019-10-14 2019-10-14    Thanksgiving    Action… TRUE            31 <tibble> 
#>  9 2019-11-11 2019-11-11    Remembrance Day Jour d… TRUE            32 <tibble> 
#> 10 2019-12-25 2019-12-25    Christmas Day   Noël    TRUE            33 <tibble> 
#> 11 2019-12-26 2019-12-26    Boxing Day      Lendem… TRUE            34 <tibble>
```

### More than one year

Since the `year` parameter of
[`get_holidays()`](https://adamoshen.github.io/holideh/reference/get_holidays.md)
only accepts a single value, we can use
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html) to get
the holidays for multiple years, as a list. Since each list-element is a
tibble, we can follow this up with
[`purrr::list_rbind()`](https://purrr.tidyverse.org/reference/list_c.html)
to combine all holidays into a single tibble.

To get the federal holidays for the 2026 to 2028 years, we can use:

``` r
holidays <- 2026:2028 %>%
  map(\(year) get_holidays(year, federal = TRUE)) %>%
  list_rbind()

holidays
```

``` fansi
#> # A tibble: 36 × 7
#>    date       observed_date name_en         name_fr federal holiday_id provinces
#>    <date>     <date>        <chr>           <chr>   <lgl>        <int> <list>   
#>  1 2026-01-01 2026-01-01    New Year's Day  Jour d… TRUE             1 <tibble> 
#>  2 2026-04-03 2026-04-03    Good Friday     Vendre… TRUE             8 <tibble> 
#>  3 2026-04-06 2026-04-06    Easter Monday   Lundi … TRUE             9 <tibble> 
#>  4 2026-05-18 2026-05-18    Victoria Day    Fête d… TRUE            12 <tibble> 
#>  5 2026-07-01 2026-07-01    Canada Day      Fête d… TRUE            16 <tibble> 
#>  6 2026-08-03 2026-08-03    Civic Holiday   Congé … TRUE            19 <tibble> 
#>  7 2026-09-07 2026-09-07    Labour Day      Fête d… TRUE            27 <tibble> 
#>  8 2026-09-30 2026-09-30    National Day f… Journé… TRUE            29 <tibble> 
#>  9 2026-10-12 2026-10-12    Thanksgiving    Action… TRUE            31 <tibble> 
#> 10 2026-11-11 2026-11-11    Remembrance Day Jour d… TRUE            32 <tibble> 
#> # ℹ 26 more rows
```

The `observed_date` column is likely the column to be used in any
calculations as this is the date between Monday and Friday when the
holiday is observed. For example, in the federal government, if New
Year’s Day falls on a Sunday, then it is observed on the Monday (i.e. we
don’t work on the Monday).

## Get holidays for a single province/territory

To get the holidays for the province of Ontario for the 2019 year, we
can use:

``` r
holidays_on19 <- get_province("ON", year = 2019)

holidays_on19
```

``` fansi
#> # A tibble: 9 × 10
#>   date       observed_date name_en        name_fr federal holiday_id province_id
#>   <date>     <date>        <chr>          <chr>   <lgl>        <int> <chr>      
#> 1 2019-01-01 2019-01-01    New Year's Day Jour d… TRUE             1 ON         
#> 2 2019-02-18 2019-02-18    Family Day     Fête d… FALSE            5 ON         
#> 3 2019-04-19 2019-04-19    Good Friday    Vendre… TRUE             8 ON         
#> 4 2019-05-20 2019-05-20    Victoria Day   Fête d… TRUE            12 ON         
#> 5 2019-07-01 2019-07-01    Canada Day     Fête d… TRUE            16 ON         
#> 6 2019-09-02 2019-09-02    Labour Day     Fête d… TRUE            27 ON         
#> 7 2019-10-14 2019-10-14    Thanksgiving   Action… TRUE            31 ON         
#> 8 2019-12-25 2019-12-25    Christmas Day  Noël    TRUE            33 ON         
#> 9 2019-12-26 2019-12-26    Boxing Day     Lendem… TRUE            34 ON         
#> # ℹ 3 more variables: province_name_en <chr>, province_name_fr <chr>,
#> #   source_info <list>
```

To get the holidays for more than one province/territory, or for a
single province/territory over multiple years, we can once again use
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html) for the
iteration, and
[`purrr::list_rbind()`](https://purrr.tidyverse.org/reference/list_c.html)
to row-bind the results.

## Operations with business days

### A simple example

In 2027, Christmas and Boxing Day fall on Saturday and Sunday,
respectively. Therefore, they will be observed the proceeding Monday and
Tuesday.

``` r
simple_example <- tibble(
  dates = seq(from = ymd("2027-12-20"), to = ymd("2028-01-05"), by = "1 day")
)

simple_example
```

``` fansi
#> # A tibble: 17 × 1
#>    dates     
#>    <date>    
#>  1 2027-12-20
#>  2 2027-12-21
#>  3 2027-12-22
#>  4 2027-12-23
#>  5 2027-12-24
#>  6 2027-12-25
#>  7 2027-12-26
#>  8 2027-12-27
#>  9 2027-12-28
#> 10 2027-12-29
#> 11 2027-12-30
#> 12 2027-12-31
#> 13 2028-01-01
#> 14 2028-01-02
#> 15 2028-01-03
#> 16 2028-01-04
#> 17 2028-01-05
```

For a federal government setting, you will likely be using the observed
dates, not the actual holiday dates:

``` r
holiday_dates <- pull(holidays, date)
obs_dates <- pull(holidays, observed_date)
```

The example below gives an overview of the helpers in this package:

``` r
simple_example <- simple_example %>%
  mutate(
    # `wday()` is from lubridate
    day_of_week = wday(dates, label = TRUE, abbr = FALSE),
    
    # Check if a date is a weekend
    weekend = is_weekend(dates),
    
    # Check if a holiday falls on a date using the "actual dates"
    true_holiday = is_holiday(dates, holiday_dates),
    
    # Check if a holiday falls on a date using the "observed dates"
    obs_holiday = is_holiday(dates, obs_dates),
    
    # Check if a date is a business day (i.e. not holiday + not weekend)
    bizday = is_bizday(dates, holidays = obs_dates)
  ) %>%
  left_join(
    select(holidays, observed_date, name_en),
    by = c("dates" = "observed_date")
  )

simple_example
```

``` fansi
#> # A tibble: 17 × 7
#>    dates      day_of_week weekend true_holiday obs_holiday bizday name_en       
#>    <date>     <ord>       <lgl>   <lgl>        <lgl>       <lgl>  <chr>         
#>  1 2027-12-20 Monday      FALSE   FALSE        FALSE       TRUE   NA            
#>  2 2027-12-21 Tuesday     FALSE   FALSE        FALSE       TRUE   NA            
#>  3 2027-12-22 Wednesday   FALSE   FALSE        FALSE       TRUE   NA            
#>  4 2027-12-23 Thursday    FALSE   FALSE        FALSE       TRUE   NA            
#>  5 2027-12-24 Friday      FALSE   FALSE        FALSE       TRUE   NA            
#>  6 2027-12-25 Saturday    TRUE    TRUE         FALSE       FALSE  NA            
#>  7 2027-12-26 Sunday      TRUE    TRUE         FALSE       FALSE  NA            
#>  8 2027-12-27 Monday      FALSE   FALSE        TRUE        FALSE  Christmas Day 
#>  9 2027-12-28 Tuesday     FALSE   FALSE        TRUE        FALSE  Boxing Day    
#> 10 2027-12-29 Wednesday   FALSE   FALSE        FALSE       TRUE   NA            
#> 11 2027-12-30 Thursday    FALSE   FALSE        FALSE       TRUE   NA            
#> 12 2027-12-31 Friday      FALSE   FALSE        FALSE       TRUE   NA            
#> 13 2028-01-01 Saturday    TRUE    TRUE         FALSE       FALSE  NA            
#> 14 2028-01-02 Sunday      TRUE    FALSE        FALSE       FALSE  NA            
#> 15 2028-01-03 Monday      FALSE   FALSE        TRUE        FALSE  New Year's Day
#> 16 2028-01-04 Tuesday     FALSE   FALSE        FALSE       TRUE   NA            
#> 17 2028-01-05 Wednesday   FALSE   FALSE        FALSE       TRUE   NA
```

### A more difficult (realistic) example

Consider the scenario where we calculate productivity as the number of
points accumulated in a reporting period divided by the number of
business days. In addition, suppose that the points are reported on a
biweekly basis on Wednesdays. Here, the goal is to make use of the
[`count_bizdays()`](https://adamoshen.github.io/holideh/reference/count_bizdays.md)
function, which counts the number of business days between two dates
(inclusively).

``` r
real_example <- tibble(
  end = seq(from = ymd("2027-11-03"), to = ymd("2028-01-27"), by = "2 weeks"),
  points = ceiling(runif(length(end), min = 90, max = 120))
)

real_example
```

``` fansi
#> # A tibble: 7 × 2
#>   end        points
#>   <date>      <dbl>
#> 1 2027-11-03    103
#> 2 2027-11-17    111
#> 3 2027-12-01     95
#> 4 2027-12-15    117
#> 5 2027-12-29     94
#> 6 2028-01-12    120
#> 7 2028-01-26    109
```

To this data frame, we need to add the start of the reporting period (13
days prior):

``` r
real_example <- real_example %>%
  mutate(start = end - days(13)) %>%
  relocate(start)

real_example
```

``` fansi
#> # A tibble: 7 × 3
#>   start      end        points
#>   <date>     <date>      <dbl>
#> 1 2027-10-21 2027-11-03    103
#> 2 2027-11-04 2027-11-17    111
#> 3 2027-11-18 2027-12-01     95
#> 4 2027-12-02 2027-12-15    117
#> 5 2027-12-16 2027-12-29     94
#> 6 2027-12-30 2028-01-12    120
#> 7 2028-01-13 2028-01-26    109
```

Now that we have the start and end dates, we can calculate the number of
business days in the reporting period. Note that
[`count_bizdays()`](https://adamoshen.github.io/holideh/reference/count_bizdays.md)
is not vectorised over `start` and `end`, so we will need to wrap it in
[`map2_int()`](https://purrr.tidyverse.org/reference/map2.html). Once we
have the number of business days, calculating productivity is
straightforward:

``` r
real_example <- real_example %>%
  mutate(
    n_bizdays = map2_int(
      start, end,
      \(from, to) count_bizdays(from, to, holidays = obs_dates)
    ),
    productivity = points / n_bizdays
  )

real_example
```

``` fansi
#> # A tibble: 7 × 5
#>   start      end        points n_bizdays productivity
#>   <date>     <date>      <dbl>     <int>        <dbl>
#> 1 2027-10-21 2027-11-03    103        10         10.3
#> 2 2027-11-04 2027-11-17    111         9         12.3
#> 3 2027-11-18 2027-12-01     95        10          9.5
#> 4 2027-12-02 2027-12-15    117        10         11.7
#> 5 2027-12-16 2027-12-29     94         8         11.8
#> 6 2027-12-30 2028-01-12    120         9         13.3
#> 7 2028-01-13 2028-01-26    109        10         10.9
```

We can check our work by zooming in to the period of 2027-12-16 to
2027-12-29 and making use of the helper functions previously
demonstrated in the simple example.

``` r
tibble(
  dates = seq(from = ymd("2027-12-16"), to = ymd("2027-12-29"), by = "1 day"),
  day_of_week = wday(dates, label = TRUE, abbr = FALSE)
) %>%
  mutate(
    # Check if a date is a weekend
    weekend = is_weekend(dates),
    
    # Check if a holiday falls on a date using the "actual dates"
    true_holiday = is_holiday(dates, holiday_dates),
    
    # Check if a holiday falls on a date using the "observed dates"
    obs_holiday = is_holiday(dates, obs_dates),
    
    # Check if a date is a business day (i.e. not holiday + not weekend)
    bizday = is_bizday(dates, holidays = obs_dates)
  ) %>%
  left_join(
    select(holidays, observed_date, name_en),
    by = c("dates" = "observed_date")
  )
```

``` fansi
#> # A tibble: 14 × 7
#>    dates      day_of_week weekend true_holiday obs_holiday bizday name_en      
#>    <date>     <ord>       <lgl>   <lgl>        <lgl>       <lgl>  <chr>        
#>  1 2027-12-16 Thursday    FALSE   FALSE        FALSE       TRUE   NA           
#>  2 2027-12-17 Friday      FALSE   FALSE        FALSE       TRUE   NA           
#>  3 2027-12-18 Saturday    TRUE    FALSE        FALSE       FALSE  NA           
#>  4 2027-12-19 Sunday      TRUE    FALSE        FALSE       FALSE  NA           
#>  5 2027-12-20 Monday      FALSE   FALSE        FALSE       TRUE   NA           
#>  6 2027-12-21 Tuesday     FALSE   FALSE        FALSE       TRUE   NA           
#>  7 2027-12-22 Wednesday   FALSE   FALSE        FALSE       TRUE   NA           
#>  8 2027-12-23 Thursday    FALSE   FALSE        FALSE       TRUE   NA           
#>  9 2027-12-24 Friday      FALSE   FALSE        FALSE       TRUE   NA           
#> 10 2027-12-25 Saturday    TRUE    TRUE         FALSE       FALSE  NA           
#> 11 2027-12-26 Sunday      TRUE    TRUE         FALSE       FALSE  NA           
#> 12 2027-12-27 Monday      FALSE   FALSE        TRUE        FALSE  Christmas Day
#> 13 2027-12-28 Tuesday     FALSE   FALSE        TRUE        FALSE  Boxing Day   
#> 14 2027-12-29 Wednesday   FALSE   FALSE        FALSE       TRUE   NA
```

✅ There are eight business days in this reporting period, which matches
our results above.
