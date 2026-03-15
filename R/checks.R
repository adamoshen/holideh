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
