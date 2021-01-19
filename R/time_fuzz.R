#' time_fuzz
#' 
#' @export
#' @details
#' **Methods**
#'   \describe{
#'     \item{`freeze(...)`}{
#'       Freeze time
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
#' x$freeze("2019-01-29", {
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
#' # pendulum::clock_mock()
#' pendulum:::clock_opts$mock
#' (cl <- clock())
#' book_due <- function(due_date = "2020-08-25") {
#'   as.POSIXct(pendulum::clock()$date()) > as.POSIXct(due_date)
#' }
#' expect_false(book_due()) # FALSE
#' x <- time_fuzz$new()
#' x
#' x$freeze(Sys.Date() + 60, {
#'   # pendulum::clock_mock()
#'   # cat(pendulum:::clock_opts$mock, sep = "\n")
#'   # cat(as.character(pendulum::clock()$date()), sep = "\n")
#'   # cat(pendulum:::clock_opts$mock, sep = "\n")
#'   expect_true(book_due())
#' })
#' 
#' # no block passed
#' clock_mock()
#' clock()$now()
#' Sys.time()
#' x <- time_fuzz$new()
#' ## set to today + 435 days
#' x$freeze(Sys.Date() + 435)
#' pendulum:::clock_opts$mock
#' clock()$now()
#' x$unfreeze()
#' pendulum:::clock_opts$mock
#' clock()$now()
#' }
time_fuzz <- R6::R6Class(
  "time_fuzz",
  public = list(
    date = NULL,

    print = function(x, expr) {
      cat("<time_fuzz> ", sep = "\n")
      cat(paste0("  date: ", self$date), sep = "\n")
    },

    freeze = function(date, block = NULL) {
      stack_item <- TimeStackItem$new(mock_type = "freeze", date)
      fuzzy_env$stack_item <- stack_item
      pendulum::clock_mock()
      if (!is.null(block)) block <- rlang::enquo(block)
      if (is.null(block)) return(invisible())
      if (!is.null(block)) {
        on.exit(stack_item$unfreeze())
        rlang::eval_tidy(block)
      }
    },

    unfreeze = function() {
      pendulum::clock_mock(FALSE)
      fuzzy_env$stack_item <- NULL
    }
  )
)
