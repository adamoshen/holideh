# Detect business days

In a vector of dates, detect the business days (i.e. exclude holidays
and weekends).

## Usage

``` r
is_bizday(x, holidays, weekend = c("Sat", "Sun"))
```

## Arguments

- x:

  A vector of dates or date-times. If date-times are supplied, the date
  component will be extracted.

- holidays:

  A vector of dates that are holidays.

- weekend:

  A character vector of three-letter abbreviations of weekday names
  indicating days that should be considered a weekend. Acceptable values
  are: `"Sun"`, `"Mon"`, `"Tue"`, `"Wed"`, `"Thu"`, `"Fri"`, `"Sat"`,
  `"Sun"`.

## Value

A logical vector of length equal to `x`.

## Details

Holiday dates can be obtained using
[`get_holidays()`](https://adamoshen.github.io/holideh/reference/get_holidays.md),
[`get_province()`](https://adamoshen.github.io/holideh/reference/get_province.md),
or by defining a custom vector of holidays.

## See also

[`is_holiday()`](https://adamoshen.github.io/holideh/reference/off_day.md),
[`is_weekend()`](https://adamoshen.github.io/holideh/reference/off_day.md),
[`count_bizdays()`](https://adamoshen.github.io/holideh/reference/count_bizdays.md)

## Examples

``` r
library(lubridate)

dates <- seq.Date(from = ymd("2025-12-20"), to = ymd("2025-12-31"), by = "1 day")
winter_holidays <- ymd(c("2025-12-25", "2025-12-26"))

rlang::set_names(is_bizday(dates, holidays = winter_holidays), dates)
#> 2025-12-20 2025-12-21 2025-12-22 2025-12-23 2025-12-24 2025-12-25 2025-12-26 
#>      FALSE      FALSE       TRUE       TRUE       TRUE      FALSE      FALSE 
#> 2025-12-27 2025-12-28 2025-12-29 2025-12-30 2025-12-31 
#>      FALSE      FALSE       TRUE       TRUE       TRUE 
```
