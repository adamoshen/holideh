# Get holidays for a province or territory from the Canada Holidays API

Get all holidays for a given year, for a province or territory. Best
used to obtain holiday information for a specific province or territory.

## Usage

``` r
get_province(province, year = NULL, optional = NULL)
```

## Arguments

- province:

  The two letter abbreviation for a province/territory (case-sensitive).

- year:

  The year for which holidays should be retrieved, between 2013
  and 2038. The default, `NULL`, is equivalent to the current year.

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

- province_id:

  `<chr>` The abbreviated province/territory code.

- province_name_en:

  `<chr>` The name of the province/territory, in English.

- province_name_fr:

  `<chr>` The name of the province/territory, in French.

- source_info:

  `<list>` A list containing a link to the information source.

## Details

Province and territory codes:

- Alberta: `"AB"`

- British Columbia: `"BC"`

- Manitoba: `"MB"`

- New Brunswick: `"NB"`

- Newfoundland and Labrador: `"NL"`

- Nova Scotia: `"NS"`

- Northwest Territories: `"NT"`

- Nunavut: `"NU"`

- Ontario: `"ON"`

- Prince Edward Island: `"PE"`

- Quebec: `"QC"`

- Saskatchewan: `"SK"`

- Yukon: `"YT"`

## See also

[`get_holidays()`](https://adamoshen.github.io/holideh/reference/get_holidays.md),
[Canada Holidays API](https://canada-holidays.ca/)

## Examples

``` r
if (interactive()) {
  get_province(province = "ON")
}
```
