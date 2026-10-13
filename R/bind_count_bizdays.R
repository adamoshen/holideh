#' Bind the count of business days to a data frame
#'
#' Bind the count of the number of business days between an inclusive range of dates, stored in
#' columns of a data frame, to the data frame.
#'
#' @param x A data frame, or data frame extension.
#' @param from The column of `x` containing the start of date ranges.
#' @param to The column of `x` containing the end of date ranges.
#' @param holidays A vector of dates that are holidays.
#' @param weekend A character vector of three-letter abbreviations of weekday names indicating days
#' that should be considered a weekend. Acceptable values are: `"Sun"`, `"Mon"`, `"Tue"`, `"Wed"`,
#' `"Thu"`, `"Fri"`, `"Sat"`.
#' @returns A data frame of the same type as `x`, with an additional column named `n_bizdays`.
#' @seealso [count_bizdays()]
#' @examples
#' library(tibble)
#' library(lubridate)
#'
#' set.seed(20)
#' n <- 10
#'
#' date_ranges <- tibble(
#'   start = make_date(
#'     year = 2026,
#'     month = sample(1:12, size = n, replace = TRUE),
#'     day = sample(1:28, size = n, replace = TRUE)
#'   ),
#'   end = start + days(sample(1:20, size = n, replace = TRUE))
#' )
#'
#' date_ranges
#'
#' bind_count_bizdays(date_ranges, from = start, to = end, holidays = as.Date(NA))
#' @export
bind_count_bizdays <- function(x, from, to, holidays, weekend = c("Sat", "Sun")) {
  check_data_frame(x)
  check_column_exists(x, {{ from }})
  check_column_exists(x, {{ to }})
  check_date(holidays)
  check_wdays(weekend)

  min_date <- dplyr::pull(x, {{ from }}) %>%
    min(na.rm = TRUE)
  max_date <- dplyr::pull(x, {{ to }}) %>%
    max(na.rm = TRUE)

  ref_seq <- seq.Date(from = min_date, to = max_date, by = "1 day") %>%
    purrr::keep(\(x) is_bizday(x, holidays = holidays, weekend = weekend))

  dplyr::mutate(
    x,
    n_bizdays = match(lubridate::floor_date({{ to }}, ref_seq), ref_seq) -
      match(lubridate::ceiling_date({{ from }}, ref_seq), ref_seq) + 1
  )
}
