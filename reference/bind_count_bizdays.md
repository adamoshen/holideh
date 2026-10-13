# Bind the count of business days to a data frame

Bind the count of the number of business days between an inclusive range
of dates, stored in columns of a data frame, to the data frame.

## Usage

``` r
bind_count_bizdays(x, from, to, holidays, weekend = c("Sat", "Sun"))
```

## Arguments

- x:

  A data frame, or data frame extension.

- from:

  The column of `x` containing the start of date ranges.

- to:

  The column of `x` containing the end of date ranges.

- holidays:

  A vector of dates that are holidays.

- weekend:

  A character vector of three-letter abbreviations of weekday names
  indicating days that should be considered a weekend. Acceptable values
  are: `"Sun"`, `"Mon"`, `"Tue"`, `"Wed"`, `"Thu"`, `"Fri"`, `"Sat"`.

## Value

A data frame of the same type as `x`, with an additional column named
`n_bizdays`.

## See also

[`count_bizdays()`](https://adamoshen.github.io/holideh/reference/count_bizdays.md)

## Examples

``` r
library(tibble)
library(lubridate)
#> 
#> Attaching package: ‘lubridate’
#> The following objects are masked from ‘package:base’:
#> 
#>     date, intersect, setdiff, union

set.seed(20)
n <- 10

date_ranges <- tibble(
  start = make_date(
    year = 2026,
    month = sample(1:12, size = n, replace = TRUE),
    day = sample(1:28, size = n, replace = TRUE)
  ),
  end = start + days(sample(1:20, size = n, replace = TRUE))
)

date_ranges
#> # A tibble: 10 × 2
#>    start      end       
#>    <date>     <date>    
#>  1 2026-06-18 2026-06-23
#>  2 2026-11-20 2026-11-29
#>  3 2026-08-09 2026-08-11
#>  4 2026-02-21 2026-02-26
#>  5 2026-09-17 2026-09-19
#>  6 2026-02-25 2026-03-16
#>  7 2026-09-06 2026-09-14
#>  8 2026-03-08 2026-03-21
#>  9 2026-09-20 2026-10-09
#> 10 2026-08-22 2026-08-31

bind_count_bizdays(date_ranges, from = start, to = end, holidays = as.Date(NA))
#> # A tibble: 10 × 3
#>    start      end        n_bizdays
#>    <date>     <date>         <dbl>
#>  1 2026-06-18 2026-06-23         4
#>  2 2026-11-20 2026-11-29         6
#>  3 2026-08-09 2026-08-11         2
#>  4 2026-02-21 2026-02-26         4
#>  5 2026-09-17 2026-09-19         2
#>  6 2026-02-25 2026-03-16        14
#>  7 2026-09-06 2026-09-14         6
#>  8 2026-03-08 2026-03-21        10
#>  9 2026-09-20 2026-10-09        15
#> 10 2026-08-22 2026-08-31         6
```
