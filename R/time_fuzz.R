#' time_fuzz
#' 
#' @export
#' @details
#' **Methods**
#'   \describe{
#'     \item{`freeze(...)`}{
#'       Freez time
#'     }
#'   }
#'
#' @format NULL
#' @usage NULL
#' @return an [time_fuzz] object
#' @examples \dontrun{
#' x <- time_fuzz$new()
#' x
#' x$date
#' 
#' x <- time_fuzz$new()
#' x
#' x$freeze
#' x$freeze(x = "2019-01-29", {
#'   5 + 5
#' })
#' 
#' x$scale
#' x$scale({
#'   5 + 5
#' })
#' 
#' library(timefuzz)
#' library(clock)
#' library(testthat)
#' # clock::clock_mock()
#' clock:::clock_opts$mock
#' (cl <- clock())
#' book_due <- function(due_date = "2019-02-25") {
#'   as.POSIXct(clock::clock()$date()) > as.POSIXct(due_date)
#' }
#' expect_false(book_due()) # FALSE
#' x <- time_fuzz$new()
#' x
#' x$freeze(Sys.Date() + 30, {
#'   # clock::clock_mock()
#'   # cat(clock:::clock_opts$mock, sep = "\n")
#'   # cat(as.character(clock::clock()$date()), sep = "\n")
#'   # cat(clock:::clock_opts$mock, sep = "\n")
#'   expect_true(book_due())
#' })
#' 
#' # no block passed
#' clock()$now()
#' Sys.time()
#' x <- time_fuzz$new()
#' ## set to today + 435 days
#' x$freeze(Sys.Date() + 435)
#' clock:::clock_opts$mock
#' clock()$now()
#' x$return()
#' clock:::clock_opts$mock
#' clock()$now()
#' }
time_fuzz <- R6::R6Class(
  "time_fuzz",
  public = list(
    date = NULL,

    print = function(x, ...) {
      cat("<time_fuzz> ", sep = "\n")
      cat(paste0("  date: ", self$date), sep = "\n")
    },

    freeze = function(date, ...) {
      stack_item <- TimeStackItem$new(mock_type = "freeze", date)
      fuzzy_env$stack_item <- stack_item
      clock::clock_mock()
      input <- substitute(...)
      if (is.null(input)) return(invisible())
      if (!is.null(input)) {
        on.exit(stack_item$return())
        eval(input)
      }
    },

    return = function() {
      clock::clock_mock(FALSE)
      fuzzy_env$stack_item <- NULL
    }
  )
)
