# A data class for carrying around "time movement" objects.
# Makes it easy to keep track of the time movements on a simple stack.

#' TimeStackItem
#' @export
#' @examples \dontrun{
#' x <- TimeStackItem$new(mock_type = "freeze", date = "2019-02-18")
#' x
#' x$time
#' x$time$time
#' x$time$year
#' x$scaling_factor_
#' x$travel_offset_
#' x$year()
#' x$min()
#' }
TimeStackItem <- R6::R6Class(
  "TimeStackItem",
  public = list(
    scaling_factor_ = NULL,
    travel_offset_  = NULL,
    mock_type       = NULL,
    time            = NULL,
    time_was        = NULL,

    initialize = function(mock_type, date) {
      if (!mock_type %in% c("freeze", "travel", "scale"))
        stop(paste("Unknown mock_type ", mock_type))
      self$scaling_factor_ <- if (mock_type == "scale") date else NULL
      self$mock_type       <- mock_type
      self$time            <- parse_time(date)
      try_now_wo_mock <- tryCatch(clock::clock()$now_without_mock_time(),
        error = function(e) e)
      self$time_was        <- if (inherits(try_now_wo_mock, "error"))
        clock::clock()$now()
      else
        try_now_wo_mock
      # self$travel_offset_  <- private$compute_travel_offset()
      # private$old_sys_date <- Sys.Date
      # unlockBinding("Sys.Date", "pkg:base")
      # unlockBinding("Sys.Date", asNamespace("base"))
      # utils::assignInNamespace("Sys.Date", timefuzz_sys_date, "base")
    },

    # date parts
    year = function() self$time$year,
    month = function() self$time$month,
    day = function() self$time$day,
    hour = function() self$time$hour,
    min = function() self$time$min,
    sec = function() self$time$sec,
    utc_offset = function() self$time$utc_offset,

    travel_offset = function()
      if (!self$mock_type == "freeze") self$travel_offset_,
    travel_offset_days = function() round(self$travel_offset_ / 60 / 60 / 24),
    scaling_factor = function() self$scaling_factor_,

    return = function() clock::clock_mock(FALSE)
  ),

  private = list(
    # old_sys_date = NULL,
    compute_travel_offset = function() {
      self$time$time - clock::clock()$now_without_mock_time()
    }
  )
)

parse_time <- function(x) {
  parsed_date <- tryCatch(as.POSIXct(x), error = function(e) e)
  if (inherits(parsed_date, "error")) stop(x, " was not parseable as a date")
  z <- list(
    # time = parsed_date,
    year = format(parsed_date, format = "%Y"),
    month = format(parsed_date, format = "%m"),
    day = format(parsed_date, format = "%d"),
    hour = format(parsed_date, format = "%H"),
    min = format(parsed_date, format = "%M"),
    sec = format(parsed_date, format = "%S")
    # utc_offset = format(parsed_date, format = "%z")
  )
  return(do.call(clock::clock, z))
}

# timefuzz_sys_date <- function() {
#   fuzzy_env$stack_item$time()
# }
