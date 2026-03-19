#' Detect business days
#'
#' In a vector of dates, detect the business days (i.e. exclude holidays and weekends).
#'
#' Holiday dates can be obtained using [get_holidays()], [get_province()], or by defining a custom
#' vector of holidays.
#'
#' @param x A vector of dates or date-times. If date-times are supplied, the date component will be
#' extracted.
#' @param holidays A vector of dates that are holidays.
#' @param weekend A character vector of three-letter abbreviations of weekday names indicating days
#' that should be considered a weekend. Acceptable values are: `"Sun"`, `"Mon"`, `"Tue"`, `"Wed"`,
#' `"Thu"`, `"Fri"`, `"Sat"`, `"Sun"`.
#' @returns A logical vector of length equal to `x`.
#' @seealso [is_holiday()], [is_weekend()], [count_bizdays()]
#' @examples
#' library(lubridate)
#'
#' dates <- seq.Date(from = ymd("2025-12-20"), to = ymd("2025-12-31"), by = "1 day")
#' winter_holidays <- ymd(c("2025-12-25", "2025-12-26"))
#'
#' rlang::set_names(is_bizday(dates, holidays = winter_holidays), dates)
#' @export
is_bizday <- function(x, holidays, weekend = c("Sat", "Sun")) {
  check_date(holidays)
  check_wdays(weekend)

  !is_weekend(x, weekend = weekend) & !is_holiday(x, holidays = holidays)
}
