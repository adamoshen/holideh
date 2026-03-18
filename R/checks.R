#' @noRd
check_province <- function(x, allow_null = FALSE, call = rlang::caller_env()) {
  valid_provinces <- c("AB", "BC", "MB", "NB", "NL", "NS", "NT", "NU", "ON", "PE", "QC", "SK", "YT")

  if (is.null(x) && allow_null) {
    return(invisible(NULL))
  }

  if (x %in% valid_provinces) {
    return(invisible(NULL))
  }

  cli::cli_abort("{.str {x}} is not a valid province code.", call = call)
}

check_date <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  if (inherits(x, "Date")) {
    return(invisible(NULL))
  }

  cli::cli_abort(
    "{.arg {arg}} must be an object of class {.cls Date}.",
    call = call
  )
}

check_wdays <- function(
  x,
  arg = rlang::caller_arg(x),
  call = rlang::caller_env()
) {
  wday_abbrs <- c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")

  if (all(x %in% wday_abbrs)) {
    return(invisible(NULL))
  }

  cli::cli_abort(
    c(
      "{.arg {arg}} contains invalid day names.",
      "i" = "Acceptable values are one or more of: {.val {wday_abbrs}}."
    ),
    call = call
  )
}
