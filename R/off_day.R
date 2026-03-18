#' Detect non-business days
#'
#' In a vector of dates, detect the non-business days (holiday or weekend).
#'
#' Holiday dates can be obtained using [get_holidays()], [get_province()], or by defining a custom
#' vector of holidays.
NULL

#' @param x A vector of dates or date-times. If date-times are supplied, the date component will be
#' extracted.
#' @param holidays A vector of dates that are holidays.
#' @returns A named logical vector of length equal to `x`.
#' @export
is_holiday <- function(x, holidays) {
  # If x is a datetime, extract the date component
  if (inherits(x, c("POSIXct", "POSIXt"))) {
    x <- lubridate::date(x)
  }

  check_date(holidays)

  x %in% holidays
}

#' @param weekend A character vector of three-letter abbreviations of weekday names indicating days
#' that should be considered a weekend. Acceptable values are: `"Sun"`, `"Mon"`, `"Tue"`, `"Wed"`,
#' `"Thu"`, `"Fri"`, `"Sat"`, `"Sun"`.
#' @export
is_weekend <- function(x, weekend = c("Sat", "Sun")) {
  lubridate::wday(x, label = TRUE) %in% weekend
}
