#' Get all provinces and territories and their holidays from the Canada Holidays API
#'
#' Get all provinces and territories, and their holidays for a given year. Best used to obtain
#' holiday information by province and territory, for all provinces and territories.
#'
#' @param year The year for which holidays should be retrieved, between 2013 and 2038. The default,
#' `NULL`, is equivalent to the current year.
#' @param optional A boolean indicating whether optional (non-legislated) holidays should be
#' retrieved. The default, `NULL`, is equivalent to `FALSE`.
#' @returns A [tibble][tibble::tibble-package] with columns:
#' \describe{
#' \item{province_id}{`<chr>` The abbreviated province/territory code.}
#' \item{province_name_en}{`<chr>` The name of the province/territory, in English.}
#' \item{province_name_fr}{`<chr>` The name of the province/territory, in French.}
#' \item{holidays}{`<list>` See below.}
#' \item{source_info}{`<list>` A list containing a link to the information source.}
#' }
#' The [tibbles][tibble::tibble-package] contained inside `holidays` are:
#' \describe{
#' \item{date}{`<date>` The date when the holiday occurs.}
#' \item{observed_date}{`<date>` The date when the holiday is observed (celebrated). For example,
#' if Christmas Day falls on a Sunday, it is observed (celebrated) on the proceeding Monday.}
#' \item{name_en}{`<chr>` The name of the holiday, in English.}
#' \item{name_fr}{`<chr>` The name of the holiday, in French.}
#' \item{federal}{`<lgl>` Whether the holiday is a federal holiday.}
#' \item{holiday_id}{`<int>` The id of the holiday.}
#' }
#' @examples
#' if (interactive()) {
#'   get_provinces()
#' }
#' @seealso [Canada Holidays API](https://canada-holidays.ca/)
#' @export
get_provinces <- function(year = NULL, optional = NULL) {
  # ---- Checks and type conversions ----

  check_number_whole(year, min = 2013, max = 2038, allow_null = TRUE)
  check_bool(optional, allow_null = TRUE)

  optional <- as.character(optional) %>%
    stringr::str_to_lower()

  # ---- Collect data ----

  req <- httr2::request("https://canada-holidays.ca/api/v1") %>%
    httr2::req_user_agent("holideh R package (https://adamoshen.github.io/holideh)") %>%
    httr2::req_url_path_append("provinces")

  resp <- req %>%
    httr2::req_url_query(year = year, optional = optional) %>%
    httr2::req_perform()

  result <- resp %>%
    httr2::resp_body_json(simplifyVector = TRUE) %>%
    purrr::pluck("provinces")

  # ---- Process results ----

  outer_col_names <- c(
    "province_id" = "id",
    "province_name_en" = "nameEn",
    "province_name_fr" = "nameFr",
    "holidays" = "holidays",
    "source_info" = "source_info"
  )

  inner_col_names <- c(
    "date" = "date",
    "observed_date" = "observedDate",
    "name_en" = "nameEn",
    "name_fr" = "nameFr",
    "federal" = "federal",
    "holiday_id" = "id"
  )

  result %>%
    tibble::as_tibble() %>%
    dplyr::select(-nextHoliday) %>%
    tidyr::nest(source_info = tidyselect::starts_with("source")) %>%
    dplyr::rename(tidyselect::all_of(outer_col_names)) %>%
    dplyr::mutate(
      province_name_fr = utf8::utf8_normalize(province_name_fr, map_compat = TRUE)
    ) %>%
    dplyr::mutate(
      holidays = purrr::map(holidays, tibble::as_tibble),
      holidays = purrr::map(holidays, \(x) dplyr::rename(x, tidyselect::all_of(inner_col_names))),
      holidays = purrr::map(
        holidays,
        \(x) dplyr::mutate(
          x,
          date = lubridate::ymd(date),
          observed_date = lubridate::ymd(observed_date),
          name_en = utf8::utf8_normalize(name_en, map_quote = TRUE),
          name_fr = utf8::utf8_normalize(name_fr, map_compat = TRUE, map_quote = TRUE),
          name_fr = stringr::str_trim(name_fr),
          federal = as.logical(federal)
        )
      ),
      holidays = purrr::map(
        holidays,
        \(x) dplyr::select(x, date, observed_date, name_en, name_fr, federal, holiday_id)
      )
    )
}
