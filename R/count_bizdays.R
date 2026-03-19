#' Count the number of business days between a range
#'
#' Count the number of business days between a range of dates, inclusively.
#'
#' Holiday dates can be obtained using [get_holidays()], [get_province()], or by defining a custom
#' vector of holidays.
#'
#' @param from The beginning of the date range.
#' @param to The end of the date range.
#' @param holidays A vector of dates that are holidays.
#' @param weekend A character vector of three-letter abbreviations of weekday names indicating days
#' that should be considered a weekend. Acceptable values are: `"Sun"`, `"Mon"`, `"Tue"`, `"Wed"`,
#' `"Thu"`, `"Fri"`, `"Sat"`, `"Sun"`.
#' @returns A single number.
#' @seealso [is_bizday()], [is_holiday()], [is_weekend()]
#' @examples
#' library(lubridate)
#'
#' winter_holidays <- ymd(c("2025-12-25", "2025-12-26"))
#'
#' n_bizdays(from = ymd("2025-12-20"), to = ymd("2025-12-31"), holidays = winter_holidays)
#' @export
count_bizdays <- function(from, to, holidays, weekend = c("Sat", "Sun")) {
  if (length(from) != 1 | length(to) != 1) {
    cli::cli_abort(
      "{.arg from} and {.arg to} must both be of length one."
    )
  }

  # If datetimes are supplied, extract the date component
  if (inherits(from, c("POSIXct", "POSIXt"))) {
    from <- lubridate::date(from)
  }

  if (inherits(to, c("POSIXct", "POSIXt"))) {
    to <- lubridate::date(to)
  }

  if (to < from) {
    cli::cli_abort(
      c(
        "{.arg to} ({.val {to}}) occurs before {.arg from} ({.val {from}}).",
        "i" = "{.arg to} must be a date occurring after {.arg from}."
      )
    )
  }

  check_date(holidays)
  check_wdays(weekend)

  seq.Date(from = from, to = to, by = "1 day") %>%
    is_bizday(holidays = holidays, weekend = weekend) %>%
    length()
}
