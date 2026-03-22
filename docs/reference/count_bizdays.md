# Count the number of business days between a range

Count the number of business days between a range of dates, inclusively.

## Usage

``` r
count_bizdays(from, to, holidays, weekend = c("Sat", "Sun"))
```

## Arguments

- from:

  The beginning of the date range.

- to:

  The end of the date range.

- holidays:

  A vector of dates that are holidays.

- weekend:

  A character vector of three-letter abbreviations of weekday names
  indicating days that should be considered a weekend. Acceptable values
  are: `"Sun"`, `"Mon"`, `"Tue"`, `"Wed"`, `"Thu"`, `"Fri"`, `"Sat"`,
  `"Sun"`.

## Value

A single number.

## Details

Holiday dates can be obtained using
[`get_holidays()`](https://adamoshen.github.io/holideh/reference/get_holidays.md),
[`get_province()`](https://adamoshen.github.io/holideh/reference/get_province.md),
or by defining a custom vector of holidays.

## See also

[`is_bizday()`](https://adamoshen.github.io/holideh/reference/is_bizday.md),
[`is_holiday()`](https://adamoshen.github.io/holideh/reference/off_day.md),
[`is_weekend()`](https://adamoshen.github.io/holideh/reference/off_day.md)

## Examples

``` r
library(lubridate)
#> 
#> Attaching package: 'lubridate'
#> The following objects are masked from 'package:base':
#> 
#>     date, intersect, setdiff, union

winter_holidays <- ymd(c("2025-12-25", "2025-12-26"))

count_bizdays(from = ymd("2025-12-20"), to = ymd("2025-12-31"), holidays = winter_holidays)
#> [1] 6
```
