#' Get holidays from the Canada Holidays API
#'
#' Get holidays from the Canada Holidays API.
#'
#' @param year The year for which holidays should be retrieved. The default, `NULL`, is equivalent
#' to the current year.
#' @param federal A boolean indicating whether only federal holidays should be retrieved. The
#' default, `NULL`, is equivalent to `FALSE`.
#' @param optional A boolean indicating whether optional (non-legislated) holidays should be
#' retrieved. The default, `NULL`, is equivalent to `FALSE`.
#' @returns A [tibble][tibble::tibble-package] with columns:
#' \describe{
#' \item{date}{`<date>` The date when the holiday occurs.}
#' \item{observed_date}{`<date>` The date when the holiday is observed (celebrated). For example,
#' if Christmas Day falls on a Sunday, it is observed (celebrated) on the proceeding Monday.}
#' \item{name_en}{`<chr>` The name of the holiday, in English.}
#' \item{name_fr}{`<chr>` The name of the holiday, in French.}
#' \item{federal}{`<lgl>` Whether the holiday is a federal holiday.}
#' \item{holiday_id}{`<int>` The id of the holiday.}
#' \item{provinces}{`<list>` A list of tibbles containing information on the provinces observing
#' the holiday and source links.}
#' }
#' @examples
#' get_holidays()
#' @seealso [Canada Holidays API](https://canada-holidays.ca/)
#' @export
get_holidays <- function(year = NULL, federal = NULL, optional = NULL) {
  # ---- Checks and type conversions ----

  check_number_whole(year, min = 2013, max = 2038, allow_null = TRUE)
  check_bool(federal, allow_null = TRUE)
  check_bool(optional, allow_null = TRUE)

  federal <- as.character(federal) %>%
    stringr::str_to_lower()
  optional <- as.character(optional) %>%
    stringr::str_to_lower()

  # ---- Collect data ----

  req <- httr2::request("https://canada-holidays.ca/api/v1") %>%
    httr2::req_user_agent("holideh R package (https://adamoshen.github.io/holideh)") %>%
    httr2::req_url_path_append("holidays")

  resp <- req %>%
    httr2::req_url_query(year = year, federal = federal, optional = optional) %>%
    httr2::req_perform()

  result <- resp %>%
    httr2::resp_body_json(simplifyVector = TRUE) %>%
    purrr::pluck("holidays")

  # ---- Process results ----

  outer_col_names <- c(
    "holiday_id" = "id",
    "date" = "date",
    "name_en" = "nameEn",
    "name_fr" = "nameFr",
    "federal" = "federal",
    "observed_date" = "observedDate",
    "provinces" = "provinces"
  )

  inner_col_names <- c(
    "province_id" = "id",
    "province_name_en" = "nameEn",
    "province_name_fr" = "nameFr",
    "source_link" = "sourceLink",
    "source_name_en" = "sourceEn"
  )

  result %>%
    tibble::as_tibble() %>%
    dplyr::rename(tidyselect::all_of(outer_col_names)) %>%
    dplyr::select(date, observed_date, name_en, name_fr, federal, holiday_id, provinces) %>%
    dplyr::mutate(
      provinces = purrr::map(provinces, tibble::as_tibble),
      # Need to use `any_of` instead of `all_of` since there may be zero-column tibbles
      provinces = purrr::map(provinces, \(x) dplyr::rename(x, tidyselect::any_of(inner_col_names)))
    ) %>%
    dplyr::mutate(
      date = lubridate::ymd(date),
      observed_date = lubridate::ymd(observed_date),
      name_en = utf8::utf8_normalize(name_en, map_quote = TRUE),
      name_fr = utf8::utf8_normalize(name_fr, map_compat = TRUE, map_quote = TRUE),
      name_fr = stringr::str_trim(name_fr),
      federal = as.logical(federal)
    )
}
