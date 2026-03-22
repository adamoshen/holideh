# Get holidays from the Canada Holidays API

Get all holidays for a given year. Best used for obtaining a list of
federal holidays.

## Usage

``` r
get_holidays(year = NULL, federal = NULL, optional = NULL)
```

## Arguments

- year:

  The year for which holidays should be retrieved, between 2013
  and 2038. The default, `NULL`, is equivalent to the current year.

- federal:

  A boolean indicating whether only federal holidays should be
  retrieved. The default, `NULL`, is equivalent to `FALSE`.

- optional:

  A boolean indicating whether optional (non-legislated) holidays should
  be retrieved. The default, `NULL`, is equivalent to `FALSE`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble-package.html)
with columns:

- date:

  `<date>` The date when the holiday occurs.

- observed_date:

  `<date>` The date when the holiday is observed (celebrated). For
  example, if Christmas Day falls on a Sunday, it is observed
  (celebrated) on the proceeding Monday.

- name_en:

  `<chr>` The name of the holiday, in English.

- name_fr:

  `<chr>` The name of the holiday, in French.

- federal:

  `<lgl>` Whether the holiday is a federal holiday.

- holiday_id:

  `<int>` The id of the holiday.

- provinces:

  `<list>` A list of tibbles containing information on the provinces
  observing the holiday and source links.

## See also

[`get_province()`](https://adamoshen.github.io/holideh/reference/get_province.md),
[Canada Holidays API](https://canada-holidays.ca/)

## Examples

``` r
if (interactive()) {
  get_holidays()
}
```
